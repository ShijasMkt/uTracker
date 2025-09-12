import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utracker/auth_gate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utracker/models/habit_model.dart';
import 'package:utracker/models/habit_status_model.dart';
import 'package:utracker/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitStatusAdapter());
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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0A5938)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 14, color: Colors.grey),
          labelLarge: TextStyle(fontSize: 14, color: Color(0xff0A5938)),
        ),
      ),
      home: AuthGate(),
    );
  }
}
