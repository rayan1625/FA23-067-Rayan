import 'package:flutter/material.dart';

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

            // ROW 1 → 2 BOXES
            Expanded(
              child: Row(
                children: const [
                  Expanded(child: RepeatContainerCode()),
                  SizedBox(width: 15),
                  Expanded(child: RepeatContainerCode()),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ROW 2 → 1 BOX
            const Expanded(
              child: RepeatContainerCode(),
            ),

            const SizedBox(height: 15),

            // ROW 3 → 2 BOXES
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


/// ----------------------------------------------------------
///  🔵 REUSABLE CONTAINER WIDGET
/// ----------------------------------------------------------
class RepeatContainerCode extends StatelessWidget {
  const RepeatContainerCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2F),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
