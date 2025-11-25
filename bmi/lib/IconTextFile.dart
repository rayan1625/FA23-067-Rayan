import 'package:flutter/material.dart';
/// ----------------------------------------------------------
/// 🔵 2. TEXT + ICON BOX FOR MALE/FEMALE
/// ----------------------------------------------------------
class RepeatTextAndIconWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const RepeatTextAndIconWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2F),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
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