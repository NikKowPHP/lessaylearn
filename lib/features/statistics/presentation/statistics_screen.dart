import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/features/statistics/providers/chart_provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLanguageSelector(userId),
          const SizedBox(height: 20),
          if (selectedLanguageId != null) _buildChart(userId),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(String userId) {
    final userLanguagesAsync = ref.watch(userLanguagesProvider(userId));

    return userLanguagesAsync.when(
      data: (languages) => CupertinoButton(
        child: Text(selectedLanguageId == null
            ? 'Select a language'
            : languages.firstWhere((lang) => lang.id == selectedLanguageId).name),
        onPressed: () => _showLanguageSelector(languages),
      ),
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }

  void _showLanguageSelector(List<LanguageModel> languages) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: languages
            .map((lang) => CupertinoActionSheetAction(
                  child: Text(lang.name),
                  onPressed: () {
                    setState(() {
                      selectedLanguageId = lang.id;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildChart(String userId) {
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
                  dataEntries: [
                    RadarEntry(value: chart.reading),
                    RadarEntry(value: chart.writing),
                    RadarEntry(value: chart.speaking),
                    RadarEntry(value: chart.listening),
                  ],
                ),
              ],
              radarShape: RadarShape.polygon,
              radarBackgroundColor: CupertinoColors.systemGrey6,
              borderData: FlBorderData(show: false),
              radarBorderData: BorderSide(color: CupertinoColors.systemGrey, width: 2),
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
              gridBorderData: BorderSide(color: CupertinoColors.systemGrey.withOpacity(0.3), width: 2),
            ),
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}