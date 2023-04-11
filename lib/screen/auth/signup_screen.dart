import 'dart:convert';

import 'package:fitness_app/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/signup.png',
            //   fit: BoxFit.cover,
            //   height: 300,
            //   width: 350,
            // ),
            const SizedBox(
              height: 20,
              width: 20,
            ),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Courier',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 32,
              ),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your Email',
                      labelText: 'Email',
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your Username',
                      labelText: 'Username',
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: usernameController,
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your Password',
                      labelText: 'Password',
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your ConfirmPassword',
                      labelText: 'ConfirmPassword',
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: confirmpasswordController,
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      SignUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 35,
                      child: Text('Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.blue)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.yellow,
                        ),
                      ),
                      TextButton(
                        onPressed: (() {
                          var MyRoutes;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  const Text(
                    'Wish you a lot of health when using our application!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.yellow,
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

  Future<void> SignUp() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        confirmpasswordController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      var response = await http.post(Uri.parse("http://127.0.0.1:8000/users"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': usernameController.text,
            'password': passwordController.text,
            'email': emailController.text,
            'confirmpassword': confirmpasswordController.text,
          }));
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Credentials. ")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Black Field Not Allowed")));
    }
  }
}
