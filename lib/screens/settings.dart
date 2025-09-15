import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/models/user_model.dart';
import 'package:utracker/providers/auth_provider.dart';
import 'package:utracker/screens/onboarding_screen.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  late Box settingsBox;
  late Box userBox;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settingsBox');
    userBox = Hive.box<User>('Users');
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> userNameFormkey = GlobalKey<FormState>();
    final TextEditingController uNameController = TextEditingController();

    final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
    final TextEditingController currentPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final currentUser = settingsBox.get('currentUser');
    final user = userBox.get(currentUser);

    void deleteAccount() {
      user.delete();
      settingsBox.put('isLoggedIn', false);
      ref.read(authProvider.notifier).logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }

    void showDeleteDialog() {
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

    void showPasswordDialog() {
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

    void updateUserName() {
      final userBox = Hive.box<User>('Users');
      final userName = uNameController.text.trim();

      if (userName == user.uName) {
        setState(() {
          isEditing = false;
        });
        return;
      }

      final existingUser = userBox.values
          .cast<User>()
          .where((user) => user.uName == userName)
          .toList();

      if (existingUser.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Username already exists!")));
        return;
      } else {
        user.uName = userName;
        user.save();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Username Updated"),
          ),
        );
        setState(() {
          isEditing = false;
        });
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Settings", style: TextTheme.of(context).titleLarge),
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: userNameFormkey,
                child: TextFormField(
                  controller: uNameController,
                  readOnly: isEditing ? false : true,
                  decoration: InputDecoration(
                    label: Text("Username"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hint: isEditing ? null : Text(user.uName),
                    suffixIcon: IconButton(
                      icon: Icon(isEditing ? Icons.cancel : Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a username";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              !isEditing
                  ? Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showPasswordDialog();
                          },
                          child: Text("change password"),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {
                            showDeleteDialog();
                          },
                          child: Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  : Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (userNameFormkey.currentState!.validate()) {
                              updateUserName();
                            }
                          },
                          child: Text("Save"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
