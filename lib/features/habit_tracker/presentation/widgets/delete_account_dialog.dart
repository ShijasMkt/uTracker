import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/core/auth/auth_provider.dart';
import 'package:utracker/features/habit_tracker/data/models/user_model.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/onboarding_screen.dart';

void deleteAccountDialog(BuildContext context, User user, Box settingsBox, WidgetRef ref){
  void deleteAccount() {
      user.delete();
      settingsBox.put('isLoggedIn', false);
      ref.read(authProvider.notifier).logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }
    
  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Do you really want to delete your account ?"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined),
              ),
              IconButton(
                onPressed: () {
                  deleteAccount();
                },
                icon: Icon(Icons.check),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
          );
        },
      );
}