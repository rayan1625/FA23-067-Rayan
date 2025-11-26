import 'package:flutter/material.dart';
import 'ConstantFile.dart';

/// ----------------------------------------------------------
/// 🔵 REUSABLE BOX WITH onPressed CALLBACK + optional child
/// ----------------------------------------------------------
class RepeatContainerCode extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final Widget? child;   // <— TEXT OR ANY CONTENT

  const RepeatContainerCode({
    super.key,
    this.color,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? kDeActiveColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

