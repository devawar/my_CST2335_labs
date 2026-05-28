import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Lab 1 variables
  var _counter = 0.0;
  var myFontSize = 30.0;
  var _myFontStyle = TextStyle(fontSize: 30.0);

  // Lab 2 variables
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setNewValue(double value) {
    setState(() {
      _counter = value;
      myFontSize = value;
      _myFontStyle = TextStyle(fontSize: myFontSize);
    });
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < 99) {
        _counter++;
      }
    });
  }

  void _loginClicked() {
    setState(() {
      if (_passwordController.value.text == "ASDF") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Lab 1 widgets
            Text('You have pushed the button this many times:', style: _myFontStyle),
            Text('$_counter', style: _myFontStyle),
            Slider(value: _counter, max: 100.0, onChanged: _setNewValue, min: 0.0),

            // Lab 2 widgets
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  labelText: "Login name",
                  hintText: "Enter your login name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _loginClicked,
                child: Text("Login"),
              ),
            ),

            Semantics(
              label: 'Image showing login result: question mark, light bulb, or stop sign',
              child: Image.asset(imageSource, width: 300, height: 300),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}