import 'package:flutter/material.dart';
import 'package:utracker/screens/home_screen.dart';
import 'package:utracker/screens/onboarding_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return isLoggedIn? HomeScreen():OnboardingScreen();
  }
}