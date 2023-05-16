// ignore_for_file: no_logic_in_create_state

import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/search_food/search_food_screen.dart';
import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Dashboard extends StatelessWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;
  final Diary diary;

  const Dashboard(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake,
      required this.diary});

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
        totalCaloriesIntake: totalCaloriesIntake,
        diary: diary,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;
  final Diary diary;

  const DashboardPage(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake,
      required this.diary});

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
                  height: size.height * 0.05,
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Stack(
                      children: <Widget>[
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
                SizedBox(
                  height: size.height * 0.17,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text("Good morning \nSir",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.w900)),
                  ),
                ),
                Container(
                  height: size.height * 0.08,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5)),
                  child: TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          fontSize: 20,
                        ),
                        hintText: "Search",
                        icon: SvgPicture.asset("assets/icons/search.svg"),
                        border: InputBorder.none),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchFoodScreen(
                                    diary: diary,
                                  ))),
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                // Chart
                Chart(
                  maximumCaloriesIntake: maximumCaloriesIntake,
                  totalCaloriesIntake: totalCaloriesIntake,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class Chart extends StatefulWidget {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;
  const Chart(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake});

  @override
  State<Chart> createState() =>
      _ChartState(maximumCaloriesIntake, totalCaloriesIntake);
}

class _ChartState extends State<Chart> {
  final int maximumCaloriesIntake;
  final int totalCaloriesIntake;

  _ChartState(this.maximumCaloriesIntake, this.totalCaloriesIntake);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: size.height * 0.52,
        width: size.width * 0.98,
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
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: size.height * 0.12,
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                      child: Text(
                        "Calories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text("Remaining  =  Goal  -  Food  +  Exercise"),
                    ),
                  ]),
            ),
            SizedBox(
              height: size.height * 0.4,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: RadialGauge(
                      maximumCaloriesIntake: maximumCaloriesIntake,
                      totalCaloriesIntake: totalCaloriesIntake,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        RowBehindGauge(
                          text: "Base Goal",
                          data: maximumCaloriesIntake,
                          icons: Icons.flag,
                          iconColor: Colors.green,
                        ),
                        RowBehindGauge(
                          text: "Food",
                          data: totalCaloriesIntake,
                          icons: Icons.food_bank,
                          iconColor: Colors.blue,
                        ),
                        const RowBehindGauge(
                          text: "Exercise",
                          data: 0,
                          icons: Icons.fitness_center,
                          iconColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowBehindGauge extends StatelessWidget {
  const RowBehindGauge({
    super.key,
    required this.data,
    required this.icons,
    required this.text,
    required this.iconColor,
  });

  final int data;
  final String text;
  final IconData icons;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icons,
            color: iconColor,
            size: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                child: Text(
                  data.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class RadialGauge extends StatefulWidget {
  final int? maximumCaloriesIntake;
  final int? totalCaloriesIntake;
  const RadialGauge(
      {super.key,
      required this.maximumCaloriesIntake,
      required this.totalCaloriesIntake});

  @override
  State<RadialGauge> createState() =>
      _RadialGaugeState(maximumCaloriesIntake, totalCaloriesIntake);
}

class _RadialGaugeState extends State<RadialGauge> {
  final int? maximumCaloriesIntake;
  final int? totalCaloriesIntake;

  _RadialGaugeState(this.maximumCaloriesIntake, this.totalCaloriesIntake);

  double calculatePercentageOfGauge() {
    double percentageOfGauge =
        (totalCaloriesIntake! / maximumCaloriesIntake!) * 100;
    if (percentageOfGauge > 100) {
      return 100;
    } else {
      return percentageOfGauge;
    }
  }

  String calculateRemainingCalories() {
    int remainingCalories = maximumCaloriesIntake! - totalCaloriesIntake!;
    return remainingCalories.toString();
  }

  @override
  Widget build(BuildContext context) {
    String textData = calculateRemainingCalories();
    double percentageOfGauge = calculatePercentageOfGauge();

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.7,
            axisLineStyle: const AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 180,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        textData,
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal),
                      ),
                      const Text(
                        'Remaining',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                  value: percentageOfGauge,
                  cornerStyle: CornerStyle.bothCurve,
                  enableAnimation: true,
                  animationDuration: 1200,
                  sizeUnit: GaugeSizeUnit.factor,
                  gradient: const SweepGradient(
                      colors: <Color>[Color(0xFF6A6EF6), Color(0xFFDB82F5)],
                      stops: <double>[0.25, 0.75]),
                  color: const Color(0xFF00A8B5),
                  width: 0.15),
            ]),
      ],
    );
  }
}
