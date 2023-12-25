import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/repository/food_diaries/models/food_diary_response.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'detail_food_bloc.dart';
import 'detail_food_state.dart';
import 'widgets/popup_input_number_servings.dart';

class DetailFoodScreen extends StatefulWidget {
  const DetailFoodScreen({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.foodId,
    required this.foodName,
    required this.unit,
    this.quantity = 1,
    required this.isUpdate,
    required this.onReload,
    this.isView = false,
  });

  final String mealId;
  final String mealName;
  final String foodId;
  final String foodName;
  final String unit;
  final num quantity;
  final bool isUpdate;
  final void Function(FoodDiaryResponse) onReload;
  final bool isView;

  @override
  State<DetailFoodScreen> createState() => _DetailFoodScreenState();
}

class _DetailFoodScreenState extends State<DetailFoodScreen> {
  late DetailFoodBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = DetailFoodBloc()
      ..getData(
        mealId: widget.mealId,
        foodId: widget.foodId,
        foodName: widget.foodName,
        unit: widget.unit,
        quantity: widget.quantity,
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<DetailFoodBloc, DetailFoodState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess && current.isSuccess,
        listener: (context, state) {
          if (state.dataSuccess != null) {
            widget.onReload.call(state.dataSuccess!);
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<DetailFoodBloc, DetailFoodState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: widget.isView
                    ? const Text('Detail')
                    : widget.isUpdate
                        ? const Text('Update')
                        : const Text('Create'),
                actions: [
                  if (!widget.isView)
                    InkWell(
                      onTap: () async {
                        final result = await PopupInputNumBerServings.show(
                          context,
                          initValue: state.quantity.toString(),
                        );
                        if (result != null) {
                          bloc.onSubmit(
                              isUpdate: widget.isUpdate, quantity: result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: widget.isUpdate
                            ? const Icon(Icons.edit)
                            : const Icon(Icons.add),
                      ),
                    )
                ],
              ),
              body: state.data == null
                  ? const Loading()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.foodName,
                            style: context.textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            height: 0,
                            thickness: 2,
                          ),
                          if (!widget.isView)
                            _rowWidget(
                              context,
                              title: 'Meal',
                              value: widget.mealName,
                            ),
                          _rowWidget(
                            context,
                            title: 'Number of Servings',
                            value: state.quantity.toString(),
                          ),
                          _rowWidget(
                            context,
                            title: 'Serving Size',
                            value: widget.unit,
                          ),
                          const SizedBox(height: 20),
                          _summary(context),
                          const SizedBox(height: 20),
                          const Divider(height: 0, thickness: 1),
                          const SizedBox(height: 20),
                          _detail(context),
                          const SizedBox(height: 72),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _detail(BuildContext context) {
    final data = context.read<DetailFoodBloc>().state.data;
    return Column(
      children: [
        _rowWidget2(
          context,
          title: 'Calories',
          value: (data?.calories ?? 0) * widget.quantity,
          unit: '',
        ),
        _rowWidget2(
          context,
          title: 'Protein',
          value: (data?.protein ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'TotalFat',
          value: (data?.totalFat ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'Cholesterol',
          value: (data?.cholesterol ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'Carbohydrate',
          value: (data?.carbohydrate ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'Sugars',
          value: (data?.sugars ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'DietaryFiber',
          value: (data?.dietaryFiber ?? 0) * widget.quantity,
          unit: 'gram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminA',
          value: (data?.vitaminA ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminB1',
          value: (data?.vitaminB1 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminB2',
          value: (data?.vitaminB2 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminB6',
          value: (data?.vitaminB6 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminB9',
          value: (data?.vitaminB9 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminB12',
          value: (data?.vitaminB12 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminC',
          value: (data?.vitaminC ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminD',
          value: (data?.vitaminD ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminE',
          value: (data?.vitaminE ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'VitaminK',
          value: (data?.vitaminK ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Canxi',
          value: (data?.canxi ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Phospho',
          value: (data?.phospho ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Fe',
          value: (data?.fe ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Magie',
          value: (data?.magie ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Zn',
          value: (data?.zn ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Natri',
          value: (data?.natri ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Iod',
          value: (data?.iod ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Omega3',
          value: (data?.omega3 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Omega6',
          value: (data?.omega6 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
        _rowWidget2(
          context,
          title: 'Omega9',
          value: (data?.omega9 ?? 0) * widget.quantity,
          unit: 'milligram',
        ),
      ],
    );
  }

  Widget _summary(BuildContext context) {
    final state = context.read<DetailFoodBloc>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: context.appColor.colorOrange,
            ),
            shape: BoxShape.circle,
          ),
          child: _columWidget(
            context,
            title: 'Cal',
            value: ((state.data?.calories ?? 0) * widget.quantity).toString(),
          ),
        ),
        _columWidget(
          context,
          title: 'Carbs',
          value: ((state.data?.carbohydrate ?? 0) * widget.quantity).toString(),
        ),
        _columWidget(
          context,
          title: 'Fat',
          value: ((state.data?.totalFat ?? 0) * widget.quantity).toString(),
        ),
        _columWidget(
          context,
          title: 'Protein',
          value: ((state.data?.protein ?? 0) * widget.quantity).toString(),
        ),
      ],
    );
  }

  Widget _columWidget(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: context.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _rowWidget(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge,
            ),
            Text(
              value,
              style: context.textTheme.titleLarge
                  ?.copyWith(color: context.appColor.colorBlue),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _rowWidget2(
    BuildContext context, {
    required String title,
    required num value,
    required String unit,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                color: value == 0 ? context.appColor.colorGrey : null,
              ),
            ),
            Text(
              '$value $unit',
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}
