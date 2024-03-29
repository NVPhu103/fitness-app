// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_app/repository/food_diaries/models/food_diary_response.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/diary_screen.dart';
import 'package:fitness_app/screen/search_food/components/food.dart';
import 'package:fitness_app/screen/search_food/components/food_history.dart';
import 'package:fitness_app/screen/search_food/detail/detail_food_screen.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class SearchFoodScreen extends StatefulWidget {
  final Diary diary;
  final UserProfile userProfile;
  bool isSelectedValue;
  String? meal;
  bool isUpdate;
  final void Function(FoodDiaryResponse) onReload;
  SearchFoodScreen({
    super.key,
    required this.diary,
    required this.userProfile,
    this.isSelectedValue = false,
    this.meal,
    required this.isUpdate,
    required this.onReload,
  });

  @override
  State<SearchFoodScreen> createState() =>
      _SearchFoodScreenState(diary, isSelectedValue, meal, userProfile);
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  Diary diary;
  UserProfile userProfile;
  final List<String> itemsList = [
    'Breakfast',
    'Lunch',
    'Dining',
  ];
  String? selectedValue;
  bool isSelectedValue;
  String? meal;
  String? mealId;
  List<Food> listFoods = [];
  TextEditingController searchTextController = TextEditingController();
  final listViewController = ScrollController();
  int page = 2;
  int perPage = 10;
  bool hasMore = true;
  bool isLoading = false;
  List<FoodHistory> listFoodHistories = [];
  bool isShowHistory = true;

  _SearchFoodScreenState(
      this.diary, this.isSelectedValue, this.meal, this.userProfile);

  @override
  void initState() {
    super.initState();
    getAllFoodHistories(diary.userId);
    listViewController.addListener(() {
      if (listViewController.position.maxScrollExtent ==
          listViewController.offset) {
        fetch(searchTextController.text);
      }
    });
    if (isSelectedValue) {
      selectedValue = meal;
    }
  }

  Future fetch(String value) async {
    if (isLoading) return;
    isLoading = true;
    // ignore: constant_identifier_names
    String url =
        "https://fitness-app-e0xl.onrender.com/foods?q=$value&page=$page&per_page=$perPage";
    // ignore: non_constant_identifier_names
    Response get_food_response = await get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (get_food_response.body.isNotEmpty) {
      List<dynamic> listNewFoods = jsonDecode(utf8.decode(get_food_response.bodyBytes));
      setState(() {
        page++;
        isLoading = false;
        if (listNewFoods.length < perPage) {
          hasMore = false;
        }
        for (int i = 0; i < listNewFoods.length; i++) {
          listFoods.add(Food.fromJson(listNewFoods[i]));
        }
      });
    }
  }

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            if (isSelectedValue == false) {
              Navigator.pop(context, diary);
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DiaryScreen(
                            name: "",
                            diary: diary,
                            userProfile: userProfile,
                          )));
            }
          },
        ),
        title: dropdownButtonTitle(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Container(
                height: size.height * 0.08,
                width: size.width * 0.94,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29.5),
                    border: Border.all(color: Colors.blueAccent, width: 2)),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      listFoods = [];
                      isLoading = false;
                      hasMore = true;
                      page = 2;
                      isShowHistory = false;
                    });
                    getAllFoods(value);
                  },
                  controller: searchTextController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    hintText: "Search for a food",
                    icon: SvgPicture.asset(
                      "assets/icons/search.svg",
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: searchTextController.clear,
                      icon: const Icon(Icons.clear, color: null),
                      hoverColor: Colors.white10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.96,
                child: isShowHistory
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            "Food History",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            "Food",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
            // ListView
            SizedBox(
              height: size.height * 0.72,
              width: size.width * 0.96,
              child: isShowHistory
                  ? RefreshIndicator(
                      onRefresh: () => getAllFoodHistories(diary.userId),
                      child: ListView.builder(
                        controller: listViewController,
                        itemCount: listFoodHistories.length + 1,
                        itemBuilder: (context, index) {
                          if (listFoodHistories.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text("No history found"),
                              ),
                            );
                          }
                          if (index < listFoodHistories.length) {
                            final item = listFoodHistories[index].food;
                            return InkWell(
                              onTap: () {
                                if (selectedValue == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "You have to select a meal",
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 1),
                                  ));
                                } else {
                                  switch (selectedValue) {
                                    case "Breakfast":
                                      mealId = diary.breakfastId;
                                      break;
                                    case "Lunch":
                                      mealId = diary.lunchId;
                                      break;
                                    case "Dining":
                                      mealId = diary.diningId;
                                      break;
                                    default:
                                      mealId = diary.breakfastId;
                                  }
                                }
                              },
                              child: Card(
                                color: const Color.fromARGB(220, 255, 255, 255),
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(item.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  subtitle: Text(
                                      "${item.calories} calories, ${item.unit}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      )),
                                  trailing: InkWell(
                                    borderRadius: BorderRadius.circular(29),
                                    onTap: () {
                                      addFood(item.id);
                                    },
                                    child: const Icon(
                                      Icons.add_circle_rounded,
                                      color: Colors.blueAccent,
                                      size: 40,
                                    ),
                                  ),
                                  onTap: () {
                                    if (selectedValue == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "You have to select a meal",
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(seconds: 1),
                                      ));
                                    } else {
                                      switch (selectedValue) {
                                        case "Breakfast":
                                          mealId = diary.breakfastId;
                                          break;
                                        case "Lunch":
                                          mealId = diary.lunchId;
                                          break;
                                        case "Dining":
                                          mealId = diary.diningId;
                                          break;
                                        default:
                                          mealId = diary.breakfastId;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailFoodScreen(
                                                    mealId: mealId ?? '',
                                                    mealName:
                                                        selectedValue ?? '',
                                                    foodId: item.id,
                                                    foodName: item.name,
                                                    unit: item.unit,
                                                    isUpdate: widget.isUpdate,
                                                    onReload: (value) {
                                                      widget.onReload
                                                          .call(value);
                                                      // reload
                                                      setState(() {
                                                        diary = value.diary;
                                                      });
                                                    },
                                                  )));
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    )
                  : ListView.builder(
                      controller: listViewController,
                      itemCount: listFoods.length + 1,
                      itemBuilder: (context, index) {
                        if (listFoods.isEmpty) {
                          if (isShowHistory == false) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text("Not found"),
                              ),
                            );
                          } else {
                            return null;
                          }
                        }
                        if (index < listFoods.length) {
                          final item = listFoods[index];
                          return Card(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(item.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              subtitle: Text(
                                  "${item.calories} calories, ${item.unit}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  )),
                              trailing: InkWell(
                                borderRadius: BorderRadius.circular(29),
                                onTap: () {
                                  addFood(item.id);
                                },
                                child: const Icon(
                                  Icons.add_circle_rounded,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                              onTap: () {
                                if (selectedValue == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "You have to select a meal",
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 1),
                                  ));
                                } else {
                                  switch (selectedValue) {
                                    case "Breakfast":
                                      mealId = diary.breakfastId;
                                      break;
                                    case "Lunch":
                                      mealId = diary.lunchId;
                                      break;
                                    case "Dining":
                                      mealId = diary.diningId;
                                      break;
                                    default:
                                      mealId = diary.breakfastId;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailFoodScreen(
                                                mealId: mealId ?? '',
                                                mealName: selectedValue ?? '',
                                                foodId: item.id,
                                                foodName: item.name,
                                                unit: item.unit,
                                                isUpdate: widget.isUpdate,
                                                onReload: (value) {
                                                  // widget.onReload.call(value);
                                                  // reload
                                                  setState(() {
                                                    diary = value.diary;
                                                  });
                                                },
                                              )));
                                }
                              },
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: hasMore
                                  ? const CircularProgressIndicator()
                                  : const Text("No more data to load"),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButtonHideUnderline dropdownButtonTitle() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonStyleData: const ButtonStyleData(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(28)))),
        value: selectedValue,
        hint: const Text(
          "Select a Meal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        items: itemsList
            .map((item) => DropdownMenuItem(
                  value: item,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
        focusNode: FocusNode(canRequestFocus: false),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(),
      ),
    );
  }

  Future<void> addFood(String foodId) async {
    if (selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "You have to select a meal",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
      ));
    } else {
      switch (selectedValue) {
        case "Breakfast":
          mealId = diary.breakfastId;
          break;
        case "Lunch":
          mealId = diary.lunchId;
          break;
        case "Dining":
          mealId = diary.diningId;
          break;
        default:
          mealId = diary.breakfastId;
      }
      try {
        Response postFoodDiaryResponse = await post(
          Uri.parse("https://fitness-app-e0xl.onrender.com/fooddiaries"),
          body: jsonEncode({"mealId": mealId, "foodId": foodId, "quantity": 1}),
          headers: {'Content-Type': 'application/json'},
        );
        if (postFoodDiaryResponse.statusCode == 201) {
          var diaryBody = jsonDecode(utf8.decode(postFoodDiaryResponse.bodyBytes))['diary'];
          Diary newDiary = Diary.fromJson(diaryBody);
          setState(() {
            diary = newDiary;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Food added successfully",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Something wrong",
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  Future<List<Food>> getAllFoods(String value) async {
    if (value.isNotEmpty) {
      String uri =
          "https://fitness-app-e0xl.onrender.com/foods?q=$value&page=1&per_page=10";
      try {
        // ignore: non_constant_identifier_names
        Response get_food_response = await get(
          Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
        );
        if (get_food_response.statusCode == 200) {
          setState(() {
            // ignore: non_constant_identifier_names
            List<dynamic> get_food_response_body =
                jsonDecode(utf8.decode(get_food_response.bodyBytes));
            for (int i = 0; i < get_food_response_body.length; i++) {
              listFoods.add(Food.fromJson(get_food_response_body[i]));
            }
            if (listFoods.length < perPage) {
              hasMore = false;
            }
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            get_food_response.body,
            textAlign: TextAlign.center,
          )));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "No keywords to search",
        textAlign: TextAlign.center,
      )));
    }
    return listFoods;
  }

  Future<void> getAllFoodHistories(String userId) async {
    if (userId.isNotEmpty) {
      String uri =
          "https://fitness-app-e0xl.onrender.com/foodhistories/$userId";
      try {
        // ignore: non_constant_identifier_names    print("step1");
        Response get_food_history_response = await get(
          Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
        );
        if (get_food_history_response.statusCode == 200) {
          setState(() {
            // ignore: non_constant_identifier_names
            List<dynamic> get_food__history_response_body =
                jsonDecode(utf8.decode(get_food_history_response.bodyBytes));
            for (int i = 0; i < get_food__history_response_body.length; i++) {
              listFoodHistories.add(
                  FoodHistory.fromJson(get_food__history_response_body[i]));
            }
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            get_food_history_response.body,
            textAlign: TextAlign.center,
          )));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please enter user id",
        textAlign: TextAlign.center,
      )));
    }
  }
}
