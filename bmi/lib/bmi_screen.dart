import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';

// ----------------------------------------------------------
// 🔵 ENUM FOR GENDER
// ----------------------------------------------------------
enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // ACTIVE / DEACTIVE COLORS
  final Color activeColor = const Color(0xFF3D3D5C);
  final Color deActiveColor = const Color(0xFF1E1E2F);

  // DEFAULT SELECTED GENDER
  Gender selectedGender = Gender.male;

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

            // ----------------------------------------------------
            // ROW 1 → MALE / FEMALE
            // ----------------------------------------------------
            Expanded(
              child: Row(
                children: [

                  // -------------------- MALE --------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      child: RepeatTextAndIconWidget(
                        title: "MALE",
                        icon: Icons.male,
                        boxColor: selectedGender == Gender.male
                            ? activeColor
                            : deActiveColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // ------------------- FEMALE -------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      child: RepeatTextAndIconWidget(
                        title: "FEMALE",
                        icon: Icons.female,
                        boxColor: selectedGender == Gender.female
                            ? activeColor
                            : deActiveColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------------------
            // ROW 2 → EMPTY BOX
            // ----------------------------------------------------
            const Expanded(
              child: RepeatContainerCode(),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------------------
            // ROW 3 → TWO EMPTY BOXES
            // ----------------------------------------------------
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
