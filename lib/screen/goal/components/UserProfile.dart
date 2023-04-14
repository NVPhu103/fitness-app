// import 'dart:ffi';

import 'dart:ffi';

class UserProfile {
  String userId;  //have
  String gender;  //have
  Float currentWeight;
  Float height;
  Float desiredWeight;
  int yearOfBirth;
  String activityLevel; //have
  

  UserProfile(this.userId, this.gender, this.currentWeight, this.height,
      this.desiredWeight, this.yearOfBirth, this.activityLevel);

}


// ignore: constant_identifier_names
enum Gender { Female, Male }

// ignore: constant_identifier_names
enum ActivityLevel { NOT_VERY_ACTIVE, LIGHTLY_ACTIVE, ACTIVE, VERY_ACTIVE }

// ignore: constant_identifier_names
enum Goal { LOSE_WEIGHT, MAINTAIN_WEIGHT, GAIN_WEIGHT }