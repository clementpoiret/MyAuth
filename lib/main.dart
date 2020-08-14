import 'package:flutter/material.dart';
import 'package:myauth/screens/introduction/welcome_screen.dart';
import 'package:myauth/screens/passwords_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/constants.dart';

void main() {
  runApp(MyAuth());
}

class FirstLaunch extends StatefulWidget {
  @override
  _FirstLaunchState createState() => _FirstLaunchState();
}

class MyAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAuth',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: FirstLaunch(),
    );
  }
}

class _FirstLaunchState extends State<FirstLaunch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _configured = (prefs.getBool('configured') ?? false);

    print('_configured: $_configured');

    if (_configured) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PasswordsScreen(),
        ),
      );
    } else {
      // await prefs.setBool('firstLaunch', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }
}
