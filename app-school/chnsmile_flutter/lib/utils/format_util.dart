import 'package:hi_base/string_util.dart';
import 'package:intl/intl.dart';

///时间转换将秒转换为分钟:秒
String durationTransform(int seconds) {
  int m = (seconds / 60).truncate();
  int s = seconds - m * 60;
  if (s < 10) {
    return '$m:0$s';
  }
  return '$m:$s';
}

///数字转万
String countFormat(int count) {
  String views = "";
  if (count > 9999) {
    views = "${(count / 10000).toStringAsFixed(2)}万";
  } else {
    views = count.toString();
  }
  return views;
}

///日期格式化，2022-06-11 -> 2022
String dateYear2(String dateStr) {
  var arr = dateStr.split("-");
  var dateStr2 = "";
  for (var i = 0; i < arr.length; i++) {
    var item = arr[i];
    if(i == arr.length - 1) {
      if (item.length == 1) {
        dateStr2 += '0' + item;
      } else {
        dateStr2 += item;
      }
    } else {
      if (item.length == 1) {
        dateStr2 += '0' + item + "-";
      } else {
        dateStr2 += item + "-";
      }
    }
  }
  DateTime now = DateTime.parse(dateStr2);
  DateFormat formatter = DateFormat('yyyy');
  String formatted = formatter.format(now);
  return formatted;
}

///日期格式化，2022-06-11 20:06:43 -> 2022
String dateYear(String dateStr) {
  DateTime now = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('yyyy');
  String formatted = formatter.format(now);
  return formatted;
}

///日期格式化，2022-06-11 20:06:43 -> 06-11
String dateMonthAndDay2(String dateStr) {
  var arr = dateStr.split("-");
  var dateStr2 = "";
  for (var i = 0; i < arr.length; i++) {
    var item = arr[i];
    if(i == arr.length - 1) {
      if (item.length == 1) {
        dateStr2 += '0' + item;
      } else {
        dateStr2 += item;
      }
    } else {
      if (item.length == 1) {
        dateStr2 += '0' + item + "-";
      } else {
        dateStr2 += item + "-";
      }
    }
  }
  DateTime now = DateTime.parse(dateStr2);
  DateFormat formatter = DateFormat('MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

///日期格式化，2022-06-11 20:06:43 -> 06-11
String dateMonthAndDay(String dateStr) {
  DateTime now = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

///日期格式化，2022-06-11
String dateYearMothAndDay(String dateStr) {
  if (isEmpty(dateStr)) return "";
  DateTime now = DateTime.parse(dateStr);
  return DateFormat("yyyy-MM-dd").format(now);
}

///日期格式化，2022-06-11 hh:mm
String dateYearMothAndDayAndMinutes(String dateStr) {
  if (isEmpty(dateStr)) return "";
  DateTime now = DateTime.parse(dateStr);
  return DateFormat("yyyy-MM-dd HH:mm").format(now);
}

///日期格式化，2022-06-11 hh:mm:ss
String dateYearMothAndDayAndSecend(String dateStr) {
  if (isEmpty(dateStr)) return "";
  DateTime now = DateTime.parse(dateStr);
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
}

///日期格式化，2022-06-11
String currentYearMothAndDay() {
  final now = DateTime.now();
  return DateFormat("yyyy-MM-dd").format(now);
}

///format milliseconds to local string
String getFormattedTime(int milliseconds) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  final now = DateTime.now();

  final diff = Duration(
      milliseconds:
          now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch);
  if (diff.inMinutes < 1) {
    return "刚刚";
  }
  if (diff.inMinutes <= 60) {
    return "${diff.inMinutes}分钟前";
  }
  if (diff.inHours <= 24) {
    return "${diff.inHours}小时前";
  }
  if (diff.inDays <= 5) {
    return "${diff.inDays}天前";
  }
  return DateFormat("y年M月d日").format(dateTime);
}

///format milliseconds to time stamp like "06:23", which
///means 6 minute 23 seconds
String getTimeStamp(int milliseconds) {
  final int seconds = (milliseconds / 1000).truncate();
  final int minutes = (seconds / 60).truncate();

  final String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  final String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  return "$minutesStr:$secondsStr";
}
