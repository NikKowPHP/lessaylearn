import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/services/user_service.dart';


abstract class IChartService {
  Future<List<ChartModel>> getUserCharts(String userId);
  Future<ChartModel?> getChartForLanguage(String userId, String languageId);
}

class ChartService implements IChartService {
  final IUserService _userService;

  ChartService(this._userService);

 
  @override
  Future<List<ChartModel>> getUserCharts(String userId) async {
    return await _userService.getUserCharts(userId);
  }

  @override
  Future<ChartModel?> getChartForLanguage(String userId, String languageId) async {
    final charts = await getUserCharts(userId);
    try {
      return charts.firstWhere((chart) => chart.languageId == languageId);
    } catch (e) {
      return null;
    }
  }
}