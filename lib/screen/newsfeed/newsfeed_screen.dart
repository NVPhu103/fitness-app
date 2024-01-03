import 'package:fitness_app/screen/dashboard/components/button_navigation_bar.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tab/newsfeed_tab.dart';
import 'tab/newsfeed_tab_bloc.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({
    super.key,
    required this.name,
    required this.diary,
    required this.userProfile,
  });

  final String name;
  final Diary diary;
  final UserProfile userProfile;

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtonNavBar(
        isNewsfeedActive: true,
        name: widget.name,
        diary: widget.diary,
        userProfile: widget.userProfile,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "NEWS FEED",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        _tabBar(context),
        Expanded(
          child: ColoredBox(
            color: const Color(0xFFECECEE),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _tabController.index = value;
                });
              },
              itemCount: _tabController.length,
              itemBuilder: (c, i) {
                return BlocProvider(
                  create: (context) => NewsfeedTabBloc(
                    currentTab: i,
                  )..getData(),
                  child: const NewsfeedTab(),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _tabBar(
    BuildContext context,
  ) {
    return TabBar(
      onTap: (value) async {
        _pageController.jumpToPage(value);
      },
      controller: _tabController,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: context.appColor.colorBlue,
        ),
      ),
      tabs: [
        Tab(
          child: Text(
            'ALL',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: _tabController.index == 0
                  ? context.appColor.colorBlack
                  : context.appColor.colorBlack.withOpacity(0.5),
            ),
          ),
        ),
        Tab(
          child: Text(
            'MY SELF',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: _tabController.index == 1
                  ? context.appColor.colorBlack
                  : context.appColor.colorBlack.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
