// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/components/exercise_diary.dart';
import 'package:fitness_app/screen/diary/components/food_diary.dart';
import 'package:fitness_app/screen/search_exercise/search_exercise.dart';
import 'package:fitness_app/screen/search_food/detail/detail_food_screen.dart';
import 'package:fitness_app/screen/search_food/search_food_screen.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'detail/detail_diary_screen.dart';

// ignore: must_be_immutable
class DiaryScreen extends StatefulWidget {
  final String name;
  Diary diary;
  UserProfile userProfile;
  DiaryScreen(
      {super.key,
      required this.diary,
      required this.name,
      required this.userProfile});

  @override
  State<DiaryScreen> createState() =>
      _DiaryScreenState(name, diary, userProfile);
}

class _DiaryScreenState extends State<DiaryScreen> {
  final String name;
  Diary diary;
  UserProfile userProfile;
  late String date;
  String? remainingCalories;
  List<FoodDiary> listBreakfast = [];
  int breakfastTotalCalories = 0;
  List<FoodDiary> listLunch = [];
  int lunchTotalCalories = 0;
  List<FoodDiary> listDining = [];
  int diningTotalCalories = 0;
  int foodTotalCalories = 0;
  List<ExerciseDiary> listExercicse = [];
  int exerciseBurnedCalories = 0;
  _DiaryScreenState(this.name, this.diary, this.userProfile);

  @override
  void initState() {
    date = getDate(diary.date);
    remainingCalories = calculateRemainingCalories();
    getFoodDiary(diary);
    getExerciseDiary(diary);
    super.initState();
  }

  String calculateRemainingCalories() {
    int remainingCalories =
        diary.maximumCaloriesIntake - diary.totalCaloriesIntake;
    return remainingCalories.toString();
  }

  Future<void> getFoodDiary(Diary diary) async {
    String breakfastUrl =
        "https://fitness-app-e0xl.onrender.com/fooddiaries/${diary.breakfastId}";
    // ignore: non_constant_identifier_names
    Response get_list_breakfast_response = await get(
      Uri.parse(breakfastUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_list_breakfast_response.body.isNotEmpty) {
      List<dynamic> listNewFoodDiary =
          jsonDecode(get_list_breakfast_response.body)['listFoodDiaries'];
      setState(() {
        for (int i = 0; i < listNewFoodDiary.length; i++) {
          listBreakfast.add(FoodDiary.fromJson(listNewFoodDiary[i]));
        }
        breakfastTotalCalories = jsonDecode(
            get_list_breakfast_response.body)['totalCaloriesOfFoodDiaries'];
        foodTotalCalories += breakfastTotalCalories;
      });
    }
    // Lunch
    String lunchUrl =
        "https://fitness-app-e0xl.onrender.com/fooddiaries/${diary.lunchId}";
    // ignore: non_constant_identifier_names
    Response get_list_lunch_response = await get(
      Uri.parse(lunchUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_list_lunch_response.body.isNotEmpty) {
      List<dynamic> listNewFoodDiary =
          jsonDecode(get_list_lunch_response.body)['listFoodDiaries'];
      setState(() {
        for (int i = 0; i < listNewFoodDiary.length; i++) {
          listLunch.add(FoodDiary.fromJson(listNewFoodDiary[i]));
        }
        lunchTotalCalories = jsonDecode(
            get_list_lunch_response.body)['totalCaloriesOfFoodDiaries'];
        foodTotalCalories += lunchTotalCalories;
      });
    }
    // Dining
    String diningUrl =
        "https://fitness-app-e0xl.onrender.com/fooddiaries/${diary.diningId}";
    // ignore: non_constant_identifier_names
    Response get_list_dining_response = await get(
      Uri.parse(diningUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_list_dining_response.body.isNotEmpty) {
      List<dynamic> listNewFoodDiary =
          jsonDecode(get_list_dining_response.body)['listFoodDiaries'];
      setState(() {
        for (int i = 0; i < listNewFoodDiary.length; i++) {
          listDining.add(FoodDiary.fromJson(listNewFoodDiary[i]));
        }
        diningTotalCalories = jsonDecode(
            get_list_dining_response.body)['totalCaloriesOfFoodDiaries'];
        foodTotalCalories += diningTotalCalories;
      });
    }
  }

  Future<void> getExerciseDiary(Diary diary) async {
    String breakfastUrl =
        "https://fitness-app-e0xl.onrender.com/exercisediaries/${diary.id}";
    // ignore: non_constant_identifier_names
    Response get_exercise_diary_response = await get(
      Uri.parse(breakfastUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_exercise_diary_response.body.isNotEmpty) {
      List<dynamic> listNewExerciseDiary =
          jsonDecode(get_exercise_diary_response.body)['listExerciseDiaries'];
      setState(() {
        for (int i = 0; i < listNewExerciseDiary.length; i++) {
          listExercicse.add(ExerciseDiary.fromJson(listNewExerciseDiary[i]));
        }
        exerciseBurnedCalories = jsonDecode(get_exercise_diary_response.body)[
            'burnedCaloriesOfExerciseDiaries'];
      });
    }
  }

  Future<void> getNewDiary(bool isFutureDate) async {
    String newDate = getTodayWithYMD();
    if (isFutureDate == false) {
      newDate = transferDateTimeToString(
          DateTime.parse(diary.date).subtract(const Duration(days: 1)));
    } else {
      newDate = transferDateTimeToString(
          DateTime.parse(diary.date).add(const Duration(days: 1)));
    }
    Response newDiaryResponse = await get(
      Uri.parse(
          "https://fitness-app-e0xl.onrender.com/diaries/${diary.userId}?date=$newDate"),
      headers: {'Content-Type': 'application/json'},
    );
    var newDiaryBody = jsonDecode(newDiaryResponse.body);
    setState(() {
      diary = Diary.fromJson(newDiaryBody);
      refreshAllList();
      date = getDate(diary.date);
      remainingCalories = calculateRemainingCalories();
      getFoodDiary(diary);
      getExerciseDiary(diary);
    });
  }

  void refreshAllList() {
    setState(() {
      listBreakfast = [];
      listDining = [];
      listLunch = [];
      listExercicse = [];
      foodTotalCalories = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: ButtonNavBar(
        name: name,
        isDiaryActive: true,
        diary: diary,
        userProfile: userProfile,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        automaticallyImplyLeading: false,
        title: const Text(
          "DIARY",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailDiaryScreen()));
              },
              icon: const Icon(
                Icons.pie_chart_outline,
                color: Colors.black,
                size: 36,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 36,
              )),
          SizedBox(
            width: size.width * 0.01,
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.07,
            child: dateBar(size),
          ),
          spacingSizedBox(size),
          SizedBox(
            height: size.height * 0.15,
            child: coloriesRemainingSizedBox(size),
          ),
          spacingSizedBox(size),
          mealContainer(size, "Breakfast", breakfastTotalCalories,
              listBreakfast, diary.breakfastId),
          spacingSizedBox(size),
          mealContainer(
              size, "Lunch", lunchTotalCalories, listLunch, diary.lunchId),
          spacingSizedBox(size),
          mealContainer(
              size, "Dining", diningTotalCalories, listDining, diary.diningId),
          spacingSizedBox(size),
          exerciseContainer(size, exerciseBurnedCalories),
          spacingSizedBox(size),
        ],
      ),
    );
  }

  Text customText(String data, double size,
      {FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      data,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  Column coloriesRemainingSizedBox(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.05,
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Calories Remaining",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
        SizedBox(
          height: size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  customText(diary.maximumCaloriesIntake.toString(), 20),
                  customText("Goal", 20, fontWeight: FontWeight.w200),
                ],
              ),
              customText("-", 26),
              Column(
                children: <Widget>[
                  customText(foodTotalCalories.toString(), 20),
                  customText("Food", 20, fontWeight: FontWeight.w200),
                ],
              ),
              customText("+", 20),
              Column(
                children: <Widget>[
                  customText(exerciseBurnedCalories.toString(), 20),
                  customText("Exercise", 20, fontWeight: FontWeight.w200),
                ],
              ),
              customText("=", 20),
              Column(
                children: <Widget>[
                  customText(remainingCalories!, 20),
                  customText("Remaining", 20, fontWeight: FontWeight.w200),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row dateBar(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            onPressed: () {
              getNewDiary(false);
            },
            icon: const Icon(Icons.arrow_back)),
        Text(
          date,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            getNewDiary(true);
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  SizedBox spacingSizedBox(Size size) {
    return SizedBox(
      height: size.height * 0.016,
      child: Container(color: const Color.fromARGB(255, 236, 236, 236)),
    );
  }

  Column mealContainer(Size size, String meal, int totalCalories,
      List<FoodDiary> listFoodDiaries, String mealId) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.08,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customText(meal, 22, fontWeight: FontWeight.bold),
                customText(totalCalories.toString(), 22,
                    fontWeight: FontWeight.bold),
              ]),
        ),
        SizedBox(
          width: size.width * 1,
          child: ListView.builder(
            itemCount: listFoodDiaries.length + 1,
            itemBuilder: (context, index) {
              if (listFoodDiaries.isEmpty) {
                return null;
              }
              if (index < listFoodDiaries.length) {
                final item = listFoodDiaries[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailFoodScreen(
                                  mealId: mealId,
                                  mealName: meal,
                                  foodId: item.food.id,
                                  foodName: item.food.name,
                                  unit: item.food.unit,
                                  quantity: item.quantity,
                                  isUpdate: true,
                                  onReload: (value) {
                                    // reload (value trả về)
                                    setState(() {
                                      diary = value.diary;
                                      refreshAllList();
                                      remainingCalories =
                                          calculateRemainingCalories();
                                      getFoodDiary(diary);
                                    });
                                  },
                                )));
                  },
                  child: Card(
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: ListTile(
                        title: Text(item.food.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )),
                        subtitle: Text(
                            "quantity: ${item.quantity.toString()} x ${item.food.unit.toString()}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            )),
                        trailing:
                            customText(item.totalCalories.toString(), 20)),
                  ),
                );
              }
              return null;
            },
            shrinkWrap: true,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          child: Container(
            height: size.height * 0.08,
            padding: const EdgeInsets.only(left: 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customText("ADD FOOD", 20, fontWeight: FontWeight.w400),
                  const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.more_horiz,
                        size: 34,
                      )),
                ]),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchFoodScreen(
                          diary: diary,
                          isSelectedValue: true,
                          meal: meal,
                          userProfile: userProfile,
                          isUpdate: false,
                          onReload: (value) {
                            // reload
                          },
                        )));
          },
        ),
      ],
    );
  }

  Column exerciseContainer(Size size, int exerciseBurnedCalories) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.08,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customText("Exercise", 22, fontWeight: FontWeight.bold),
                customText(exerciseBurnedCalories.toString(), 22,
                    fontWeight: FontWeight.bold),
              ]),
        ),
        // ListView
        SizedBox(
          width: size.width * 1,
          child: ListView.builder(
            itemCount: listExercicse.length + 1,
            itemBuilder: (context, index) {
              if (listExercicse.isEmpty) {
                return null;
              }
              if (index < listExercicse.length) {
                final item = listExercicse[index];
                bool isPerHour = false;
                if (item.exercise.burningType.toString() ==
                    "CALORIES_PER_HOUR") {
                  isPerHour = true;
                }
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.white,
                  child: ListTile(
                      title: Text(item.exercise.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          )),
                      subtitle: Text(
                          isPerHour
                              ? "time: ${item.practiceTime.toString()} minutes x ${item.exercise.burnedCalories.toString()}/hour"
                              : "times: ${item.practiceTime.toString()} times x ${item.exercise.burnedCalories.toString()}/set",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          )),
                      trailing: customText(item.burnedCalories.toString(), 20)),
                );
              }
              return null;
            },
            shrinkWrap: true,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          child: Container(
            height: size.height * 0.08,
            padding: const EdgeInsets.only(left: 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customText("ADD EXERCISE", 20, fontWeight: FontWeight.w400),
                  const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.more_horiz,
                        size: 34,
                      )),
                ]),
          ),
          onPressed: () {
            _showDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Select a exercise type",
              style: TextStyle(fontSize: 26),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop("CARDIO"),
                    child: const Text(
                      "Cardio",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop("STRENGTH"),
                    child: const Text(
                      "Strength",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal),
                    ))
              ],
            ),
          );
        }).then((value) => {
          if (value == "CARDIO")
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchExerciseScreen(
                            diary: diary,
                            exerciseType: "CARDIO",
                            userProfile: userProfile,
                          )))
            }
          else if (value == "STRENGTH")
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchExerciseScreen(
                            diary: diary,
                            exerciseType: "STRENGTH",
                            userProfile: userProfile,
                          )))
            }
        });
  }
}
