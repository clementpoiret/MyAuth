import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myauth/utils/constants.dart';

Future<String> getPassword(
    {@required String website, @required String login}) async {
  final storage = FlutterSecureStorage();
  Map<String, dynamic> data = {};

  data['id'] = int.parse(await storage.read(key: 'randomId'));
  data['name'] = await storage.read(key: 'name');
  data['masterKey'] = await storage.read(key: 'masterKey');
  data['length'] = double.parse(await storage.read(key: 'length')).round();
  data['useLowercases'] = await storage.read(key: 'useLowercases');
  data['useUppercases'] = await storage.read(key: 'useUppercases');
  data['useDigits'] = await storage.read(key: 'useDigits');
  data['useSymbols'] = await storage.read(key: 'useSymbols');

  List<String> rules = [];

  if (data['useLowercases'] == 'true') {
    rules.add('lowercases');
  }
  if (data['useUppercases'] == 'true') {
    rules.add('uppercases');
  }
  if (data['useDigits'] == 'true') {
    rules.add('digits');
  }
  if (data['useSymbols'] == 'true') {
    rules.add('symbols');
  }

  PasswordGenerator generator = PasswordGenerator(
    id: data['id'],
    name: data['name'],
    website: website,
    login: login,
    counter: 1,
    length: data['length'],
    masterKey: data['masterKey'],
    rules: rules,
  );

  return await generator.generate();
}

Future<String> getUuid() async {
  final storage = FlutterSecureStorage();
  Map<String, dynamic> data = {};

  data['id'] = int.parse(await storage.read(key: 'randomId'));
  data['name'] = await storage.read(key: 'name');
  data['masterKey'] = await storage.read(key: 'masterKey');

  List<String> rules = ['lowercases', 'digits'];

  PasswordGenerator generator = PasswordGenerator(
    id: data['id'],
    name: data['name'],
    website: 'com.clementpoiret.myauth/uuid',
    login: 'com.clementpoiret.myauth',
    counter: 1,
    length: 16,
    masterKey: data['masterKey'],
    rules: rules,
  );

  return await generator.generate();
}

class PasswordGenerator {
  final String name;
  final String masterKey;
  final int id;
  final String website;
  final String login;
  final int counter;
  final int length;
  final List<String> rules;

  PasswordGenerator({
    @required this.name,
    @required this.masterKey,
    @required this.id,
    @required this.website,
    @required this.login,
    @required this.counter,
    @required this.length,
    @required this.rules,
  });

  Future<String> generate() async {
    double entropy = await _getHash();
    return _renderPassword(entropy);
  }

  dynamic _consumeEntropy({
    String generatedPassword,
    double quotient,
    String charactersSet,
    int maxLength,
  }) {
    if (generatedPassword.length >= maxLength) {
      return [generatedPassword, quotient];
    }

    quotient = (quotient / charactersSet.length).floorToDouble();
    double remainder = quotient.remainder(charactersSet.length);
    generatedPassword += charactersSet[remainder.round()];

    return _consumeEntropy(
        generatedPassword: generatedPassword,
        quotient: quotient,
        charactersSet: charactersSet,
        maxLength: maxLength);
  }

  String _getCharacters() {
    if (rules == null || rules.isEmpty) {
      return kCharList['lowercases'] +
          kCharList['uppercases'] +
          kCharList['digits'] +
          kCharList['symbols'];
    } else {
      String chars = '';
      rules.forEach((rule) {
        chars += kCharList[rule];
      });
      return chars;
    }
  }

  Future<double> _getHash() async {
    String salt = name +
        website +
        login +
        length.toString() +
        id.toString() +
        counter.toRadixString(16);

    Pbkdf2 pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac(sha256),
      iterations: 10000,
      bits: 128,
    );
    Nonce nonce = Nonce(utf8.encode(salt));

    final hash = await pbkdf2.deriveBits(
      utf8.encode(masterKey),
      nonce: nonce,
    );

    print(hash);

    return double.parse(hash.join());
  }

  List _getOneChar(double entropy, List<String> rules) {
    String oneChar = '';
    rules.forEach((rule) {
      String chars = kCharList[rule];
      dynamic consumedEntropy = _consumeEntropy(
          generatedPassword: '',
          quotient: entropy,
          charactersSet: chars,
          maxLength: 1);

      String value = consumedEntropy[0];
      entropy = consumedEntropy[1];
      oneChar += value;
    });

    return [oneChar, entropy];
  }

  String _insertString(
      {String generatedPassword, double entropy, String string}) {
    for (int i = 0; i < string.length; i++) {
      double quotient = (entropy / generatedPassword.length).floorToDouble();
      double remainder = entropy.remainder(generatedPassword.length);

      String letter = string.substring(i, i + 1);
      generatedPassword = StringUtils.addCharAtPosition(
        generatedPassword,
        letter,
        remainder.round(),
      );

      entropy = quotient;
    }

    return generatedPassword;
  }

  String _renderPassword(double entropy) {
    String chars = _getCharacters();
    dynamic consumedEntropy = _consumeEntropy(
        generatedPassword: '',
        quotient: entropy,
        charactersSet: chars,
        maxLength: length - rules.length);
    String password = consumedEntropy[0];
    double passwordsEntropy = consumedEntropy[1];

    List charsAndEntropy = _getOneChar(passwordsEntropy, rules);
    String charToAdd = charsAndEntropy[0];
    double charsEntropy = charsAndEntropy[1];

    return _insertString(
      generatedPassword: password,
      entropy: charsEntropy,
      string: charToAdd,
    );
  }
}
