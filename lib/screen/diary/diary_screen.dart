// ignore_for_file: no_logic_in_create_state

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:flutter/material.dart';

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

  _DiaryScreenState(this.name, this.diary);

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        title: const Text(
          "DIARY",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            child: Text(
              diary.totalCaloriesIntake.toString(),
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
