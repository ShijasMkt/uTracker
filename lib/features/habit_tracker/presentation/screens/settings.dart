import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/features/habit_tracker/data/models/user_model.dart';
import 'package:utracker/features/habit_tracker/presentation/widgets/change_password_dialog.dart';
import 'package:utracker/features/habit_tracker/presentation/widgets/delete_account_dialog.dart';

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
    final currentUser = settingsBox.get('currentUser');
    final user = userBox.get(currentUser);


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
                            changePasswordDialog(context, user);
                          },
                          child: Text("change password"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            deleteAccountDialog(context, user, settingsBox, ref);
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
