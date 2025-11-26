import 'package:flutter/material.dart';
import 'bmi_screen.dart';
import 'ConstantFile.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BMI Calculator",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kScaffoldBackground,
      ),
      home: const BMIScreen(),
    );
  }
}
