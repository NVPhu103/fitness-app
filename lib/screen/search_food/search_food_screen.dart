import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:flutter/material.dart';

class SearchFoodScreen extends StatefulWidget {
  final Diary diary;

  const SearchFoodScreen({super.key, required this.diary});

  @override
  // ignore: no_logic_in_create_state
  State<SearchFoodScreen> createState() => _SearchFoodScreenState(diary);
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  final Diary diary;

  _SearchFoodScreenState(this.diary);


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
