import 'package:fitness_app/screen/dashboard/dashboard.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/diary_screen.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/screen/user_profile/edit_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ButtonNavBar extends StatelessWidget {
  final String name;
  bool isDashboardActive;
  bool isDiaryActive;
  bool isSettingActive;
  Diary diary;
  UserProfile userProfile;

  ButtonNavBar(
      {super.key,
      this.isDashboardActive = false,
      this.isDiaryActive = false,
      this.isSettingActive = false,
      required this.diary,
      required this.name,
      required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 60,
      color: Colors.white,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BottomNavItem(
              title: "Dashboard",
              svgScr: "assets/icons/dashboard.svg",
              isActive: isDashboardActive,
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                              name: name,
                              diary: diary,
                              userProfile: userProfile,
                            )));
              },
            ),
            BottomNavItem(
              title: "Diary",
              svgScr: "assets/icons/diary.svg",
              isActive: isDiaryActive,
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryScreen(
                              name: name,
                              diary: diary,
                              userProfile: userProfile,
                            )));
              },
            ),
            BottomNavItem(
              title: "Profile",
              svgScr: "assets/icons/Settings.svg",
              isActive: isSettingActive,
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserprofileScreen(
                              name: name,
                              diary: diary,
                              userProfile: userProfile,
                            )));
              },
            ),
          ]),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgScr;
  final String title;
  final Function press;
  final bool isActive;
  const BottomNavItem({
    super.key,
    required this.svgScr,
    required this.title,
    required this.press,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgScr,
            color: isActive ? kActiveIconColor : kTextColor,
          ),
          Text(
            title,
            style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
          ),
        ],
      ),
    );
  }
}
