import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/features/statistics/providers/chart_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:lessay_learn/core/providers/known_word_repository_provider.dart';
import 'package:lessay_learn/core/providers/favorite_repository_provider.dart';

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
    final languages = await ref.read(userLanguagesProvider(currentUser.id).future);
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
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
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
    final chartAsync = ref.watch(languageChartProvider((userId: userId, languageId: selectedLanguageId!)));

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
              radarBorderData: BorderSide(color: CupertinoColors.systemGrey, width: 1),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle: const TextStyle(color: CupertinoColors.label, fontSize: 14),
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
              ticksTextStyle: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 10),
              tickBorderData: BorderSide(color: CupertinoColors.systemGrey.withOpacity(0.3)),
              gridBorderData: BorderSide(color: CupertinoColors.systemGrey.withOpacity(0.3), width: 1),
            ),
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }

  Widget _buildSkillChart(String userId, String skill) {
    final chartAsync = ref.watch(languageChartProvider((userId: userId, languageId: selectedLanguageId!)));

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
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontWeight: FontWeight.bold),
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
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey),
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
  final knownWordsAsync = ref.watch(knownWordsByUserAndLanguageProvider((userId, selectedLanguageId!)));
  final favoritesAsync = ref.watch(favoritesByUserAndLanguageProvider((userId, selectedLanguageId!)));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Word Statistics',
        style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
      ),
      const SizedBox(height: 16),
      knownWordsAsync.when(
        data: (knownWords) {
          // debugPrint('Known words received: ${knownWords.map((kw) => kw.toJson()).toList()}'); // Debug print
          return _buildWordStatItem('Known Words', knownWords); // Use the retrieved known words
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      const SizedBox(height: 8),
      favoritesAsync.when(
        data: (favorites) {
          return _buildWordStatItem('Favorite Words', favorites.cast<KnownWordModel>()); // Update this line
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    ],
  );
}

  Widget _buildWordStatItem(String title, List<KnownWordModel> knownWords) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CupertinoTheme.of(context).textTheme.textStyle),
        Text(
          knownWords.length.toString(),
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
        ),
      ],
    );
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