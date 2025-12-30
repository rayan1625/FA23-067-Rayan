// lib/IconTextFile.dart

import 'package:flutter/material.dart';
import 'ConstantFile.dart';

class GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;  // ← Yeh add kiya hai!

  const GenderCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // ← Yahan tap ho raha hai
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.08 : 1.0),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [kPrimary, kPrimary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : kInactiveCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: kPrimary.withOpacity(0.6),
              blurRadius: 25,
              spreadRadius: 5,
            )
          ]
              : [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 8),
              blurRadius: 15,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 90, color: Colors.white),
            SizedBox(height: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}