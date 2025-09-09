import 'package:flutter/material.dart';
import 'package:utracker/auth_gate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uTracker',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0A5938)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16,color: Colors.black),
          titleLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 14,color: Colors.grey),
          labelLarge: TextStyle(fontSize: 14,color: Color(0xff0A5938))
        )
      ),
      home: AuthGate(),
    );
  }
}

