import 'package:flutter/material.dart';

/// ----------------------------------------------------------
/// 🔵 REUSABLE BOX WITH onPressed CALLBACK
/// ----------------------------------------------------------
class RepeatContainerCode extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const RepeatContainerCode({
    super.key,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // callback here
      child: Container(
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF1E1E2F),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
