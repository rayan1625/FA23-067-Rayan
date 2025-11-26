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

  int height = 180; // HEIGHT VALUE

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

            // ------------------------------------------------------
            // ROW 2 — HEIGHT + SLIDER
            // ------------------------------------------------------
            Expanded(
              child: RepeatContainerCode(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HEIGHT", style: kHeightTextStyle),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          height.toString(),
                          style: const TextStyle(
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "cm",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    Slider(
                      min: 80,
                      max: 220,
                      value: height.toDouble(),
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.grey,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------------
            // ROW 3 — 2 EMPTY BOXES
            // ------------------------------------------------------
            Expanded(
              child: Row(
                children: const [
                  Expanded(
                    child: RepeatContainerCode(),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: RepeatContainerCode(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
