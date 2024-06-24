import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController controller = TextEditingController();
  var results = "Output shown here";

  late tfl.Interpreter interpreter;
  @override
  initState() {
    loadModel();
    super.initState();
  }

  void loadModel() async {
    interpreter = await tfl.Interpreter.fromAsset('assets/linear.tflite');
  }

  performAction() {
    int x = int.parse(controller.text);

    var input = [x];

    var output = List.filled(1 * 1, 0).reshape([1, 1]);

    interpreter.run(input, output);
    setState(() {
      results = "Result is ${output[0][0]}";
    });
    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "Model trained with 2(x)-1",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                  ),
                ),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter your number",
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    performAction();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Predict",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  results,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
