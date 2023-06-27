import 'package:fitness_app/screen/goal/components/UserProfile.dart';
import 'package:fitness_app/screen/goal/set_goal_screen_2.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class SetGoalScreen1 extends StatefulWidget {
  final String userId;

  const SetGoalScreen1({super.key, required this.userId});

  @override
  // ignore: no_logic_in_create_state
  State<SetGoalScreen1> createState() => _SetGoalScreen1State(userId);
}

class _SetGoalScreen1State extends State<SetGoalScreen1> {
  final String userId;
  Gender? _gender = Gender.Female;
  ActivityLevel? _activityLevel = ActivityLevel.NOT_VERY_ACTIVE;
  Goal? _goal = Goal.LOSE_WEIGHT;

  _SetGoalScreen1State(this.userId);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          "GOAL",
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
              "NEXT",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SetGoalScreen2(
                            userId: userId,
                            gender: _gender.toString(),
                            goal: _goal.toString(),
                            activityLevel: _activityLevel.toString(),
                          ))),
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // GENDER
          Container(
            height: size.height * 0.21,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "GENDER",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.normal),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio<Gender>(
                    value: Gender.Female,
                    groupValue: _gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<Gender>(
                    value: Gender.Male,
                    groupValue: _gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // GOAL
          Container(
            height: size.height * 0.26,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "YOUR GOAL",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.normal),
                ),
                ListTile(
                  title: const Text('Lose weight'),
                  leading: Radio<Goal>(
                    value: Goal.LOSE_WEIGHT,
                    groupValue: _goal,
                    onChanged: (Goal? value) {
                      setState(() {
                        _goal = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Maintain weight'),
                  leading: Radio<Goal>(
                    value: Goal.MAINTAIN_WEIGHT,
                    groupValue: _goal,
                    onChanged: (Goal? value) {
                      setState(() {
                        _goal = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Gain weight'),
                  leading: Radio<Goal>(
                    value: Goal.GAIN_WEIGHT,
                    groupValue: _goal,
                    onChanged: (Goal? value) {
                      setState(() {
                        _goal = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // ACTIVITY LEVEL
          Container(
            height: size.height * 0.412,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "ACTIVITY LEVEL",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.normal),
                ),
                ListTile(
                  title: const Text('Not Very Active'),
                  subtitle: const Text(
                      "Spend most of the day sitting (e.g. bank teller, desk job)"),
                  leading: Radio<ActivityLevel>(
                    value: ActivityLevel.NOT_VERY_ACTIVE,
                    groupValue: _activityLevel,
                    onChanged: (ActivityLevel? value) {
                      setState(() {
                        _activityLevel = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Lightly Active'),
                  subtitle: const Text(
                      "Spend a good part of the day on your feed (e.g. teacher, salesperson, receptionist)"),
                  leading: Radio<ActivityLevel>(
                    value: ActivityLevel.LIGHTLY_ACTIVE,
                    groupValue: _activityLevel,
                    onChanged: (ActivityLevel? value) {
                      setState(() {
                        _activityLevel = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Active'),
                  subtitle: const Text(
                      "Spend a good part of the day doing some physical activity (e.g. food server)"),
                  leading: Radio<ActivityLevel>(
                    value: ActivityLevel.ACTIVE,
                    groupValue: _activityLevel,
                    onChanged: (ActivityLevel? value) {
                      setState(() {
                        _activityLevel = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Very Active'),
                  subtitle: const Text(
                      "Spend most of the day doing heavy physical activity(e.g. sports athletes, builders)"),
                  leading: Radio<ActivityLevel>(
                    value: ActivityLevel.VERY_ACTIVE,
                    groupValue: _activityLevel,
                    onChanged: (ActivityLevel? value) {
                      setState(() {
                        _activityLevel = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
