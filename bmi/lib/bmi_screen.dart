// lib/bmi_screen.dart

import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';
import 'ConstantFile.dart';
import 'result_screen.dart';

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender? selectedGender = Gender.male; // Pehle se male selected rahega
  int height = 180;
  int weight = 60;
  int age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "BMI CALCULATOR",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ==================== GENDER SELECTION ====================
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    child: GenderCard(
                      icon: Icons.male,
                      label: "MALE",
                      isSelected: selectedGender == Gender.male,
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    child: GenderCard(
                      icon: Icons.female,
                      label: "FEMALE",
                      isSelected: selectedGender == Gender.female,
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================== HEIGHT SLIDER ====================
          Expanded(
            child: ReusableCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("HEIGHT", style: kLabelTextStyle),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(height.toString(), style: kNumberTextStyle),
                      Text(" cm", style: kLabelTextStyle.copyWith(fontSize: 20)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.pinkAccent,
                      inactiveTrackColor: Colors.grey,
                      thumbColor: Colors.pink,
                      overlayColor: Colors.pink.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 32),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      onChanged: (double value) {
                        setState(() {
                          height = value.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==================== WEIGHT & AGE ====================
          Expanded(
            child: Row(
              children: [
                // WEIGHT
                Expanded(
                  child: ReusableCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("WEIGHT", style: kLabelTextStyle),
                        Text(weight.toString(), style: kNumberTextStyle),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "weight_minus",
                              backgroundColor: kBottomColor,
                              child: const Icon(Icons.remove, size: 30),
                              onPressed: () {
                                setState(() {
                                  if (weight > 20) weight--;
                                });
                              },
                            ),
                            const SizedBox(width: 25),
                            FloatingActionButton(
                              heroTag: "weight_plus",
                              backgroundColor: kBottomColor,
                              child: const Icon(Icons.add, size: 30),
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // AGE
                Expanded(
                  child: ReusableCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("AGE", style: kLabelTextStyle),
                        Text(age.toString(), style: kNumberTextStyle),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "age_minus",
                              backgroundColor: kBottomColor,
                              child: const Icon(Icons.remove, size: 30),
                              onPressed: () {
                                setState(() {
                                  if (age > 1) age--;
                                });
                              },
                            ),
                            const SizedBox(width: 25),
                            FloatingActionButton(
                              heroTag: "age_plus",
                              backgroundColor: kBottomColor,
                              child: const Icon(Icons.add, size: 30),
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================== CALCULATE BUTTON ====================
          GestureDetector(
            onTap: () {
              final resultScreen = ResultScreen.calculate(
                weight: weight,
                height: height,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => resultScreen),
              );
            },
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.redAccent],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Center(
                child: Text(
                  "CALCULATE YOUR BMI",
                  style: kLargeButtonTextStyle.copyWith(letterSpacing: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}