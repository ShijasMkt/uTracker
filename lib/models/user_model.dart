import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String uName;

  @HiveField(1)
  String password;

  User({required this.uName, required this.password});
}
