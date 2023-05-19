import 'dart:convert';

import 'package:fitness_app/screen/dashboard/dashboard.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/goal/components/UserProfile.dart';
import 'package:fitness_app/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:numberpicker/numberpicker.dart';

class SetGoalScreen2 extends StatefulWidget {
  final String userId;
  final String gender;
  final String goal;
  final String activityLevel;

  const SetGoalScreen2(
      {super.key,
      required this.userId,
      required this.gender,
      required this.goal,
      required this.activityLevel});

  @override
  // ignore: no_logic_in_create_state
  State<SetGoalScreen2> createState() =>
      // ignore: no_logic_in_create_state
      _SetGoalScreen2State(userId, gender, goal, activityLevel);
}

class _SetGoalScreen2State extends State<SetGoalScreen2> {
  final String userId;
  final String gender;
  final String goal;
  final String activityLevel;
  int _yearOfBirth = 1999;

  _SetGoalScreen2State(this.userId, this.gender, this.goal, this.activityLevel);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int maxYearValue = 2017;
    int minYearValue = 1950;
    TextEditingController heightController = TextEditingController();
    TextEditingController currentWeightController = TextEditingController();
    TextEditingController desiredWeightController = TextEditingController();

    Future<void> createProfile(
        String userId,
        String gender,
        String goal,
        String activityLevel,
        int yearOfBirth,
        String height,
        String currentWeight,
        String desiredWeight) async {
      if (height.toString().isNotEmpty &&
          currentWeight.toString().isNotEmpty &&
          desiredWeight.toString().isNotEmpty) {
        var doubleHeight = double.parse(height);
        var doubleCurrentWeight = double.parse(currentWeight);
        var doubleDesiredWeight = double.parse(desiredWeight);
        // ignore: unrelated_type_equality_checks
        if (gender == Gender.Male.toString()) {
          gender = "Male";
        } else {
          gender = "Female";
        }
        // ignore: unrelated_type_equality_checks
        if (activityLevel == ActivityLevel.VERY_ACTIVE.toString()) {
          activityLevel = "VERY ACTIVE";
          // ignore: unrelated_type_equality_checks
        } else if (activityLevel == ActivityLevel.LIGHTLY_ACTIVE.toString()) {
          activityLevel = "LIGHTLY ACTIVE";
          // ignore: unrelated_type_equality_checks
        } else if (activityLevel == ActivityLevel.NOT_VERY_ACTIVE.toString()) {
          activityLevel = "NOT VERY ACTIVE";
        } else {
          activityLevel = "ACTIVE";
        }
        Response response = await post(
          Uri.parse("http://127.0.0.1:8000/userprofiles"),
          body: jsonEncode({
            "user_id": userId,
            "gender": gender,
            "current_weight": doubleCurrentWeight,
            "height": doubleHeight,
            "desired_weight": doubleDesiredWeight,
            "year_of_birth": yearOfBirth,
            "activity_level": activityLevel
          }),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 201) {
          var body = jsonDecode(response.body);
          // Get totalCaloriesIntake from diary
          String userId = body['userId'];
          String today = getTodayWithYMD();
          Response diaryResponse = await get(
            Uri.parse("http://127.0.0.1:8000/diaries/$userId?date=$today"),
            headers: {'Content-Type': 'application/json'},
          );
          var diaryBody = jsonDecode(diaryResponse.body);
          Diary diary = Diary.fromJson(diaryBody);
          String gender = body['gender'];
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard(name: gender,
                        diary: diary,
                      )));
        } else {
          var body = jsonDecode(response.body);
          if (response.statusCode == 422) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              body['detail'][0]['msg'].toString(),
              textAlign: TextAlign.center,
            )));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              body['detail'].toString(),
              textAlign: TextAlign.center,
            )));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Black Field Not Allowed",
          textAlign: TextAlign.center,
        )));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        title: const Text(
          "PERSONAL INFORMATION",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => createProfile(
                userId,
                gender,
                goal,
                activityLevel,
                _yearOfBirth,
                heightController.text.toString(),
                currentWeightController.text.toString(),
                desiredWeightController.text.toString()),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // HEIGHT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.15,
            width: size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Your Height",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.blue,
                  ),
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: TextField(
                      controller: heightController,
                      decoration: const InputDecoration(
                        labelText: "centimeter",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Current Weight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.15,
            width: size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Your current weight",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.blue,
                  ),
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: TextField(
                      controller: currentWeightController,
                      decoration: const InputDecoration(
                        labelText: "kilogram",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Goal Weight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.15,
            width: size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Your goal weight",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.blue,
                  ),
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: TextField(
                      controller: desiredWeightController,
                      decoration: const InputDecoration(
                        labelText: "kilogram",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Year of birth
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: size.height * 0.26,
            width: size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Your year of birth",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                Center(
                  child: NumberPicker(
                    value: _yearOfBirth,
                    minValue: 1950,
                    maxValue: 2017,
                    onChanged: (value) => setState(() => _yearOfBirth = value),
                    selectedTextStyle: const TextStyle(
                        fontSize: 30, color: Colors.deepPurpleAccent),
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        final newValue = _yearOfBirth - 1;
                        if (newValue >= minYearValue) {
                          _yearOfBirth = newValue;
                        }
                      }),
                    ),
                    Text(
                      'Current value: $_yearOfBirth',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        final newValue = _yearOfBirth + 1;
                        if (newValue <= maxYearValue) {
                          _yearOfBirth = newValue;
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
