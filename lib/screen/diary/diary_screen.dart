// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/components/food_diary.dart';
import 'package:fitness_app/screen/search_food/search_food_screen.dart';
import 'package:fitness_app/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class DiaryScreen extends StatefulWidget {
  final String name;
  Diary diary;

  DiaryScreen({super.key, required this.diary, required this.name});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState(name, diary);
}

class _DiaryScreenState extends State<DiaryScreen> {
  final String name;
  Diary diary;
  late String date;
  String? remainingCalories;
  List<FoodDiary> listBreakfast = [];
  int breakfastTotalCalories = 0;
  List<FoodDiary> listLunch = [];
  int lunchTotalCalories = 0;
  List<FoodDiary> listDining = [];
  int diningTotalCalories = 0;
  _DiaryScreenState(this.name, this.diary);

  @override
  void initState() {
    date = getDate(diary);
    remainingCalories = calculateRemainingCalories();
    getFoodDiary(diary, date);
    super.initState();
  }

  String calculateRemainingCalories() {
    int remainingCalories =
        diary.maximumCaloriesIntake - diary.totalCaloriesIntake;
    return remainingCalories.toString();
  }

  Future<void> getFoodDiary(Diary diary, String date) async {
    String breakfastUrl =
        "http://127.0.0.1:8000/fooddiaries/${diary.breakfastId}";
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
      });
    }
    // Lunch
    String lunchUrl = "http://127.0.0.1:8000/fooddiaries/${diary.lunchId}";
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
      });
    }
    // Dining
    String diningUrl = "http://127.0.0.1:8000/fooddiaries/${diary.diningId}";
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: ButtonNavBar(
        name: name,
        isDiaryActive: true,
        diary: diary,
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
          exerciseContainer(size, 0),
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
                  customText(diary.totalCaloriesIntake.toString(), 20),
                  customText("Food", 20, fontWeight: FontWeight.w200),
                ],
              ),
              customText("+", 20),
              Column(
                children: <Widget>[
                  customText("0", 20),
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        Text(
          date!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {},
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
        Container(
          width: size.width * 1,
          child: ListView.builder(
            itemCount: listFoodDiaries.length + 1,
            itemBuilder: (context, index) {
              if (listFoodDiaries.isEmpty) {
                return null;
              }
              if (index < listFoodDiaries.length) {
                final item = listFoodDiaries[index];
                return Card(
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
                      trailing: customText(item.totalCalories.toString(), 20)),
                );
              }
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
                        )));
          },
        ),
      ],
    );
  }

  Column exerciseContainer(Size size, int totalCalories) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.08,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customText("Exercise", 22, fontWeight: FontWeight.bold),
                customText(totalCalories.toString(), 22,
                    fontWeight: FontWeight.bold),
              ]),
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
          onPressed: () {},
        ),
      ],
    );
  }
}
