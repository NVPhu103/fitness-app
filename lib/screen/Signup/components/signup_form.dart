import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../components/already_have_an_account_acheck.dart';
import 'package:fitness_app/utilities/constants.dart';
import '../../Login/login_screen.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signup(
      String email, String password, String confirmPassword, context) async {
    if (email.isNotEmpty && confirmPassword.isNotEmpty && password.isNotEmpty) {
      Response response = await post(
        Uri.parse("https://fitness-app-e0xl.onrender.com/users"),
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
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
              hintText: "Enter your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
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
                hintText: "Enter your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          TextFormField(
            controller: confirmPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Confirm password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: ElevatedButton(
              onPressed: () => signup(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  confirmPasswordController.text.toString(),
                  context),
              child: Text("Sign Up".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
