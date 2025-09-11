import 'package:hive_flutter/hive_flutter.dart';
part 'habit_status_model.g.dart';

@HiveType(typeId: 2)
class HabitStatus extends HiveObject{
  @HiveField(0)
  String habitId;

  @HiveField(1)
  String date;

  @HiveField(2)
  bool isCompleted;

  HabitStatus({
    required this.habitId,
    required this.date,
    this.isCompleted=false,
  });
}