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

            // ---------------------------------------------------
            //  ROW 1 → MALE & FEMALE BOXES
            // ---------------------------------------------------
            Expanded(
              child: Row(
                children: const [
                  Expanded(
                    child: RepeatContainerCode(
                      title: "MALE",
                      icon: Icons.male,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: RepeatContainerCode(
                      title: "FEMALE",
                      icon: Icons.female,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ROW 2 (same as before)
            const Expanded(
              child: RepeatContainerCode(),
            ),

            const SizedBox(height: 15),

            // ROW 3 (same as before)
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
/// 🔵 REUSABLE CARD WIDGET (IMPROVED)
/// ----------------------------------------------------------
class RepeatContainerCode extends StatelessWidget {
  final String? title;
  final IconData? icon;

  const RepeatContainerCode({
    super.key,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: title != null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            title!,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )
          : null,
    );
  }
}
