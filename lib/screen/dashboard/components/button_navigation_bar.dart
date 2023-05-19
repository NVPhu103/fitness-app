import 'package:fitness_app/screen/dashboard/dashboard.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/diary_screen.dart';
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

  ButtonNavBar(
      {super.key,
      this.isDashboardActive = false,
      this.isDiaryActive = false,
      this.isSettingActive = false,
      required this.diary,
      required this.name});

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                              name: name,
                              diary: diary,
                            )));
              },
            ),
            BottomNavItem(
              title: "Diary",
              svgScr: "assets/icons/diary.svg",
              isActive: isDiaryActive,
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryScreen(
                              name: name,
                              diary: diary,
                            )));
              },
            ),
            BottomNavItem(
              title: "Settings",
              svgScr: "assets/icons/Settings.svg",
              isActive: isSettingActive,
              press: () {},
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
