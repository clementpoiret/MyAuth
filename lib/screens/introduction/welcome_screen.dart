import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'id_form.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool canContinue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TypewriterAnimatedTextKit(
                totalRepeatCount: 1,
                speed: Duration(milliseconds: 50),
                pause: Duration(milliseconds: 500),
                onFinished: () {
                  setState(() {
                    canContinue = true;
                  });
                },
                text: [
                  "Hi, welcome to MyAuth!",
                  "It's an offline password manager...",
                  "... that does NOT store your passwords!",
                  "Please complete the following form carefully, it is case-sensitive!",
                ],
                textStyle: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
          ),
          SizedBox(
            height: 128.0,
            width: double.infinity,
          ),
          Visibility(
            visible: canContinue,
            child: FlatButton.icon(
              label: Text('Continue'),
              icon: Icon(MaterialCommunityIcons.arrow_right),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IdentityForm(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
