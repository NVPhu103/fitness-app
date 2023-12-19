import 'package:fitness_app/screen/Welcome/welcome_screen.dart';
import 'package:fitness_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MYFITNESS',
            theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: kPrimaryColor,
                    shape: const StadiumBorder(),
                    maximumSize: const Size(double.infinity, 56),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  iconColor: kPrimaryColor,
                  prefixIconColor: kPrimaryColor,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                )),
            home: const WelcomeScreen(),
          );
        });
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return const WelcomeScreen();
//   }
// }
