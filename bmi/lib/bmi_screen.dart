import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // ----------------------------------------------------------
  // 🔵 ACTIVE / DEACTIVE COLOR LOGIC
  // ----------------------------------------------------------
  Color activeColor = const Color(0xFF3D3D5C);
  Color deActiveColor = const Color(0xFF1E1E2F);

  bool isMale = true; // Default male selected

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

            // ----------------------------------------
            // ROW 1 → MALE + FEMALE BOXES
            // ----------------------------------------
            Expanded(
              child: Row(
                children: [

                  // ------------------ MALE BOX ------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: RepeatTextAndIconWidget(
                        title: "MALE",
                        icon: Icons.male,
                        boxColor: isMale ? activeColor : deActiveColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // ----------------- FEMALE BOX ------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: RepeatTextAndIconWidget(
                        title: "FEMALE",
                        icon: Icons.female,
                        boxColor: isMale ? deActiveColor : activeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------
            // ROW 2 → NORMAL EMPTY BOX
            // ----------------------------------------
            const Expanded(
              child: RepeatContainerCode(),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------
            // ROW 3 → NORMAL EMPTY BOXES
            // ----------------------------------------
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
