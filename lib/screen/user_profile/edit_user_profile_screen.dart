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
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              customText("Starting weight", 24),
              TextButton(
                  onPressed: () {},
                  child: customText(userProfile.startingWeight.toString(), 24))
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              customText("Current weight", 24),
              TextButton(
                  onPressed: () {},
                  child: customText(userProfile.currentWeight.toString(), 24))
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              customText("   Goal weight   ", 24),
              TextButton(
                  onPressed: () {},
                  child: customText(userProfile.desiredWeight.toString(), 24))
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              customText("Starting weight", 24),
              TextButton(
                  onPressed: () {},
                  child: customText(userProfile.startingWeight.toString(), 24))
            ],
          )
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
}
