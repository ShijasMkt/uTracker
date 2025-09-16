import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utracker/core/auth/auth_gate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utracker/core/constrants/app_colors.dart';
import 'package:utracker/core/constrants/app_fonts.dart';
import 'package:utracker/core/constrants/app_texts.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_model.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_status_model.dart';
import 'package:utracker/features/habit_tracker/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //hive initialization
  await Hive.initFlutter();
  //hive adapter registering
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitStatusAdapter());
  //opening hive boxes
  await Hive.openBox('settingsBox');
  await Hive.openBox<User>('Users');
  await Hive.openBox<Habit>('Habits');
  await Hive.openBox<HabitStatus>('HabitStatus');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'uTracker',
      theme: ThemeData(
        fontFamily: AppFonts.poppins,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainGreenColor),
        textTheme: myTextTheme,
      ),
      home: AuthGate(),
    );
  }
}
