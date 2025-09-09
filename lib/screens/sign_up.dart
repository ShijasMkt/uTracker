import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixText: "Name:  ",
                prefixStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Color(0xffd5d5d5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xffd5d5d5))
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xffd5d5d5))
                )
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                prefixText: "Age:  ",
                prefixStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Color(0xffd5d5d5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xffd5d5d5))
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xffd5d5d5))
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
