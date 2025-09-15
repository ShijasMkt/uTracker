import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utracker/core/auth/auth_provider.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/home_screen.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/onboarding_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    return isLoggedIn ? HomeScreen() : OnboardingScreen();
  }
}
