import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/features/statistics/services/chart_service.dart';


final chartServiceProvider = Provider<IChartService>((ref) {
  final userService = ref.watch(userServiceProvider);
  return ChartService(userService);
});

final userChartsProvider = FutureProvider.family<List<ChartModel>, String>((ref, userId) async {
  final chartService = ref.watch(chartServiceProvider);
  return await chartService.getUserCharts(userId);
});

final languageChartProvider = FutureProvider.family<ChartModel?, ({String userId, String languageId})>((ref, params) async {
  final chartService = ref.watch(chartServiceProvider);
  return await chartService.getChartForLangua`ge(params.userId, params.languageId);
});
