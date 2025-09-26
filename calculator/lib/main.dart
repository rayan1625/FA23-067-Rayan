import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  final List<String> buttonList = [
    'C', 'DEL', 'x²', 'x³',
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
  ];

  void buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        input = '';
        result = '';
      } else if (text == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (text == '=') {
        calculateResult();
      } else if (text == 'x²') {
        if (input.isNotEmpty) {
          calculateResult();
          double num = double.tryParse(result) ?? 0;
          result = (num * num).toString();
        }
      } else if (text == 'x³') {
        if (input.isNotEmpty) {
          calculateResult();
          double num = double.tryParse(result) ?? 0;
          result = (num * num * num).toString();
        }
      } else {
        input += text;
      }
    });
  }

  void calculateResult() {
    try {
      String finalInput = input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = eval.toString();
    } catch (e) {
      result = "Error";
    }
  }

  Color _getButtonColor(String text) {
    if (text == 'C' || text == 'DEL') {
      return Colors.red;
    } else if (text == '=') {
      return Colors.green;
    } else if (text == '÷' || text == '×' || text == '-' || text == '+' || text == 'x²' || text == 'x³') {
      return Colors.blueGrey;
    } else {
      return Colors.grey[850]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // ✅ Thoda kam padding
          child: Column(
            children: [
              // Display
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        input,
                        style: const TextStyle(fontSize: 20, color: Colors.white70), // ✅ Chhota text
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result,
                        style: const TextStyle(
                          fontSize: 26, // ✅ Result thoda chhota
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Buttons
              Expanded(
                flex: 5,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: buttonList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: constraints.maxWidth / (constraints.maxHeight / 1.6), // ✅ Buttons compact
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final btnText = buttonList[index];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(btnText),
                            padding: const EdgeInsets.all(8), // ✅ Buttons ke andar kam space
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => buttonPressed(btnText),
                          child: Text(
                            btnText,
                            style: const TextStyle(fontSize: 18, color: Colors.white), // ✅ Smaller text
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
