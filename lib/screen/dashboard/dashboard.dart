import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pie_chart/pie_chart.dart';

class Dashboard extends StatelessWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;
  const Dashboard(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake});

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
      home: DashboardPage(
          maximumCaloriesIntake: maximumCaloriesIntake,
          totalCaloriesIntake: totalCaloriesIntake),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;
  const DashboardPage(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: const ButtonNavBar(),
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
                Statistics(
                    maximumCaloriesIntake: maximumCaloriesIntake,
                    totalCaloriesIntake: totalCaloriesIntake),
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

class Statistics extends StatelessWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;

  Statistics({
    super.key,
    required this.maximumCaloriesIntake,
    required this.totalCaloriesIntake,
  });

  Map<String, double> dataMap = {
    "Intake": 1000,
    "Remaining": 1564,
  };

  List<Color> colorList = [
    Color.fromARGB(255, 128, 183, 235),
    Color.fromARGB(255, 201, 198, 198)
  ];

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

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
        child: Center(
          child: PieChart(
            dataMap: dataMap,
            colorList: colorList,
            chartRadius: MediaQuery.of(context).size.width / 4,
            centerText: maximumCaloriesIntake.toString(),
            ringStrokeWidth: 24,
            animationDuration: const Duration(seconds: 3),
            chartType: ChartType.ring,
            chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValuesInPercentage: true,
                showChartValueBackground: false),
            legendOptions: const LegendOptions(
                showLegends: true,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(fontSize: 15),
                legendPosition: LegendPosition.right,
                showLegendsInRow: true),
            // gradientList: gradientList,
          ),
        ),
      ),
    );
  }
}
