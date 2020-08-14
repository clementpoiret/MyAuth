import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kAccentColor = Colors.teal;

Map<String, String> kCharList = {
  'lowercases': 'abcdefghijklmnopqrstuvwxyz',
  'uppercases': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  'digits': '0123456789',
  'symbols': "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
};

final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
    elevation: 0,
    brightness: Brightness.dark,
    color: Colors.transparent,
  ),
  textTheme: GoogleFonts.ibmPlexMonoTextTheme(
    TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

final ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    elevation: 0,
    brightness: Brightness.light,
    color: Colors.transparent,
  ),
  textTheme: GoogleFonts.ibmPlexMonoTextTheme(
    TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
);
