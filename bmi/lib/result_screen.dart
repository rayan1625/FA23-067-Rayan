// lib/result_screen.dart  ← Pura file replace kar do isse

import 'package:flutter/material.dart';
import 'ConstantFile.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final String result;
  final String advice;
  final Color color;

  const ResultScreen({
    required this.bmi,
    required this.result,
    required this.advice,
    required this.color,
  });

  static ResultScreen calculate({
    required int weight,
    required int height,
  }) {
    double bmiValue = weight / ((height / 100) * (height / 100));
    String resultText;
    String interpretation;
    Color resultColor;

    if (bmiValue < 18.5) {
      resultText = "Underweight";
      interpretation = "You need to eat more healthy food!";
      resultColor = Colors.blue;
    } else if (bmiValue < 25) {
      resultText = "Normal";
      interpretation = "Perfect! You're in great shape!";
      resultColor = Colors.green;
    } else if (bmiValue < 30) {
      resultText = "Overweight";
      interpretation = "Time to hit the gym buddy!";
      resultColor = Colors.orange;
    } else {
      resultText = "Obese";
      interpretation = "Please consult a doctor & start workout.";
      resultColor = Colors.red;
    }

    return ResultScreen(
      bmi: bmiValue,
      result: resultText,
      advice: interpretation,
      color: resultColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D1E33), Color(0xFF111328)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text("YOUR RESULT", style: kResultTitleStyle),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 30)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(result,
                            style: TextStyle(
                                fontSize: 30,
                                color: color,
                                fontWeight: FontWeight.bold)),
                        Text(bmi.toStringAsFixed(1), style: kBMIResultTextStyle),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(advice,
                              style: kResultBodyStyle, textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.pink, Colors.red]),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                        child: Text("RE-CALCULATE", style: kLargeButtonTextStyle)),
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