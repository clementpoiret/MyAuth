import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myauth/screens/passwords_screen.dart';
import 'package:myauth/utils/passwords/generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDialog extends StatefulWidget {
  final int id;

  const EditDialog({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class ValidationForm extends StatefulWidget {
  @override
  _ValidationFormState createState() => _ValidationFormState();
}

class _EditDialogState extends State<EditDialog> {
  bool isEnabled = true;
  int newId = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('You already have an ID?'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('If you previously used the app, you can specify it here.'),
          TextFormField(
            initialValue: widget.id.toString(),
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Your ID'),
            onChanged: (value) {
              if (value.length != 6) {
                setState(() {
                  isEnabled = false;
                });
              } else {
                setState(() {
                  isEnabled = true;
                });
              }
              newId = int.parse(value);
            },
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            RaisedButton(
              onPressed: isEnabled
                  ? () {
                      Navigator.of(context).pop(newId);
                    }
                  : null,
              child: Text('EDIT'),
            )
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    newId = widget.id;
  }
}

class _ValidationFormState extends State<ValidationForm> {
  bool canContinue = false;

  int randomId = 0;
  String uuid = '';

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
                  value: 1.0,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                'Validation',
                style: TextStyle(fontSize: 32.0),
              ),
              Text(
                'Please verify your final identity. If it\'s not correct, please restart the configuration with your correct identity.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'YOUR RANDOM ID',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            randomId.toString(),
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            width: 32.0,
                            child: IconButton(
                                icon: Icon(
                                  MaterialIcons.edit,
                                  size: 16.0,
                                ),
                                onPressed: () {
                                  showEditDialog(randomId);
                                }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'YOUR UUID',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        uuid,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 64.0,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: canContinue,
        child: FloatingActionButton(
          child: Icon(MaterialCommunityIcons.check),
          onPressed: () {
            save();
          },
        ),
      ),
    );
  }

  Future<void> generateRandomId() async {
    List<int> numbers = [];
    final random = Random.secure();

    for (int i = 0; i < 6; i++) {
      int digit = random.nextInt(9);
      if (i == 0 && digit == 0) {
        digit++;
      }
      if (i == 5 && digit == 0) {
        digit++;
      }
      numbers.add(digit);
    }

    final storage = FlutterSecureStorage();
    await storage.write(key: 'randomId', value: numbers.join());

    setState(() {
      randomId = int.parse(numbers.join());
    });
  }

  Future<void> generateUuid() async {
    String res = await getUuid();

    setState(() {
      uuid = res;
    });
  }

  @override
  void initState() {
    super.initState();
    generateRandomId();
    generateUuid();

    setState(() {
      canContinue = true;
    });
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('configured', true);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PasswordsScreen(),
      ),
      (_) => false,
    );
  }

  showEditDialog(int id) async {
    int newId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditDialog(id: id);
        });

    if (newId != null) {
      final storage = FlutterSecureStorage();
      await storage.write(key: 'randomId', value: newId.toString());

      setState(() {
        randomId = newId;
      });

      generateUuid();
    }
  }
}
