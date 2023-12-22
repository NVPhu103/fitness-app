import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/nutritions/models/dailynutrition_response/dailynutrition_response.dart';

part 'detail_diary_state.g.dart';

@CopyWith()
class DetailDiaryState {
  final bool isLoading;
  final DailynutritionResponse? data;
  final int type;
  final DateTime? currentTime;
  final DateTime? startDate;
  final DateTime? endDate;
  final String timeDisplay;

  const DetailDiaryState({
    this.isLoading = false,
    this.data,
    this.type = 0,
    this.currentTime,
    this.startDate,
    this.endDate,
    this.timeDisplay = 'Today',
  });
}
