import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DataRepository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  final TextEditingController _firstNameController  = TextEditingController();
  final TextEditingController _lastNameController   = TextEditingController();
  final TextEditingController _phoneController      = TextEditingController();
  final TextEditingController _emailController      = TextEditingController();

  @override
  void initState() {
    super.initState();

    _firstNameController.text  = DataRepository.firstName;
    _lastNameController.text   = DataRepository.lastName;
    _phoneController.text      = DataRepository.phoneNumber;
    _emailController.text      = DataRepository.emailAddress;

    _firstNameController.addListener(() {
      DataRepository.firstName = _firstNameController.text;
      DataRepository.saveData();
    });
    _lastNameController.addListener(() {
      DataRepository.lastName = _lastNameController.text;
      DataRepository.saveData();
    });
    _phoneController.addListener(() {
      DataRepository.phoneNumber = _phoneController.text;
      DataRepository.saveData();
    });
    _emailController.addListener(() {
      DataRepository.emailAddress = _emailController.text;
      DataRepository.saveData();
    });
  }

  void _launchURL(String url) {
    final uri = Uri.parse(url);
    launchUrl(uri);
    /*
    canLaunchUrl(uri).then((itCan) {
      if (itCan) {
        launchUrl(uri);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Not Supported"),
              content: Text("This URL is not supported on this device: $url"),
              actions: [
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [

              Text(
                "Welcome Back: ${DataRepository.loginName}",
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL("tel:${_phoneController.text}");
                    },
                    child: Icon(Icons.phone),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL("sms:${_phoneController.text}");
                    },
                    child: Icon(Icons.message),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL("mailto:${_emailController.text}");
                    },
                    child: Icon(Icons.mail),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}