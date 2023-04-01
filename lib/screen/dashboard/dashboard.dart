import 'dart:ffi';

import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DASHBOARD',
      theme: ThemeData(
        fontFamily: "Cairo",
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(displayColor: kTextColor),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: ButtonNavBar(),
      body: Stack(children: <Widget>[
        Container(
          height: size.height * .48,
          decoration: const BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: AssetImage("assets/images/undraw_pilates_gpdb.png"))),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Stack(
                      children: const <Widget>[
                        Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 40,
                        ),
                        Positioned(
                            child: Icon(
                          Icons.brightness_1,
                          color: Colors.red,
                          size: 12,
                        ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Good morning \nSir",
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w900)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5)),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        icon: SvgPicture.asset("assets/icons/search.svg"),
                        border: InputBorder.none),
                  ),
                ),
                const Statistics(),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

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
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Dashboard();
                }),
                );
              },
            ),
            BottomNavItem(
              title: "Diary",
              svgScr: "assets/icons/diary.svg",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Dashboard();
                }),
                );
              },
            ),
            BottomNavItem(
              title: "Settings",
              svgScr: "assets/icons/Settings.svg",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Dashboard();
                }),
                );
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

class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 12),
              blurRadius: 12,
              spreadRadius: 0,
              color: kShadowColor,
            ),
          ],
        ),
      ),
    );
  }
}
