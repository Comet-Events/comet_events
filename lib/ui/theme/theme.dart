import 'dart:async';

import 'package:flutter/material.dart';

class CometEventsTheme {
  // darks
  static Color primaryDark = Color(0xff343434);
  static Color accentDark = Color(0xff3E3E3E);

  // lights
  static Color primaryLight = Color(0xffF0F0F0);
  static Color accentLight = Color(0xffDDDDDD);

  // colors
  static Color primaryColorOne = Color(0xff8B51CF);
  static Color primaryColorTwo = Color(0xffDD2476);

  // brightness, and other settings
  static Brightness brightnessDark = Brightness.dark;
  static Brightness brightnessLight = Brightness.light;

  // dark theme data
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    accentColor: accentDark,
    brightness: brightnessDark,
  );

  // light theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryLight,
    accentColor: accentLight,
    brightness: brightnessLight
  );

  // MINI THEME MANAGEMENT SYSTEM :3
  StreamController<ThemeData> _controller = StreamController<ThemeData>();

  Stream<ThemeData> get theme => _controller.stream;

  changeToDark() {
    _controller.add(darkTheme);
    print("changed theme to dark mode");
  }
  changeToLight() {
    _controller.add(lightTheme);
    print("changed theme to light mode");
  }
}