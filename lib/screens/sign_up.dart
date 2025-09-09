import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/providers/auth_provider.dart';
import 'package:utracker/screens/home_screen.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _saveUser() {
    final userBox = Hive.box('userBox');
    final settingsBox = Hive.box('settingsBox');

    userBox.put('name', _nameController.text.trim());
    userBox.put('age', _ageController.text.trim());

    settingsBox.put('isLoggedIn', true);

    ref.read(authProvider.notifier).login();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Text(
                      "Let's Personalize Your Journeys",
                      style: TextTheme.of(context).titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Tell us a bit about yourself",
                      style: TextTheme.of(context).titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    filled: true,
                    fillColor: Color(0xffd5d5d5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Color(0xffd5d5d5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Color(0xffd5d5d5)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: InputDecoration(
                    hintText: "Enter your age",
                    filled: true,
                    fillColor: Color(0xffd5d5d5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Color(0xffd5d5d5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Color(0xffd5d5d5)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid age";
                    }
                    return null;
                  },
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(double.infinity, 40),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Color(0xff0A5938)),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _saveUser();
                    } else {
                      log("error");
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
