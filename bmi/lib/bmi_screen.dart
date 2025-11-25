import 'package:flutter/material.dart';
class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double bmi = 0;
  String resultText = "";

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height == 0 || weight == 0) {
      setState(() {
        resultText = "Please enter valid height & weight.";
        bmi = 0;
      });
      return;
    }

    height = height / 100; // cm to meters
    bmi = weight / (height * height);

    setState(() {
      if (bmi < 18.5) {
        resultText = "Underweight";
      } else if (bmi >= 18.5 && bmi < 24.9) {
        resultText = "Healthy Weight";
      } else if (bmi >= 25 && bmi < 29.9) {
        resultText = "Overweight";
      } else {
        resultText = "Obese";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Height (cm)",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (kg)",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: calculateBMI,
              child: const Text(
                "Calculate BMI",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              bmi == 0 ? "" : "Your BMI: ${bmi.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              resultText,
              style: TextStyle(
                fontSize: 20,
                color: resultText == "Healthy Weight"
                    ? Colors.greenAccent
                    : Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
