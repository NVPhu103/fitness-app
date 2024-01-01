import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/notifications/models/food_response.dart';

part 'suggesstion_state.g.dart';

@CopyWith()
class SuggesstionState {
  final bool isLoading;
  final List<FoodResponse>? dataList;

  const SuggesstionState({
    this.isLoading = false,
    this.dataList,
  });
}
