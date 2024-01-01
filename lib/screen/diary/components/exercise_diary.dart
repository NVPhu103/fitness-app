import 'package:fitness_app/screen/search_exercise/components/exercise.dart';

class ExerciseDiary {
  late String id;
  late String diaryId;
  late String exerciseId;
  late int practiceTime;
  late int burnedCalories;
  late Exercise exercise;

  ExerciseDiary(this.id, this.diaryId, this.exerciseId, this.burnedCalories,
      this.practiceTime, this.exercise);

  ExerciseDiary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diaryId = json['diaryId'];
    exerciseId = json['exerciseId'];
    practiceTime = json['practiceTime'];
    burnedCalories = json['burnedCalories'];
    exercise = Exercise.fromJson(json['exercise']);
  }
}
