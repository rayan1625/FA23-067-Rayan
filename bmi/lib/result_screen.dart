import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'ConstantFile.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final String resultText;
  final Color resultColor;
  final String feedback;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.resultText,
    required this.resultColor,
    required this.feedback,
  });

  // Sirf weight aur height se BMI calculate karenge (age ki zaroorat nahi)
  static ResultScreen calculateBMI({
    required int weight,
    required int height,
  }) {
    double heightInMeter = height / 100;
    double bmiValue = weight / (heightInMeter * heightInMeter);

    String result;
    Color color;
    String comment;

    if (bmiValue < 18.5) {
      result = "Underweight";
      color = Colors.orange;
      comment = "BMI is Low! Eat more healthy food & gain some weight.";
    } else if (bmiValue <= 24.9) {
      result = "Normal";
      color = Colors.green;
      comment = "Perfect! Your BMI is in healthy range. Great job!";
    } else if (bmiValue <= 29.9) {
      result = "Overweight";
      color = Colors.orange;
      comment = "BMI is High! Start exercise and control your diet.";
    } else {
      result = "Obese";
      color = Colors.red;
      comment = "Health Risk! Consult a doctor & start workout immediately.";
    }

    return ResultScreen(
      bmi: bmiValue,
      resultText: result,
      resultColor: color,
      feedback: comment,
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
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Your Result",
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kActiveColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 16,
                          animation: true,
                          percent: bmi / 40 > 1.0 ? 1.0 : bmi / 40,
                          center: Text(
                            bmi.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          progressColor: resultColor,
                          backgroundColor: Colors.white24,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        Text(
                          resultText,
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: resultColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            feedback,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, color: Colors.white70, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ReCalculate Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.redAccent, Colors.pinkAccent]),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        "RE-CALCULATE",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}