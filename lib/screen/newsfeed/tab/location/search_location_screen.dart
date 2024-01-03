import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/components/search_input.dart';
import 'package:fitness_app/repository/newsfeed/models/location_response.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'search_location_bloc.dart';
import 'search_location_state.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key, required this.onChange});

  final void Function(LocationResponse?) onChange;

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  late SearchLocationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SearchLocationBloc()..getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<SearchLocationBloc, SearchLocationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 243, 240, 240),
            appBar: AppBar(
              title: const Text('LOCATION'),
            ),
            body: Column(
              children: [
                _buildSearchField(),
                state.isLoading
                    ? const Loading()
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          top: 16.h,
                          right: 16.w,
                          bottom: 72.h,
                          left: 16.w,
                        ),
                        itemBuilder: (context, index) {
                          final item = state.dataList?[index];
                          return InkWell(
                            onTap: () {
                              widget.onChange.call(item);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.h),
                                    child: Text(
                                      item?.location ?? '',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.dataList?.length ?? 0,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return SearchInput(
      hintText: 'Search...',
      onChanged: (keyword) {
        bloc.onFetch(keyword);
      },
    );
  }
}
