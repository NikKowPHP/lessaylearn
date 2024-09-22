import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/features/statistics/providers/chart_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:lessay_learn/core/providers/known_word_provider.dart';
import 'package:lessay_learn/core/providers/favorite_provider.dart';
import 'package:word_cloud/word_cloud.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  String? selectedLanguageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDefaultLanguage();
    });
  }

  void _initializeDefaultLanguage() async {
    final currentUser = await ref.read(currentUserProvider.future);
    final languages =
        await ref.read(userLanguagesProvider(currentUser.id).future);
    if (languages.isNotEmpty) {
      setState(() {
        selectedLanguageId = languages.first.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Statistics'),
      ),
      child: SafeArea(
        child: currentUserAsync.when(
          data: (currentUser) => _buildContent(currentUser.id),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildContent(String userId) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLanguageSelector(userId),
          ),
        ),
        if (selectedLanguageId != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildOverallProgressChart(userId),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Skill Breakdown',
                style:
                    CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSkillChart(userId, 'Reading'),
              _buildSkillChart(userId, 'Writing'),
              _buildSkillChart(userId, 'Speaking'),
              _buildSkillChart(userId, 'Listening'),
            ]),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildWordStats(userId),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLexicalFieldDiagram(userId),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: _buildWordCloud(userId),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildWordGrowthChart(userId),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLanguageSelector(String userId) {
    final userLanguagesAsync = ref.watch(userLanguagesProvider(userId));

    return userLanguagesAsync.when(
      data: (languages) => CupertinoSlidingSegmentedControl<String>(
        groupValue: selectedLanguageId,
        children: {
          for (var lang in languages)
            lang.id: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(lang.name),
            ),
        },
        onValueChanged: (value) {
          if (value != null) {
            setState(() {
              selectedLanguageId = value;
            });
          }
        },
      ),
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }

  Widget _buildOverallProgressChart(String userId) {
    final chartAsync = ref.watch(languageChartProvider(
        (userId: userId, languageId: selectedLanguageId!)));

    return chartAsync.when(
      data: (chart) {
        if (chart == null) {
          return const Text('No data available for this language');
        }
        return SizedBox(
          height: 300,
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  fillColor: CupertinoColors.activeBlue.withOpacity(0.2),
                  borderColor: CupertinoColors.activeBlue,
                  dataEntries: [
                    RadarEntry(value: chart.reading),
                    RadarEntry(value: chart.writing),
                    RadarEntry(value: chart.speaking),
                    RadarEntry(value: chart.listening),
                  ],
                ),
              ],
              radarShape: RadarShape.polygon,
              radarBackgroundColor: CupertinoColors.systemBackground,
              borderData: FlBorderData(show: false),
              radarBorderData:
                  BorderSide(color: CupertinoColors.systemGrey, width: 1),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle:
                  const TextStyle(color: CupertinoColors.label, fontSize: 14),
              getTitle: (index, _) {
                switch (index) {
                  case 0:
                    return RadarChartTitle(text: 'Reading');
                  case 1:
                    return RadarChartTitle(text: 'Writing');
                  case 2:
                    return RadarChartTitle(text: 'Speaking');
                  case 3:
                    return RadarChartTitle(text: 'Listening');
                  default:
                    return RadarChartTitle(text: '');
                }
              },
              tickCount: 5,
              ticksTextStyle: const TextStyle(
                  color: CupertinoColors.systemGrey, fontSize: 10),
              tickBorderData: BorderSide(
                  color: CupertinoColors.systemGrey.withOpacity(0.3)),
              gridBorderData: BorderSide(
                  color: CupertinoColors.systemGrey.withOpacity(0.3), width: 1),
            ),
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }

  Widget _buildSkillChart(String userId, String skill) {
    final chartAsync = ref.watch(languageChartProvider(
        (userId: userId, languageId: selectedLanguageId!)));

    return chartAsync.when(
      data: (chart) {
        if (chart == null) {
          return const SizedBox.shrink();
        }
        double value;
        switch (skill) {
          case 'Reading':
            value = chart.reading;
            break;
          case 'Writing':
            value = chart.writing;
            break;
          case 'Speaking':
            value = chart.speaking;
            break;
          case 'Listening':
            value = chart.listening;
            break;
          default:
            value = 0;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skill,
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CupertinoLinearProgressIndicator(
                    value: value,
                    backgroundColor: CupertinoColors.systemGrey5,
                    valueColor: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(value * 100).toStringAsFixed(1)}%',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }

  Widget _buildWordStats(String userId) {
    final knownWordsAsync = ref.watch(
        knownWordsByUserAndLanguageProvider((userId, selectedLanguageId!)));
    final favoritesAsync = ref.watch(
        favoritesByUserAndLanguageProvider((userId, selectedLanguageId!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Word Statistics',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        const SizedBox(height: 16),
        knownWordsAsync.when(
          data: (knownWords) => _buildWordStatItem('Known Words', knownWords),
          loading: () => const CupertinoActivityIndicator(),
          error: (_, __) => const Text('Error loading known words'),
        ),
        const SizedBox(height: 8),
        favoritesAsync.when(
          data: (favorites) => _buildWordStatItem('Favorite Words', favorites),
          loading: () => const CupertinoActivityIndicator(),
          error: (_, __) => const Text('Error loading favorites'),
        ),
      ],
    );
  }

  Widget _buildWordStatItem(String title, List<dynamic> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CupertinoTheme.of(context).textTheme.textStyle),
        Text(
          items.length.toString(),
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
        ),
      ],
    );
  }

  Widget _buildLexicalFieldDiagram(String userId) {
    final knownWordsAsync = ref.watch(knownWordsByUserAndLanguageProvider((userId, selectedLanguageId!)));
    final favoritesAsync = ref.watch(favoritesByUserAndLanguageProvider((userId, selectedLanguageId!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lexical Field',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: knownWordsAsync.when(
            data: (knownWords) => favoritesAsync.when(
              data: (favorites) => PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: CupertinoColors.activeBlue,
                      value: knownWords.length.toDouble(),
                      title: 'Known',
                      radius: 100,
                      titleStyle: const TextStyle(color: CupertinoColors.white, fontSize: 16),
                    ),
                    PieChartSectionData(
                      color: CupertinoColors.activeOrange,
                      value: favorites.length.toDouble(),
                      title: 'Favorites',
                      radius: 100,
                      titleStyle: const TextStyle(color: CupertinoColors.white, fontSize: 16),
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
              loading: () => const CupertinoActivityIndicator(),
              error: (_, __) => const Text('Error loading favorites'),
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const Text('Error loading known words'),
          ),
        ),
      ],
    );
  }

  Widget _buildWordCloud(String userId) {
    final knownWordsAsync = ref.watch(knownWordsByUserAndLanguageProvider((userId, selectedLanguageId!)));
    final favoritesAsync = ref.watch(favoritesByUserAndLanguageProvider((userId, selectedLanguageId!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Word Cloud',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: knownWordsAsync.when(
            data: (knownWords) => favoritesAsync.when(
              data: (favorites) {
                // Prepare data for the word cloud
                List<Map<String, dynamic>> dataList = [];
                for (var word in knownWords) {
                  dataList.add({'word': word.word, 'value': 1}); // Assuming each known word has a value of 1
                }
                for (var favorite in favorites) {
                  dataList.add({'word': favorite.sourceText, 'value': 1}); // Assuming each favorite has a value of 1
                }

                // Create WordCloudData
                WordCloudData wordCloudData = WordCloudData(data: dataList);

                // Debugging: Check the data being passed
                print("Word Cloud Data: $dataList");

                return WordCloudView(
                  data: wordCloudData,
                  mapwidth: 500,
                  mapheight: 300,
                  mapcolor: CupertinoColors.systemGrey5,
                  colorlist: [
                    CupertinoColors.activeBlue,
                    CupertinoColors.activeOrange,
                    CupertinoColors.activeGreen,
                  ],
                  mintextsize: 10, // Ensure this is a positive value
                  maxtextsize: 100, // Ensure this is a positive value
                );
              },
              loading: () => const CupertinoActivityIndicator(),
              error: (_, __) => const Text('Error loading favorites'),
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const Text('Error loading known words'),
          ),
        ),
      ],
    );
  }

  Widget _buildWordGrowthChart(String userId) {
    final knownWordsAsync = ref.watch(knownWordsByUserAndLanguageProvider((userId, selectedLanguageId!)));
    final favoritesAsync = ref.watch(favoritesByUserAndLanguageProvider((userId, selectedLanguageId!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Word Growth Over Time',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        const SizedBox(height: 16),
        // Chart for Known Words
        SizedBox(
          height: 300,
          child: knownWordsAsync.when(
            data: (List<KnownWordModel> knownWords) => LineChart(
              _buildLineChartData(knownWords, 'Known Words'),
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const Text('Error loading known words'),
          ),
        ),
        const SizedBox(height: 16),
        // Chart for Favorites
        SizedBox(
          height: 300,
          child: favoritesAsync.when(
            data: (List<FavoriteModel> favorites) => LineChart(
              _buildLineChartData(favorites, 'Favorites'),
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const Text('Error loading favorites'),
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(List<dynamic> items, String title) {
    final spots = _createSpots(items);
  
    if (spots.isEmpty) {
      // Return empty chart data if there are no spots
      return LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [],
      );
    }

    final minX = spots.first.x;
    final maxX = spots.last.x;
    final maxY = spots.map((spot) => spot.y).reduce((max, value) => value > max ? value : max);

    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(DateFormat('MM/dd').format(date), style: TextStyle(fontSize: 10)),
              );
            },
            interval: spots.length > 1 ? (maxX - minX) / (spots.length > 5 ? 5 : spots.length - 1) : 1,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: title == 'Known Words' ? CupertinoColors.activeBlue : CupertinoColors.activeOrange,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: (title == 'Known Words' ? CupertinoColors.activeBlue : CupertinoColors.activeOrange).withOpacity(0.2),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
              return LineTooltipItem(
                '${DateFormat('MM/dd').format(date)}: ${touchedSpot.y.toInt()} ${title.toLowerCase()}',
                TextStyle(color: CupertinoColors.label),
              );
            }).toList();
          },
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY > 0 ? maxY : 1, // Ensure maxY is always positive
    );
  }
List<FlSpot> _createSpots(List<dynamic> items) {
    final Map<String, int> wordCounts = {};

    for (var item in items) {
      final date = DateFormat('yyyy-MM-dd').format(item.createdAt);
      wordCounts[date] = (wordCounts[date] ?? 0) + 1;
    }

    final sortedEntries = wordCounts.entries.toList()
      ..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.key).compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));

    int cumulativeCount = 0;
    return sortedEntries.map((entry) {
      cumulativeCount += entry.value;
      return FlSpot(
        DateFormat('yyyy-MM-dd').parse(entry.key).millisecondsSinceEpoch.toDouble(),
        cumulativeCount.toDouble(),
      );
    }).toList();
  }
}

class CupertinoLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color valueColor;

  const CupertinoLinearProgressIndicator({
    Key? key,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: valueColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
