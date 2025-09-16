import 'package:flutter/material.dart';
import 'package:utracker/features/habit_tracker/data/models/user_model.dart';

void changePasswordDialog(BuildContext context, User user) {
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  void changePassword() {
    String newPassword = newPassController.text.trim();
    user.password = newPassword;
    user.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Password Updated"),
      ),
    );
    Navigator.pop(context);
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Change Password"),
        content: Form(
          key: passwordFormKey,
          child: Wrap(
            children: [
              TextFormField(
                controller: currentPassController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Current Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }

                  if (value != user.password) {
                    return "Enter correct password";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: newPassController,
                obscureText: true,
                decoration: InputDecoration(labelText: "New Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.cancel_outlined),
          ),
          IconButton(
            onPressed: () {
              if (passwordFormKey.currentState!.validate()) {
                changePassword();
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    },
  );
}
