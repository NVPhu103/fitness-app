// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'dart:js_util';

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class EditUserprofileScreen extends StatefulWidget {
  final String name;
  Diary diary;
  UserProfile userProfile;
  EditUserprofileScreen(
      {super.key,
      required this.name,
      required this.diary,
      required this.userProfile});

  @override
  State<EditUserprofileScreen> createState() =>
      _EditUserprofileScreenState(diary, name, userProfile);
}

class _EditUserprofileScreenState extends State<EditUserprofileScreen> {
  String name;
  Diary diary;
  UserProfile userProfile;

  _EditUserprofileScreenState(this.diary, this.name, this.userProfile);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: ButtonNavBar(
        name: name,
        isSettingActive: true,
        diary: diary,
        userProfile: userProfile,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        automaticallyImplyLeading: false,
        title: const Text(
          "USER PROFILE",
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
      body: Container(
        color: const Color.fromARGB(255, 236, 236, 236),
        child: Column(
          children: [
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Starting weight", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: null,
                          child: customText(
                              userProfile.startingWeight.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Current weight", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {
                            _showDialogText(context, "Current weight",
                                userProfile.currentWeight, "currentWeight");
                          },
                          child: customText(
                              userProfile.currentWeight.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Height", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {
                            _showDialogText(context, "Height",
                                userProfile.height, "height");
                          },
                          child: customText(userProfile.height.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Goal weight", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {
                            _showDialogText(context, "Goal Weight",
                                userProfile.desiredWeight, "desiredWeight");
                          },
                          child: customText(
                              userProfile.desiredWeight.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Goal", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {},
                          child: customText(userProfile.goal.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Activity Level", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {},
                          child: customText(
                              userProfile.activityLevel.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Gender", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {},
                          child: customText(userProfile.gender.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.004,
            ),
            Container(
              height: size.height * 0.08,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Expanded(flex: 2, child: customText("Year of birth", 24)),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: TextButton(
                          onPressed: () {},
                          child: customText(
                              userProfile.yearOfBirth.toString(), 24)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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

  SizedBox spacingSizedBox(Size size) {
    return SizedBox(
      height: size.height * 0.004,
      child: Container(color: const Color.fromARGB(255, 236, 236, 236)),
    );
  }

  Future<bool> updateUserProfile(String updateField, var newValue) async {
    if (updateField == "currentWeight" ||
        updateField == "height" ||
        updateField == "desiredWeight") {
      newValue = double.parse(newValue);
      if (newValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Value > 0",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
        ));
        return false;
      }
    }
    Response response = await patch(
      Uri.parse(
          "https://fitness-app-e0xl.onrender.com/userprofiles/${userProfile.id}"),
      body: jsonEncode({updateField: newValue}),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      UserProfile userProfile = UserProfile.fromJson(body);
      String gender = userProfile.gender.toString();
      setState(() {
        this.userProfile = userProfile;
        this.name = gender;
      });
      return true;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "ERROR",
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }
  }

  Future<void> _showDialogText(
      BuildContext context, String title, var oldValue, String updateField) {
    TextEditingController textFieldController =
        TextEditingController(text: oldValue.toString());

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontSize: 26),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: textFieldController,
                  decoration: const InputDecoration(
                    labelText: "kilogram",
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  updateUserProfile(
                          updateField, textFieldController.text.toString())
                      .then((value) => {
                            if (value == true) {Navigator.of(context).pop()}
                            else {Navigator.of(context).pop()}
                          });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    // }).then((value) => {
    // if (value == "CARDIO")
    //   {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SearchExerciseScreen(
    //                   diary: diary,
    //                   exerciseType: "CARDIO",
    //                   userProfile: userProfile,
    //                 )))
    //   }
    // else if (value == "STRENGTH")
    //   {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SearchExerciseScreen(
    //                   diary: diary,
    //                   exerciseType: "STRENGTH",
    //                   userProfile: userProfile,
    //                 )))
    //   }
    // }
    // );
  }
}
