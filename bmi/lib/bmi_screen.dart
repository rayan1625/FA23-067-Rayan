import 'package:flutter/material.dart';
import 'IconTextFile.dart';
import 'ContainerFile.dart';
import 'ConstantFile.dart';

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
      ),

      body: Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [

                  // ------------------ MALE + FEMALE ------------------
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

                  // ------------------ HEIGHT BOX ------------------
                  Expanded(
                    child: RepeatContainerCode(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("HEIGHT", style: kHeightTextStyle),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                height.toString(),
                                style: const TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "cm",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          Slider(
                            min: 80,
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

                  // ------------------ WEIGHT + AGE ------------------
                  Expanded(
                    child: Row(
                      children: [
                        // WEIGHT
                        Expanded(
                          child: RepeatContainerCode(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "WEIGHT",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "$weight",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (weight > 1) weight--;
                                        });
                                      },
                                      child: const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.remove,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          weight++;
                                        });
                                      },
                                      child: const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey,
                                        child:
                                        Icon(Icons.add, color: Colors.white),
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
                                const Text(
                                  "AGE",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "$age",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (age > 1) age--;
                                        });
                                      },
                                      child: const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.remove,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          age++;
                                        });
                                      },
                                      child: const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey,
                                        child:
                                        Icon(Icons.add, color: Colors.white),
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

          // ------------------------------------------------------
          // ONLY RED CONTAINER (no text)
          // ------------------------------------------------------
          Container(
            height: 70,
            width: double.infinity,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
