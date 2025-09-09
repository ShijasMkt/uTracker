import 'package:flutter/material.dart';
import 'package:utracker/screens/sign_up.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Build Better Habits",
                style: TextTheme.of(context).titleLarge,
              ),
              Text(
                "Stay consistent, track your progress, and achieve your goals effortlessly",
                textAlign: TextAlign.center,
                style: TextTheme.of(context).titleSmall,
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(50),
                child: Image.asset('assets/images/logo.png'),
              ),
              Spacer(),
              ElevatedButton.icon(
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 40),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Color(0xff0A5938)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignUp()),
                  );
                },
                label: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.arrow_right_alt, color: Colors.white),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
