import 'package:fitness_app/components/button/bottom_bar_button.dart';
import 'package:fitness_app/components/button/solid_button.dart';
import 'package:fitness_app/screen/newsfeed/tab/create/create_newsfeed_state.dart';
import 'package:fitness_app/screen/newsfeed/tab/location/search_location_screen.dart';
import 'package:fitness_app/screen/newsfeed/tab/widgets/text_input.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:fitness_app/utilities/date_time.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'create_newsfeed_bloc.dart';

class CreateNewsfeedScreen extends StatefulWidget {
  const CreateNewsfeedScreen({
    super.key,
    required this.type,
    required this.onReload,
  });

  final int type;
  final VoidCallback onReload;

  @override
  State<CreateNewsfeedScreen> createState() => _CreateNewsfeedScreenState();
}

class _CreateNewsfeedScreenState extends State<CreateNewsfeedScreen> {
  late CreateNewsfeedBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateNewsfeedBloc()..getData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<CreateNewsfeedBloc, CreateNewsfeedState>(
        listenWhen: (previous, current) =>
            previous.isSubmitSuccess != current.isSubmitSuccess &&
            current.isSubmitSuccess,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Created successfully')),
          );
          widget.onReload.call();
          Navigator.pop(context);
        },
        child: BlocBuilder<CreateNewsfeedBloc, CreateNewsfeedState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('CREATE NEWS FEED'),
              ),
              bottomNavigationBar: BottomBarButton(
                button1: SizedBox(
                  child: AppSolidButton.medium(
                    'Submit',
                    onPressed: state.isValid
                        ? () {
                            bloc.onCreate();
                          }
                        : null,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    if (state.type == 1) ...[
                      TextInput(
                        hintText: 'Exercise Name',
                        onChanged: (p0) {
                          bloc.onChangeExerciseName(p0);
                        },
                      ),
                      spaceH4,
                      InkWell(
                        onTap: () async {
                          final a = await showDateTimePicker(
                              context: context, initialDate: DateTime.now());
                          if (a != null) {
                            bloc.onChangeExerciseTime(a);
                          }
                        },
                        child: TextInput(
                          key: ObjectKey(state.exerciseTime),
                          readOnly: true,
                          initialValue: state.exerciseTime
                              ?.format(pattern: yyyy_mm_dd_HH_mm),
                          hintText: 'Exercise Time',
                          onChanged: (p0) {},
                        ),
                      ),
                      spaceH4,
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchLocationScreen(
                                              onChange: (p0) {
                                                bloc.onChangeLocation(p0);
                                              },
                                            )));
                              },
                              child: TextInput(
                                key: ObjectKey(state.location),
                                readOnly: true,
                                initialValue: state.location?.location,
                                hintText: 'Location',
                                onChanged: (p0) {},
                              ),
                            ),
                          ),
                          spaceW8,
                          InkWell(
                            onTap: () {
                              bloc.onChangeLocation(null);
                            },
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 6),
                              decoration: BoxDecoration(
                                color: context.appColor.colorRed,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: context.appColor.colorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceH4,
                    ],
                    TextInput(
                      hintText: 'Content',
                      onChanged: (p0) {
                        bloc.onChangeContent(p0);
                      },
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    required DateTime initialDate,
  }) async {
    initialDate;
    final firstDate = initialDate.subtract(const Duration(days: 365 * 100));
    final lastDate = firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
