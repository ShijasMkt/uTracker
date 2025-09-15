import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_model.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_status_model.dart';
import 'package:utracker/features/habit_tracker/presentation/functions/date_only_format.dart';

int calculateStreak(Habit habit, Box<HabitStatus> statusBox) {
  int streak = 0;
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);
  String todayDate = dateOnlyFormatter(today);
  final todayKey = '${habit.key}-$todayDate';
  final todayStatus = statusBox.get(todayKey);
  if (todayStatus != null && todayStatus.isCompleted == true) {
    streak = streak + 1;
  }
  for (int i = 1; ; i++) {
    DateTime day = today.subtract(Duration(days: i));
    String formattedDate = dateOnlyFormatter(day);

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
