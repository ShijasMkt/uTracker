import 'package:hive_flutter/hive_flutter.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {

  @HiveField(0)
  String title;

  @HiveField(1)
  String desc;

  @HiveField(2)
  Map<String, bool> dailyStatus;

  Habit({
    required this.title,
    this.desc = '',
    Map<String, bool>? dailyStatus,
  }): dailyStatus = dailyStatus ?? {};
}
