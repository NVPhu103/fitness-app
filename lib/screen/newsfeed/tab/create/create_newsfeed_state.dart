import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/newsfeed/models/location_response.dart';

part 'create_newsfeed_state.g.dart';

@CopyWith()
class CreateNewsfeedState {
  final String id;
  final String content;
  final DateTime? exerciseTime;
  final String? exerciseName;
  final LocationResponse? location;
  final bool isSubmitSuccess;
  final int type;

  const CreateNewsfeedState({
    this.id = '',
    this.content = '',
    this.exerciseTime,
    this.exerciseName,
    this.location,
    this.isSubmitSuccess = false,
    this.type = 0,
  });

  bool get isValid {
    if (type == 0) {
      return content.isNotEmpty;
    } else {
      return exerciseTime != null &&
          (exerciseName ?? '').isNotEmpty &&
          location != null &&
          content.isNotEmpty;
    }
  }
}
