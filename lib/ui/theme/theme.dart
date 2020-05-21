import 'dart:async';

import 'package:flutter/material.dart';

class CometThemeManager extends ChangeNotifier {

  CometThemeData _currentTheme = lightTheme;
  CometThemeData get theme => _currentTheme;

  // ------- COLORS -------
  // mono darks
  static const Color mainMonoDark = Color(0xff343434);
  static const Color secondaryMonoDark = Color(0xff3E3E3E);

  // mono lights
  static const Color mainMonoLight = Color(0xffF0F0F0);
  static const Color secondaryMonoLight = Color(0xffDDDDDD);

  // dark colors
  static const Color mainColorDark = Color(0xff8B51CF);
  static const Color secondaryColorDark = Color(0xff8B51CF);

  // light colors
  static const Color mainColorLight = Color(0xffF66037);
  static const Color secondaryColorLight = Color(0xff8B51CF);

  // dark uniques (list custom colors here)
  static const Color lineBorderDark = Colors.grey;
  static const Color miniTextDark = Colors.pink;

  // light uniques (list custom colors here)
  static const Color lineBorderLight = Colors.grey;
  static const Color miniTextLight = Colors.pink;

  // dark theme data
  static CometThemeData darkTheme = CometThemeData(
    themeData: ThemeData(
      primaryColor: mainMonoDark,
      accentColor: secondaryMonoDark,
      brightness: Brightness.dark,
      fontFamily: "Lexend Deca"
    ),
    mainMono: mainColorDark,
    secondaryMono: secondaryMonoDark,
    mainColor: mainColorDark,
    secondaryColor: secondaryColorDark,
    lineBorder: lineBorderDark,
    miniText: miniTextDark
  );

  // light theme data
  static CometThemeData lightTheme = CometThemeData(
    themeData: ThemeData(
      primaryColor: mainMonoLight,
      accentColor: secondaryMonoLight,
      brightness: Brightness.light,
      fontFamily: "Lexend Deca"
    ),
    mainMono: mainMonoLight,
    secondaryMono: secondaryMonoLight,
    mainColor: mainColorLight,
    secondaryColor: secondaryColorLight,
    lineBorder: lineBorderLight,
    miniText: miniTextLight
  );

  // MINI THEME MANAGEMENT SYSTEM uwuwuwuwu :3
  // StreamController<CometThemeData> _controller = StreamController<CometThemeData>();

  // Stream<CometThemeData> get theme => _controller.stream;

  // Future<CometThemeData> get currentTheme => this.theme.last;

  changeToDark() {
    _currentTheme = darkTheme;
    notifyListeners();
  }
  changeToLight() {
    _currentTheme = lightTheme;
    notifyListeners();
  }
}

class CometThemeData {
  final ThemeData themeData;
  // mono means blacks/whites
  final Color mainMono;
  final Color secondaryMono;
  // colors. in this case it's different purples
  final Color mainColor;
  final Color secondaryColor;
  // specific unique colors go here
  // ! if you add a new type, then make sure to set the lightmode and darkmode version
  // ! in the CometThemeManager ()
  final Color lineBorder;
  final Color miniText;

  CometThemeData({ 
    @required this.themeData,
    @required this.mainMono,
    @required this.secondaryMono,
    @required this.mainColor,
    @required this.secondaryColor,
    @required this.lineBorder,
    @required this.miniText,
   });
}