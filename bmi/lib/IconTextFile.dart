import 'package:flutter/material.dart';

class RepeatTextAndIconWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color boxColor;

  const RepeatTextAndIconWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
