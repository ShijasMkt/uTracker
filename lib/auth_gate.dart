import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utracker/providers/auth_provider.dart';
import 'package:utracker/screens/home_screen.dart';
import 'package:utracker/screens/onboarding_screen.dart';

class AuthGate extends ConsumerWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    return isLoggedIn? HomeScreen(): OnboardingScreen();
  }
}
