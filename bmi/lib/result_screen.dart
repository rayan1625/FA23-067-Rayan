import 'package:flutter/material.dart';
import 'ConstantFile.dart';
import 'bmi_screen.dart'; // wapas jane ke liye

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

  // Yeh function BMI calculate karega (hum BMIScreen se call karenge)
  static ResultScreen calculateBMI({
    required int weight,
    required int height,
    required int age,
    required Gender gender,
  }) {
    double heightInMeter = height / 100;
    double bmiValue = weight / (heightInMeter * heightInMeter);

    String result;
    Color color;
    String comment;

    if (bmiValue < 18.5) {
      result = "Underweight";
      color = Colors.orange;
      comment = "BMI is Low! You should eat more healthy food & gain weight.";
    } else if (bmiValue >= 18.5 && bmiValue <= 24.9) {
      result = "Normal";
      color = Colors.green;
      comment = "Perfect! Your BMI is in healthy range. Keep it up!";
    } else if (bmiValue >= 25 && bmiValue <= 29.9) {
      result = "Overweight";
      color = Colors.orange;
      comment = "BMI is High! Start exercising and control diet.";
    } else {
      result = "Obese";
      color = Colors.red;
      comment = "Warning! BMI is very high. Consult doctor & start workout immediately.";
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
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text(
          "Your Result",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Result Text (Normal / Overweight etc.)
            Text(
              resultText,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),

            const SizedBox(height: 40),

            // Big BMI Number
            Text(
              bmi.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            // Feedback Comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                feedback,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(),

            // ReCalculate Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // wapas BMIScreen pe
              },
              child: Container(
                height: 70,
                width: double.infinity,
                color: Colors.redAccent,
                child: const Center(
                  child: Text(
                    "ReCalculate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}