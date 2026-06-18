import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'DataRepository.dart';
import 'ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/profilePage': (context) => ProfilePage(),
      },
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

  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();

    DataRepository.loadData();

    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    prefs.getString("LoginName").then((savedLogin) {
      if (savedLogin.isNotEmpty) {
        prefs.getString("Password").then((savedPassword) {
          setState(() {
            _loginController.text = savedLogin;
            _passwordController.text = savedPassword;
          });

          Future.delayed(Duration.zero, () {
            final snackBar = SnackBar(
              content: Text('Previous login name and password have been loaded'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginClicked() {
    setState(() {
      if (_passwordController.value.text == "ASDF") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Save Credentials'),
        content: const Text('Would you like to save your username and password?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
              prefs.setString("LoginName", _loginController.value.text);
              prefs.setString("Password", _passwordController.value.text);
              Navigator.pop(context);

              if (_passwordController.value.text == "ASDF") {
                DataRepository.loginName = _loginController.value.text;
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                Future.delayed(Duration(seconds: 1), () {
                  messenger.showSnackBar(
                    SnackBar(content: Text("Welcome Back ${_loginController.value.text}")),
                  );
                });

                Future.delayed(Duration(seconds: 3), () {
                  navigator.pushNamed('/profilePage');
                });
              }
            },
            child: Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
              prefs.clear();
              Navigator.pop(context);

              if (_passwordController.value.text == "ASDF") {
                DataRepository.loginName = _loginController.value.text;
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                Future.delayed(Duration(seconds: 1), () {
                  messenger.showSnackBar(
                    SnackBar(content: Text("Welcome Back ${_loginController.value.text}")),
                  );
                });

                Future.delayed(Duration(seconds: 3), () {
                  navigator.pushNamed('/profilePage');
                });
              }
            },
            child: Text('No'),
          ),
        ],
      ),
    );
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
    );
  }
}