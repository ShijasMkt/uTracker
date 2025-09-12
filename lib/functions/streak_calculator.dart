import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:utracker/models/habit_model.dart';
import 'package:utracker/models/habit_status_model.dart';

int calculateStreak(Habit habit, Box<HabitStatus> statusBox) {
  int streak = 0;
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);

  for (int i = 1; ; i++) {
    DateTime day = today.subtract(Duration(days: i - 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(day);

    final statusKey = '${habit.key}-$formattedDate';
    final status = statusBox.get(statusKey);
    if (status != null && status.isCompleted == true) {
      streak++;   
    } else {
      break;
    }
  }
  return streak;
}
