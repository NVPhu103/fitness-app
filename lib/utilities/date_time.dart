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
}
