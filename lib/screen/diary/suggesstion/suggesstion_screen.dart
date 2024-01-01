import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/repository/notifications/models/food_response.dart';
import 'package:fitness_app/screen/search_food/detail/detail_food_screen.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'suggesstion_bloc.dart';
import 'suggesstion_state.dart';

class SuggesstionScreen extends StatefulWidget {
  const SuggesstionScreen({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<SuggesstionScreen> createState() => _SuggesstionScreenState();
}

class _SuggesstionScreenState extends State<SuggesstionScreen> {
  late SuggesstionBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SuggesstionBloc()..getData(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<SuggesstionBloc, SuggesstionState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('FOODS SUGGESSTION'),
            ),
            body: state.dataList == null
                ? const Loading()
                : (state.dataList ?? []).isEmpty
                    ? _empty(context)
                    : ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          top: 16,
                          bottom: 72,
                        ),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) => _item(
                          context,
                          (state.dataList ?? [])[index],
                          index,
                        ),
                        itemCount: (state.dataList ?? []).length,
                        separatorBuilder: (context, index) => const Divider(),
                      ),
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return const Empty();
  }

  Widget _item(
    BuildContext context,
    FoodResponse data,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailFoodScreen(
                      mealId: '',
                      mealName: '',
                      foodId: data.id ?? '',
                      foodName: data.name ?? '',
                      unit: data.unit ?? '',
                      quantity: 1,
                      isUpdate: true,
                      onReload: (value) {},
                      isView: true,
                    )));
      },
      child: ListTile(
        leading: CircleAvatar(
            child: Icon(
          Icons.fastfood_rounded,
          color: context.appColor.colorWhite,
          size: 20,
        )),
        title: Text(data.name ?? ''),
        subtitle: Text('${data.calories ?? 0} calories x ${data.unit ?? ''}'),
      ),
    );
  }
}
