import 'package:flutter/material.dart';
import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter_svg/svg.dart';

class ButtonNavBar extends StatelessWidget {
  const ButtonNavBar({
    super.key,
  });

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
              isActive: true,
              press: () {},
            ),
            BottomNavItem(
              title: "Diary",
              svgScr: "assets/icons/diary.svg",
              press: () {},
            ),
            BottomNavItem(
              title: "Settings",
              svgScr: "assets/icons/Settings.svg",
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