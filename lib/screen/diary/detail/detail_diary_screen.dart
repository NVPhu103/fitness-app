import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'detail_diary_bloc.dart';
import 'detail_diary_state.dart';

class DetailDiaryScreen extends StatefulWidget {
  const DetailDiaryScreen({super.key});

  @override
  State<DetailDiaryScreen> createState() => _DetailDiaryScreenState();
}

class _DetailDiaryScreenState extends State<DetailDiaryScreen>
    with TickerProviderStateMixin {
  late DetailDiaryBloc bloc;
  late TabController _tabController;

  String filterText = 'Day view';

  @override
  void initState() {
    super.initState();
    bloc = DetailDiaryBloc()..getData();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<DetailDiaryBloc, DetailDiaryState>(
        listenWhen: (p, c) =>
            p.startDate != c.startDate ||
            p.endDate != c.endDate ||
            p.type != c.type,
        listener: (context, state) {
          bloc.onFetch();
        },
        child: BlocBuilder<DetailDiaryBloc, DetailDiaryState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 243, 240, 240),
                  title: const Text(
                    "DETAIL",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  leading: BackButton(color: context.appColor.colorBlack),
                ),
                body: state.data == null
                    ? const Loading()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _tabBar(context),
                            _dateBar(),
                            _itemTitle(context),
                            _item(
                              context,
                              title: 'Protein',
                              avg: state.dataTotal?.protein ?? 0.0,
                              goal: state.data?.protein ?? 0.0,
                              unit: 'gram',
                            ),
                            _item(
                              context,
                              title: 'TotalFat',
                              avg: state.dataTotal?.totalFat ?? 0.0,
                              goal: state.data?.totalFat ?? 0.0,
                              unit: 'gram',
                            ),
                            _item(
                              context,
                              title: 'Cholesterol',
                              avg: state.dataTotal?.cholesterol ?? 0,
                              goal: state.data?.cholesterol ?? 0,
                              unit: 'milligram',
                            ),
                            _item(
                              context,
                              title: 'Carbohydrate',
                              avg: state.dataTotal?.carbohydrate ?? 0.0,
                              goal: state.data?.carbohydrate ?? 0.0,
                              unit: 'gram',
                            ),
                            _item(
                              context,
                              title: 'Sugars',
                              avg: state.dataTotal?.sugars ?? 0.0,
                              goal: state.data?.sugars ?? 0.0,
                              unit: 'gram',
                            ),
                            _item(
                              context,
                              title: 'DietaryFiber',
                              avg: state.dataTotal?.dietaryFiber ?? 0.0,
                              goal: state.data?.dietaryFiber ?? 0.0,
                              unit: 'gram',
                            ),
                            _item(
                              context,
                              title: 'VitaminA',
                              avg: state.dataTotal?.vitaminA ?? 0,
                              goal: state.data?.vitaminA ?? 0,
                              unit: 'microgram',
                            ),
                            _item(
                              context,
                              title: 'VitaminC',
                              avg: state.dataTotal?.vitaminC ?? 0,
                              goal: state.data?.vitaminC ?? 0,
                              unit: 'microgram',
                            ),
                            _item(
                              context,
                              title: 'Canxi',
                              avg: state.dataTotal?.canxi ?? 0,
                              goal: state.data?.canxi ?? 0,
                              unit: 'milligram',
                            ),
                            _item(
                              context,
                              title: 'Natri',
                              avg: state.dataTotal?.natri ?? 0,
                              goal: state.data?.natri ?? 0,
                              unit: 'milligram',
                            ),
                            _item(
                              context,
                              title: 'Kali',
                              avg: state.dataTotal?.kali ?? 0,
                              goal: state.data?.kali ?? 0,
                              unit: 'milligram',
                            ),
                            _item(
                              context,
                              title: 'Iod',
                              avg: state.dataTotal?.iod ?? 0,
                              goal: state.data?.iod ?? 0,
                              unit: 'milligram',
                            ),
                          ],
                        ),
                      ));
          },
        ),
      ),
    );
  }

  Widget _dateBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              spaceW4,
              Text(
                filterText,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.arrow_drop_down,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Day'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Week'),
                  )
                ],
                onSelected: (value) {
                  setState(() {
                    if (value == 0) {
                      filterText = 'Day view';
                    } else {
                      filterText = 'Week view';
                    }
                  });
                  bloc.onChangeType(value);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    bloc.onBack();
                  },
                  icon: const Icon(Icons.arrow_back)),
              Text(
                bloc.state.timeDisplay,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () {
                  bloc.onNext();
                },
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 1.sw / 2,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Avg',
                  style: context.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      'Goal',
                      style: context.textTheme.titleMedium,
                    ),
                    spaceW2,
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Left',
                      style: context.textTheme.titleMedium,
                    ),
                    spaceW16,
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String title,
    required num avg,
    required num goal,
    required String unit,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 1.sw / 2,
                    child: Text(
                      title,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          avg.toString(),
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          goal.toString(),
                          style: context.textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${goal - avg} $unit',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              spaceH12,
              LinearPercentIndicator(
                barRadius: Radius.circular(12.r),
                width: 1.sw / 1.1,
                lineHeight: 20,
                percent: (avg / goal) >= 1 ? 1 : (avg / goal),
                progressColor: _mapperColor(avg / goal),
              )
            ],
          ),
        ),
        const Divider(height: 0, thickness: 1)
      ],
    );
  }

  Color _mapperColor(num percent) {
    if (percent < 0.5) {
      return context.appColor.colorRed;
    } else if (0.5 <= percent && percent <= 1) {
      return context.appColor.colorBlue;
    }
    return context.appColor.colorYello;
  }

  Widget _tabBar(
    BuildContext context,
  ) {
    return TabBar(
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
            'Calories',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.appColor.colorBlack,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Nutrients',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.appColor.colorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
