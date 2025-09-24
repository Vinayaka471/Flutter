import 'package:flutter/material.dart'; // material it gives access to widgets like buttons, text, scaffold

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const CalculatorHome(),
    );
  }
}

// ==============================Calculator Home Screen================================================

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String display = "0";
  String operand = " ";
  double num1 = 0;
  double num2 = 0;

  void buttonPressed(String text) {
    setState(() {
      if (text == "C") {
        display = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (text == "+" || text == "-" || text == "*" || text == "/") {
        num1 = double.parse(display);
        operand = text;
        display = "0";
      } else if (text == "=") {
        num2 = double.parse(display);
        if (operand == "+") {
          display = (num1 + num2).toString();
        } else if (operand == "-") {
          display = (num1 - num2).toString();
        } else if (operand == "*") {
          display = (num1 * num2).toString();
        } else if (operand == "/") {
          display = num2 != 0 ? (num1 / num2).toString() : "Error";
        }
        operand = "";
      } else {
        if (display == "0") {
          display = text;
        } else {
          display += text;
        }
      }
    });
  }

  Widget buildButton(String text, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: color,
        ),
        onPressed: () => buttonPressed(text),
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              buildButton("7", Colors.grey),
              buildButton("8", Colors.grey),
              buildButton("9", Colors.grey),
              buildButton("/", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("4", Colors.grey),
              buildButton("5", Colors.grey),
              buildButton("6", Colors.grey),
              buildButton("*", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("1", Colors.grey),
              buildButton("2", Colors.grey),
              buildButton("3", Colors.grey),
              buildButton("-", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("C", Colors.grey),
              buildButton("0", Colors.grey),
              buildButton("=", Colors.grey),
              buildButton("+", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
