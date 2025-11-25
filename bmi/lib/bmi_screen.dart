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

            // ROW 1 → 2 CARDS
            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildCard()),
                  const SizedBox(width: 15),
                  Expanded(child: buildCard()),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ROW 2 → 1 CARD
            Expanded(
              child: buildCard(),
            ),

            const SizedBox(height: 15),

            // ROW 3 → 2 CARDS
            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildCard()),
                  const SizedBox(width: 15),
                  Expanded(child: buildCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2F),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
