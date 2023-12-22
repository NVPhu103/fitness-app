class UserProfile {
  final String id;
  final String userId;
  final String gender;
  final String goal;
  final String activityLevel;
  final String status;
  final double currentWeight;
  final double height;
  final double desiredWeight;
  final int yearOfBirth;
  final double startingWeight;
  final int maximumCalorieIntake;

  const UserProfile(
      {required this.id,
      required this.userId,
      required this.gender,
      required this.goal,
      required this.activityLevel,
      required this.status,
      required this.currentWeight,
      required this.height,
      required this.desiredWeight,
      required this.yearOfBirth,
      required this.startingWeight,
      required this.maximumCalorieIntake});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        id: json['id'],
        userId: json['userId'],
        gender: json['gender'],
        goal: json['goal'],
        activityLevel: json['activityLevel'],
        status: json['status'],
        currentWeight: json['currentWeight'],
        height: json['height'],
        desiredWeight: json['desiredWeight'],
        yearOfBirth: json['yearOfBirth'],
        startingWeight: json['startingWeight'],
        maximumCalorieIntake: json['maximumCalorieIntake']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'gender': gender,
      'goal': goal,
      'activityLevel': activityLevel,
      'status': status,
      'currentWeight': currentWeight,
      'height': height,
      'desiredWeight': desiredWeight,
      'yearOfBirth': yearOfBirth,
      'startingWeight': startingWeight,
      'maximumCalorieIntake': maximumCalorieIntake
    };
  }
}
