// ignore_for_file: no_logic_in_create_state


import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditUserprofileScreen extends StatefulWidget {
  final String name;
  Diary diary;

  EditUserprofileScreen({super.key, required this.name, required this.diary});

  @override
  State<EditUserprofileScreen> createState() =>
      _EditUserprofileScreenState(diary, name);
}

class _EditUserprofileScreenState extends State<EditUserprofileScreen> {
  String name;
  Diary diary;
  // var userProfile;

  _EditUserprofileScreenState(this.diary, this.name);

  @override
  void initState() {
    // getListUserProfile();
    super.initState();
  }

  // Future<void> getListUserProfile() async {
  //   String url = "http://127.0.0.1:8000/userprofiles/${diary.userId}";
  //   // ignore: non_constant_identifier_names
  //   Response get_user_profile_response = await get(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (get_user_profile_response.body.isNotEmpty) {
  //     var userProfileJson = jsonDecode(get_user_profile_response.body);
  //     setState(() {
  //       userProfile = userProfileJson;
  //     });
  //     print(userProfile);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: ButtonNavBar(
        name: name,
        isSettingActive: true,
        diary: diary,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        automaticallyImplyLeading: false,
        title: const Text(
          "USER PROFILE",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 36,
              )),
          SizedBox(
            width: size.width * 0.01,
          )
        ],
      ),
      body: const Column(),
    );
  }

  Text customText(String data, double size,
      {FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      data,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
