import 'package:flutter/material.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMale = true;
  int height = 180;
  int weight = 60;
  int age = 20;
  double bmi = 0;

  void calculateBMI() {
    double h = height / 100;
    bmi = weight / (h * h);

    String comment = "";

    if (bmi < 18.5) {
      comment = "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      comment = "Healthy Weight";
    } else if (bmi >= 25 && bmi < 29.9) {
      comment = "Overweight";
    } else {
      comment = "Obese";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Your BMI Result"),
        content: Text(
          "BMI: ${bmi.toStringAsFixed(2)}\n\nStatus: $comment",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }


  Widget boxDecoration(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1D1E33),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text("BMI CALCULATOR"),
      ),

      body: Column(
        children: [
          // ---------------------- Gender Selection ----------------------
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isMale = true);
                    },
                    child: boxDecoration(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.male,
                              size: 80,
                              color: isMale ? Colors.blue : Colors.white),
                          const SizedBox(height: 10),
                          const Text("MALE"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isMale = false);
                    },
                    child: boxDecoration(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.female,
                              size: 80,
                              color: isMale ? Colors.white : Colors.pink),
                          const SizedBox(height: 10),
                          const Text("FEMALE"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ---------------------- Height Slider ----------------------
          Expanded(
            child: boxDecoration(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("HEIGHT", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(
                    "$height cm",
                    style: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: height.toDouble(),
                    min: 100,
                    max: 220,
                    activeColor: Colors.pink,
                    onChanged: (value) {
                      setState(() => height = value.toInt());
                    },
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ---------------------- Weight & Age ----------------------
          Expanded(
            child: Row(
              children: [
                // Weight Box
                Expanded(
                  child: boxDecoration(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("WEIGHT"),
                        Text("$weight",
                            style: const TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "weight-",
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  if (weight > 1) weight--;
                                });
                              },
                              child: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 10),
                            FloatingActionButton(
                              heroTag: "weight+",
                              mini: true,
                              onPressed: () {
                                setState(() => weight++);
                              },
                              child: const Icon(Icons.add),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Age Box
                Expanded(
                  child: boxDecoration(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("AGE"),
                        Text("$age",
                            style: const TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "age-",
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  if (age > 1) age--;
                                });
                              },
                              child: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 10),
                            FloatingActionButton(
                              heroTag: "age+",
                              mini: true,
                              onPressed: () => setState(() => age++),
                              child: const Icon(Icons.add),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------------- Calculate Button ----------------------
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: calculateBMI,
              child:
              const Text("CALCULATE", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
