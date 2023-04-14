import 'dart:convert';

import 'package:fitness_app/screen/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

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
    if (email.isNotEmpty && password.isNotEmpty) {
      Response response = await post(
        Uri.parse("http://127.0.0.1:8000/users/login"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
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
