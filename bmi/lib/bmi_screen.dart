import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';
import 'ConstantFile.dart';

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender selectedGender = Gender.male;

  // ------------------------------
  // 🔵 COMMON FUNCTION
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
        backgroundColor: kAppBarColor,
        title: const Text("BMI CALCULATOR"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            // MALE & FEMALE
            Expanded(
              child: Row(
                children: [

                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "MALE",
                      icon: Icons.male,
                      boxColor: selectedGender == Gender.male
                          ? kActiveColor
                          : kDeActiveColor,
                      onPressed: () => selectGender(Gender.male),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "FEMALE",
                      icon: Icons.female,
                      boxColor: selectedGender == Gender.female
                          ? kActiveColor
                          : kDeActiveColor,
                      onPressed: () => selectGender(Gender.female),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------
            // ROW 2 → HEIGHT TEXT
            // ------------------------------
            Expanded(
              child: RepeatContainerCode(
                child: Center(
                  child: Text("HEIGHT", style: kHeightTextStyle),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LAST ROW (unchanged)
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
