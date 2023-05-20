import 'package:fitness_app/screen/diary/components/diary.dart';
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

String getDate(Diary diary) {
    String date;
    String today = getTodayWithYMD();
    String tomorrow = getTomorrowWithYMD();
    String yesterday = getYesterdayWithYMD();
    if (today == diary.date){
      date = "Today";
    }else if (tomorrow == diary.date){
      date = "Tomorrow";
    }else if(yesterday == diary.date){
      date = "Yesterday";
    }else{
      date = diary.date;
    }
    return date;
  }