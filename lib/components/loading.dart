import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Empty',
        style: context.textTheme.titleMedium,
      ),
    );
  }
}
