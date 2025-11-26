import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';
import 'ConstantFile.dart';
import 'result_screen.dart'; // Yeh import zaroori hai

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender selectedGender = Gender.male;
  int height = 180;
  int weight = 60;
  int age = 20;

  void selectGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text("BMI CALCULATOR"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // ==================== ROW 1: MALE / FEMALE ====================
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: RepeatTextAndIconWidget(
                            title: "MALE",
                            icon: Icons.male,
                            boxColor: selectedGender == Gender.male
                                ? kActiveColor
                                : kDeActiveColor,
                            onPressed: () => selectGender(Gender.male),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: RepeatTextAndIconWidget(
                            title: "FEMALE",
                            icon: Icons.female,
                            boxColor: selectedGender == Gender.female
                                ? kActiveColor
                                : kDeActiveColor,
                            onPressed: () => selectGender(Gender.female),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ==================== ROW 2: HEIGHT SLIDER ====================
                  Expanded(
                    child: RepeatContainerCode(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("HEIGHT", style: kHeightTextStyle),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                height.toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                " cm",
                                style: TextStyle(fontSize: 20, color: Colors.white70),
                              ),
                            ],
                          ),
                          Slider(
                            min: 120,
                            max: 220,
                            activeColor: Colors.pinkAccent,
                            inactiveColor: Colors.grey,
                            value: height.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                height = value.round();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ==================== ROW 3: WEIGHT + AGE ====================
                  Expanded(
                    child: Row(
                      children: [
                        // WEIGHT
                        Expanded(
                          child: RepeatContainerCode(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("WEIGHT", style: TextStyle(fontSize: 18, color: Colors.white70)),
                                const SizedBox(height: 8),
                                Text("$weight", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[800],
                                      child: IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            if (weight > 20) weight--;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[800],
                                      child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            weight++;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // AGE
                        Expanded(
                          child: RepeatContainerCode(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("AGE", style: TextStyle(fontSize: 18, color: Colors.white70)),
                                const SizedBox(height: 8),
                                Text("$age", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[800],
                                      child: IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            if (age > 1) age--;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[800],
                                      child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            age++;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==================== CALCULATE BMI BUTTON ====================
          GestureDetector(
            onTap: () {
              // Yahan BMI calculate hota hai aur ResultScreen khulta hai
              final result = ResultScreen.calculateBMI(
                weight: weight,
                height: height,
                age: age,
                gender: selectedGender,
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => result),
              );
            },
            child: Container(
              height: 80,
              width: double.infinity,
              color: Colors.redAccent,
              child: const Center(
                child: Text(
                  "CALCULATE BMI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}