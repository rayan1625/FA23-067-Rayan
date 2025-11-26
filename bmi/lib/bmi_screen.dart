import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender selectedGender = Gender.male;

  final Color activeColor = const Color(0xFF3D3D5C);
  final Color deActiveColor = const Color(0xFF1E1E2F);

  // ------------------------------
  // 🔵 COMMON FUNCTION FOR MALE/FEMALE PRESS
  // ------------------------------
  void selectGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("BMI CALCULATOR"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            // ------------------------------------------------------
            // ROW 1 — MALE + FEMALE
            // ------------------------------------------------------
            Expanded(
              child: Row(
                children: [

                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "MALE",
                      icon: Icons.male,
                      boxColor: selectedGender == Gender.male
                          ? activeColor
                          : deActiveColor,
                      onPressed: () => selectGender(Gender.male),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "FEMALE",
                      icon: Icons.female,
                      boxColor: selectedGender == Gender.female
                          ? activeColor
                          : deActiveColor,
                      onPressed: () => selectGender(Gender.female),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Expanded(
              child: RepeatContainerCode(),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Row(
                children: const [
                  Expanded(child: RepeatContainerCode()),
                  SizedBox(width: 15),
                  Expanded(child: RepeatContainerCode()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
