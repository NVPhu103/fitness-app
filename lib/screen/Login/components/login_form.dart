// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:fitness_app/screen/dashboard/dashboard.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/goal/set_goal_screen_1.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:fitness_app/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/already_have_an_account_acheck.dart';
import 'package:fitness_app/utilities/constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String email, String password, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (email.isNotEmpty && password.isNotEmpty) {
      Response response = await post(
        Uri.parse("https://fitness-app-e0xl.onrender.com/users/login"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String userId = body['id'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetGoalScreen1(
                      userId: userId,
                    )));
      } else if (response.statusCode == 202) {
        var body = jsonDecode(response.body);
        // Get totalCaloriesIntake from diary
        String userId = body['id'];
        String today = getTodayWithYMD();
        Response diaryResponse = await get(
          Uri.parse(
              "https://fitness-app-e0xl.onrender.com/diaries/$userId?date=$today"),
          headers: {'Content-Type': 'application/json'},
        );
        var diaryBody = jsonDecode(diaryResponse.body);
        Diary diary = Diary.fromJson(diaryBody);
        String gender = body['userProfile']['gender'];
        var userProfileBody = body['userProfile'];
        UserProfile userProfile = UserProfile.fromJson(userProfileBody);
        await prefs.setString('USER_PROFILE', jsonEncode(userProfile.toJson()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                      name: gender,
                      diary: diary,
                      userProfile: userProfile,
                    )));
      } else {
        var body = jsonDecode(response.body);
        if (response.statusCode == 422) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            body['detail'][0]['msg'].toString(),
            textAlign: TextAlign.center,
          )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            body['detail'].toString(),
            textAlign: TextAlign.center,
          )));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Black Field Not Allowed",
        textAlign: TextAlign.center,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.mail),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () => login(emailController.text.toString(),
                  passwordController.text.toString(), context),
              child: Text(
                "Login".toUpperCase(),
                style: TextStyle(color: context.appColor.colorWhite),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
