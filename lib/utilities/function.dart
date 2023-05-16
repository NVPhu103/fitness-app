import 'package:intl/intl.dart';

String getTodayWithYMD() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }