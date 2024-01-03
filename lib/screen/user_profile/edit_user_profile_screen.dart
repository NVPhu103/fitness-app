// ignore_for_file: no_logic_in_create_state

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/material.dart';

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
                            _showDialog(context, "Current weight");
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
                          onPressed: () {},
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
                          onPressed: () {},
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

  Future<void> _showDialog(BuildContext context, String title) {
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
                onPressed: () {},
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
