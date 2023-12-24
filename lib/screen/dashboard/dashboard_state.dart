import 'package:copy_with_extension/copy_with_extension.dart';

part 'dashboard_state.g.dart';

@CopyWith()
class DashboardState {
  final int numNoti;

  const DashboardState({
    this.numNoti = 0,
  });
}
