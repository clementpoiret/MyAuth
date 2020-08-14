import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pin_form.dart';

class IdentityForm extends StatefulWidget {
  @override
  _IdentityFormState createState() => _IdentityFormState();
}

class _IdentityFormState extends State<IdentityForm> {
  String name = '';
  String masterKey = '';
  double length = 16.0;
  bool useLowercases = true;
  bool useUppercases = true;
  bool useDigits = true;
  bool useSymbols = true;

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
                  value: 0.33,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                'Your Identity',
                style: TextStyle(fontSize: 32.0),
              ),
              Text(
                'Be careful. Incorrect information = Wrong passwords',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: 'Name (e.g.: "John")'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Master Key (required for encryption)'),
                    onChanged: (value) {
                      setState(() {
                        masterKey = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'LENGTH: ${length.round()}',
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 0.0),
                  child: Slider(
                    value: length,
                    min: 4,
                    max: 64,
                    divisions: 60,
                    label: length.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        length = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'CHARACTERS',
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: useLowercases,
                          title: Text('Include lowercases'),
                          subtitle: Text('e.g.: abcd'),
                          onChanged: (value) {
                            setState(() {
                              useLowercases = !useLowercases;
                            });
                          },
                        ),
                        SwitchListTile(
                          value: useUppercases,
                          title: Text('Include uppercases'),
                          subtitle: Text('e.g.: ABCD'),
                          onChanged: (value) {
                            setState(() {
                              useUppercases = !useUppercases;
                            });
                          },
                        ),
                        SwitchListTile(
                          value: useDigits,
                          title: Text('Include digits'),
                          subtitle: Text('e.g.: 123'),
                          onChanged: (value) {
                            setState(() {
                              useDigits = !useDigits;
                            });
                          },
                        ),
                        SwitchListTile(
                          value: useSymbols,
                          title: Text('Include symbols'),
                          subtitle: Text('e.g.: @:['),
                          onChanged: (value) {
                            setState(() {
                              useSymbols = !useSymbols;
                            });
                          },
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 64.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: (name.length != 0 && masterKey.length != 0) ? true : false,
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
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'masterKey', value: masterKey);
    await storage.write(key: 'length', value: length.toString());
    await storage.write(key: 'useLowercases', value: useLowercases.toString());
    await storage.write(key: 'useUppercases', value: useUppercases.toString());
    await storage.write(key: 'useDigits', value: useDigits.toString());
    await storage.write(key: 'useSymbols', value: useSymbols.toString());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PinForm(),
      ),
    );
  }
}
