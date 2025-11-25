import 'package:flutter/material.dart';
/// ----------------------------------------------------------
/// 🔵 1. REUSABLE EMPTY BOX CONTAINER
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
