import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/models/user_model.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
    final currentUser = settingsBox.get('currentUser');
    final user = userBox.get(currentUser);
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
              TextField(
                readOnly: isEditing ? false : true,
                decoration: InputDecoration(
                  label: Text("Username"),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hint: Text(user.uName),
                  suffixIcon: IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("change password"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.red),
                    ),
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
