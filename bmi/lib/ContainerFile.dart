import 'package:flutter/material.dart';
import 'ConstantFile.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  const ReusableCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: child,
    );
  }
}