import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'validation_form.dart';

class PinForm extends StatefulWidget {
  @override
  _PinFormState createState() => _PinFormState();
}

class _PinFormState extends State<PinForm> {
  bool canContinue = false;

  int pin = -666;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 128,
                child: LinearProgressIndicator(
                  value: 0.66,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Set a Pin Code',
                style: TextStyle(fontSize: 32.0),
              ),
              SizedBox(
                height: 16.0,
              ),
              PinCodeTextField(
                length: 6,
                textInputType: TextInputType.number,
                obsecureText: false,
                animationType: AnimationType.fade,
                textStyle: TextStyle(color: Colors.white, fontSize: 32.0),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 80,
                  fieldWidth: 50,
                  activeFillColor: Colors.grey.withAlpha(100),
                  inactiveFillColor: Colors.grey.withAlpha(35),
                  selectedFillColor: Colors.grey.withAlpha(55),
                  activeColor: Colors.grey.withAlpha(100),
                  inactiveColor: Colors.grey.withAlpha(35),
                  selectedColor: Colors.grey.withAlpha(55),
                  disabledColor: Colors.grey,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onCompleted: (value) {
                  setState(() {
                    canContinue = true;
                  });
                },
                onChanged: (value) {
                  pin = int.parse(value);

                  if (value != null && value.length < 6) {
                    setState(() {
                      canContinue = false;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: canContinue,
        child: FloatingActionButton(
          child: Icon(MaterialCommunityIcons.arrow_right),
          onPressed: () {
            save();
          },
        ),
      ),
    );
  }

  Future<void> save() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'pin', value: pin.toString());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ValidationForm(),
      ),
    );
  }
}
