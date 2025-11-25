import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';
class BMIScreen extends StatelessWidget {
  const BMIScreen({super.key});

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
                children: const [
                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "MALE",
                      icon: Icons.male,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: RepeatTextAndIconWidget(
                      title: "FEMALE",
                      icon: Icons.female,
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



