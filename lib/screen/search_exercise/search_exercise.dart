// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/diary_screen.dart';
import 'package:fitness_app/screen/search_exercise/components/exercise.dart';
import 'package:fitness_app/screen/search_exercise/components/exercise_history.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class SearchExerciseScreen extends StatefulWidget {
  final Diary diary;
  final String exerciseType;
  final UserProfile userProfile;

  const SearchExerciseScreen({
    super.key,
    required this.diary,
    required this.exerciseType,
    required this.userProfile,
  });

  @override
  State<SearchExerciseScreen> createState() =>
      _SearchExerciseScreenState(diary, exerciseType, userProfile);
}

class _SearchExerciseScreenState extends State<SearchExerciseScreen> {
  Diary diary;
  UserProfile userProfile;
  String exerciseType;
  bool isCardio = false;
  List<Exercise> listExercises = [];
  TextEditingController searchTextController = TextEditingController();
  final listViewController = ScrollController();
  int page = 2;
  int perPage = 10;
  bool hasMore = true;
  bool isLoading = false;
  List<ExerciseHistory> listExerciseHistories = [];
  bool isShowHistory = true;
  TextEditingController exerciseController = TextEditingController();

  _SearchExerciseScreenState(this.diary, this.exerciseType, this.userProfile);

  @override
  void initState() {
    super.initState();
    getAllExerciseHistories(diary.userId);
    listViewController.addListener(() {
      if (listViewController.position.maxScrollExtent ==
          listViewController.offset) {
        fetch(searchTextController.text);
      }
    });
    if (exerciseType == "CARDIO") {
      isCardio = true;
    }
  }

  Future fetch(String value) async {
    if (isLoading) return;
    isLoading = true;
    // ignore: constant_identifier_names
    String url =
        "http://127.0.0.1:8000/exercises?q=${value}%2BexerciseType%3A${exerciseType}&default_operator=and&page=$page&per_page=$perPage";
    // ignore: non_constant_identifier_names
    Response get_exercise_response = await get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_exercise_response.body.isNotEmpty) {
      List<dynamic> listNewExercises = jsonDecode(get_exercise_response.body);
      setState(() {
        page++;
        isLoading = false;
        if (listNewExercises.length < perPage) {
          hasMore = false;
        }
        for (int i = 0; i < listNewExercises.length; i++) {
          listExercises.add(Exercise.fromJson(listNewExercises[i]));
        }
      });
    }
  }

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DiaryScreen(
                          name: "",
                          diary: diary,
                          userProfile: userProfile,
                        )));
          },
        ),
        title: const Text(
          "Exercise",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.02,
          ),
          Center(
            child: Container(
              height: size.height * 0.08,
              width: size.width * 0.94,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29.5),
                  border: Border.all(color: Colors.blueAccent, width: 2)),
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {
                    listExercises = [];
                    isLoading = false;
                    hasMore = true;
                    page = 2;
                    isShowHistory = false;
                  });
                  getAllExercises(value);
                },
                controller: searchTextController,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  hintText: "Search for exercises",
                  icon: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: Colors.black87,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: searchTextController.clear,
                    icon: const Icon(Icons.clear, color: null),
                    hoverColor: Colors.white10,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
              height: size.height * 0.08,
              width: size.width * 0.96,
              child: isShowHistory
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "Exercise History",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "Exercise",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
          // ListView
          SizedBox(
            height: size.height * 0.72,
            width: size.width * 0.96,
            child: isShowHistory
                ? RefreshIndicator(
                    onRefresh: () => getAllExerciseHistories(
                      diary.userId,
                    ),
                    child: ListView.builder(
                      controller: listViewController,
                      itemCount: listExerciseHistories.length + 1,
                      itemBuilder: (context, index) {
                        if (listExerciseHistories.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text("No history found"),
                            ),
                          );
                        }
                        if (index < listExerciseHistories.length) {
                          final item = listExerciseHistories[index].exercise;
                          return Card(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(item.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              subtitle: Text(
                                  isCardio
                                      ? "Burn ${item.burnedCalories} calories per hour"
                                      : ""
                                          "Burn ${item.burnedCalories} calories per set",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  )),
                              trailing: InkWell(
                                borderRadius: BorderRadius.circular(29),
                                onTap: () {
                                  _showDialog(context, item.id);
                                },
                                child: const Icon(
                                  Icons.add_circle_rounded,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  )
                : ListView.builder(
                    controller: listViewController,
                    itemCount: listExercises.length + 1,
                    itemBuilder: (context, index) {
                      if (listExercises.isEmpty) {
                        if (isShowHistory == false) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text("Not found"),
                            ),
                          );
                        } else {
                          return null;
                        }
                      }
                      if (index < listExercises.length) {
                        final item = listExercises[index];
                        return Card(
                          color: const Color.fromARGB(220, 255, 255, 255),
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(item.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            subtitle: Text(
                                isCardio
                                    ? "Burn ${item.burnedCalories} calories per hour"
                                    : ""
                                        "Burn ${item.burnedCalories} calories per set",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                )),
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(29),
                              onTap: () {
                                _showDialog(context, item.id);
                              },
                              child: const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.blueAccent,
                                size: 40,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: hasMore
                                ? const CircularProgressIndicator()
                                : const Text("No more data to load"),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<bool> addExercise(String strPracticeTime, String exerciseId) async {
    if (strPracticeTime.isNotEmpty &&
        strPracticeTime != "0" &&
        exerciseId.isNotEmpty) {
      int practiceTime = int.parse(strPracticeTime);
      if ((practiceTime <= 50 && exerciseType == "STRENGTH") ||
          (practiceTime <= 480 && exerciseType == "CARDIO")) {
        try {
          Response postExerciseDiaryResponse = await post(
            Uri.parse("http://127.0.0.1:8000/exercisediaries"),
            body: jsonEncode({
              "exerciseId": exerciseId,
              "diaryId": diary.id,
              "practiceTime": practiceTime
            }),
            headers: {'Content-Type': 'application/json'},
          );
          if (postExerciseDiaryResponse.statusCode == 201) {
            var diaryBody = jsonDecode(postExerciseDiaryResponse.body)['diary'];
            Diary newDiary = Diary.fromJson(diaryBody);
            setState(() {
              diary = newDiary;
            });
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Exercise added successfully",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 1),
            ));
            return true;
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Something wrong",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Practice times < 50 times || practice minutes < 480 minutes",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Practice times/minutes cannot be empty or equal to 0",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ));
    }
    return false;
  }

  Future<List<Exercise>> getAllExercises(String value) async {
    if (value.isNotEmpty) {
      String uri =
          "http://127.0.0.1:8000/exercises?q=${value}%2BexerciseType%3A${exerciseType}&default_operator=and&page=1&per_page=10";
      try {
        // ignore: non_constant_identifier_names
        Response get_exercise_response = await get(
          Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
        );
        if (get_exercise_response.statusCode == 200) {
          setState(() {
            // ignore: non_constant_identifier_names
            List<dynamic> get_exercise_response_body =
                jsonDecode(get_exercise_response.body);
            for (int i = 0; i < get_exercise_response_body.length; i++) {
              listExercises
                  .add(Exercise.fromJson(get_exercise_response_body[i]));
            }
            if (listExercises.length < perPage) {
              hasMore = false;
            }
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            get_exercise_response.body,
            textAlign: TextAlign.center,
          )));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "No keywords to search",
        textAlign: TextAlign.center,
      )));
    }
    return listExercises;
  }

  Future<void> getAllExerciseHistories(String userId) async {
    if (userId.isNotEmpty) {
      String uri =
          "http://127.0.0.1:8000/exercisehistories/$userId/$exerciseType";
      try {
        // ignore: non_constant_identifier_names    print("step1");
        Response get_exercise_history_response = await get(
          Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
        );
        if (get_exercise_history_response.statusCode == 200) {
          setState(() {
            // ignore: non_constant_identifier_names
            List<dynamic> get_exercise_history_response_body =
                jsonDecode(get_exercise_history_response.body);
            for (int i = 0;
                i < get_exercise_history_response_body.length;
                i++) {
              listExerciseHistories.add(ExerciseHistory.fromJson(
                  get_exercise_history_response_body[i]));
            }
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            get_exercise_history_response.body,
            textAlign: TextAlign.center,
          )));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please enter user id",
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> _showDialog(BuildContext context, String exerciseId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Enter your practice times/minutes",
              style: TextStyle(fontSize: 24),
            ),
            content: TextFormField(
              controller: exerciseController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                hintText: "times for strength/minutes for cardio",
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    addExercise(exerciseController.text.toString(), exerciseId)
                        .then((value) => {
                              if (value == true) {Navigator.of(context).pop()}
                            });
                  },
                  child: const Text("OK", style: TextStyle(fontSize: 20))),
              TextButton(
                  onPressed: () {
                    exerciseController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel", style: TextStyle(fontSize: 20)))
            ],
          );
        });
  }
}
