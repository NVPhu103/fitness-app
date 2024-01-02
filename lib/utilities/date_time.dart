import 'package:intl/intl.dart';

const dd_mm_yyyy = 'dd/MM/yyyy';
const yyyy_mm_dd = 'yyyy-MM-dd';
const yy_mm_dd = 'yy-MM-dd';
const yyyy_mm_dd_HH_mm = 'yyyy-MM-dd HH:mm';

extension FormatDate on DateTime {
  DateTime get toDay {
    return DateTime(year, month, day);
  }

  String format({String? locale, required String pattern}) {
    return DateFormat(pattern, locale).format(this);
  }

  String getDiffFromToday() {
    final diffDays = DateTime.now().difference(this).inDays;
    final diffHours = DateTime.now().difference(this).inHours;
    final diffMins = DateTime.now().difference(this).inMinutes;

    if (diffDays > 30) {
      return '${(diffDays / 30).round()} months ago';
    }
    if (diffDays < 30 && diffDays > 0) {
      return '$diffDays days ago';
    }
    if (diffDays == 0 && diffHours <= 24 && diffHours > 0) {
      return '$diffHours hours ago';
    }
    if (diffHours == 0 && diffMins <= 60 && diffMins > 0) {
      return '$diffMins minutes ago';
    }
    return 'seconds ago';
  }
}
