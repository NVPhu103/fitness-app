import 'package:intl/intl.dart';

String getTodayWithYMD() {
    DateTime today = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(today);
  }

String getTomorrowWithYMD() {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(tomorrow);
  }

String getYesterdayWithYMD() {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(yesterday);
  }

String transferDateTimeToString(DateTime date){
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

String getDate(String diaryDate) {
    String date;
    String today = getTodayWithYMD();
    String tomorrow = getTomorrowWithYMD();
    String yesterday = getYesterdayWithYMD();
    if (today == diaryDate){
      date = "Today";
    }else if (tomorrow == diaryDate){
      date = "Tomorrow";
    }else if(yesterday == diaryDate){
      date = "Yesterday";
    }else{
      date = diaryDate;
    }
    return date;
  }