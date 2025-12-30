import 'package:flutter/material.dart';
import 'bmi_screen.dart';
import 'ConstantFile.dart';

void main() {
  runApp(BMIApp());
}

class BMIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackground,
        primaryColor: kPrimary,
      ),
      home: BMIScreen(),
    );
  }
}