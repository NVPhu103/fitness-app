class Exercise {
  final String id;
  final String name;
  final String exerciseType;
  final String description;
  final String burningType;
  final int burnedCalories;
  final String status;

  const Exercise(
      {required this.id,
      required this.name,
      required this.exerciseType,
      required this.description,
      required this.burningType,
      required this.burnedCalories,
      required this.status});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        id: json['id'],
        name: json['name'],
        exerciseType: json['exerciseType'],
        description: json['description'],
        burningType: json['burningType'],
        burnedCalories: json['burnedCalories'],
        status: json['status']);
  }
}
