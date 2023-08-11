import 'package:chnsmile_flutter/model/clock_in_times_model.dart';

class ClockInUtils {
  static String timesStr = "";
  static List<ClockInTimesModel> selecters = [];

  static void cleanTimes() {
    selecters.clear();
  }

  static void addTimes(ClockInTimesModel time) {
    if (!selecters.contains(time)) {
      selecters.add(time);
    }
  }

  static void removeTimes(ClockInTimesModel time) {
    if (!selecters.contains(time)) {
      selecters.remove(time);
    }
  }

  static List<ClockInTimesModel> getAllTimes() {
    return selecters;
  }
}
