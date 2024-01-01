import 'package:fitness_app/screen/search_exercise/components/exercise.dart';

class ExerciseHistory {
  late String id;
  late String userId;
  late String exerciseId;
  late int numberOfUses;
  late Exercise exercise;

  ExerciseHistory(
      this.id, this.userId, this.exerciseId, this.numberOfUses, this.exercise);

  ExerciseHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    exerciseId = json['exerciseId'];
    numberOfUses = json['numberOfUses'];
    exercise = Exercise.fromJson(json['exercise']);
  }
}
