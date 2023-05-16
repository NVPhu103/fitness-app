class Diary {
  late String id;
  late String userId;
  late String date;
  late String breakfastId;
  late String lunchId;
  late String diningId;
  late int maximumCaloriesIntake;
  late int totalCaloriesIntake;

  Diary(this.id, this.userId, this.date, this.breakfastId, this.lunchId,
      this.diningId, this.maximumCaloriesIntake, this.totalCaloriesIntake);

  Diary.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    date = json["date"];
    breakfastId = json["breakfastId"];
    lunchId = json["lunchId"];
    diningId = json["diningId"];
    maximumCaloriesIntake = json["maximumCaloriesIntake"];
    totalCaloriesIntake = json["totalCaloriesIntake"];
  }
}
