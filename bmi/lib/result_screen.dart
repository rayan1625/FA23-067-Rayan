import 'package:flutter/material.dart';
import 'ConstantFile.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text(
          "Body Data",
          style: TextStyle(fontSize: 18), // chota sa text
        ),
        automaticallyImplyLeading: false, // back button nahi dikhega (optional)
      ),
      body: Container(
        color: kScaffoldBackground, // same dark background
        width: double.infinity,
        height: double.infinity,
        // Yahan kuch bhi nahi likha — bilkul blank!
      ),
    );
  }
}