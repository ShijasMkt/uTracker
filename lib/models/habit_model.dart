import 'package:hive_flutter/hive_flutter.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  
  @HiveField(0)
  int userId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String desc;

  @HiveField(3)
  Map<String, bool> dailyStatus;

  Habit({
    required this.userId,
    required this.title,
    this.desc = '',
    Map<String, bool>? dailyStatus,
  }): dailyStatus = dailyStatus ?? {};
}
