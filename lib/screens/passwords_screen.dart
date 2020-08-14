import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myauth/utils/passwords/generator.dart';
import 'package:clipboard/clipboard.dart';

class PasswordsScreen extends StatefulWidget {
  PasswordsScreen({Key key}) : super(key: key);

  @override
  _PasswordsScreenState createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _notifyCopied() {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Copied! :)',
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String website = '';
  String login = '';
  String pwd = '';
  String uuid = 'uuid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('MyAuth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Retrieve Your Password',
                style: TextStyle(fontSize: 32),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'GENERATE A PASSWORD',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Website (e.g.: facebook.com)'),
                        onChanged: (value) {
                          setState(() {
                            website = value;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Login (e.g.: john.doe@test.com)'),
                        onChanged: (value) {
                          setState(() {
                            login = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0.0),
                child: Text(
                  'GENERATED PASSWORD',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FlutterClipboard.copy(pwd).then(
                    (value) => print('copied'),
                  );
                  _notifyCopied();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: Text(
                      pwd.isEmpty ? 'Nothing generated yet :(' : pwd,
                      style: TextStyle(fontSize: 28.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
                child: Text(
                  'UUID: $uuid',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: (website.length != 0 && login.length != 0) ? true : false,
        child: FloatingActionButton(
          child: Icon(FontAwesome.gears),
          onPressed: () {
            FocusScope.of(context).unfocus();
            _generate();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUuid();
    // _check();
  }

  void _generate() async {
    String res = await getPassword(website: website, login: login);

    setState(() {
      pwd = res;
    });
  }

  _getUuid() async {
    String res = await getUuid();

    setState(() {
      uuid = res;
    });
  }
}
