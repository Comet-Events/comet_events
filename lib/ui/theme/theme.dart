import 'dart:async';

import 'package:flutter/material.dart';

class CometThemeManager extends ChangeNotifier {

  CometThemeData _currentTheme = prettyTheme;
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
  static const Color lineBorderDark = Color.fromARGB(255, 80, 80, 80);
  static const Color miniTextDark = Color.fromARGB(255, 141, 129, 147);

  // light uniques (list custom colors here)
  static const Color lineBorderLight = Colors.grey;
  static const Color miniTextLight = Colors.pink;


  //NEHA'S EXPERIEMENTS START
  static const Color mainMonoPretty = Color(0xFF21213E);
  static const Color secondaryMonoPretty = Color(0XFF3A3B5D);
  static const Color mainColorPretty = Color(0XFFF43181);
  static const Color secondaryColorPretty = Color(0xFF4796D4);
  static const Color lineBorderPretty = Color(0xFF7F80A2);
  //NEHA'S EXPERIMENTS END

  // dark theme data
  static CometThemeData darkTheme = CometThemeData(
    themeData: ThemeData(
      cursorColor: mainColorDark,
      primaryColor: mainMonoDark,
      accentColor: secondaryMonoDark,
      brightness: Brightness.dark,
      fontFamily: "Lexend Deca"
    ),
    mainMono: mainMonoDark,
    secondaryMono: secondaryMonoDark,
    mainColor: mainColorDark,
    secondaryColor: secondaryColorDark,
    lineBorder: lineBorderDark,
    miniText: miniTextDark
  );

  // light theme data
  static CometThemeData lightTheme = CometThemeData(
    themeData: ThemeData(
      cursorColor: mainColorLight,
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

  //new theme data
  static CometThemeData prettyTheme = CometThemeData(
    themeData: ThemeData(
      cursorColor: mainColorPretty,
      primaryColor: mainMonoPretty,
      accentColor: secondaryMonoPretty,
      brightness: Brightness.dark,
      fontFamily: "Lexend Deca"
    ),
    mainMono: mainMonoPretty,
    secondaryMono: secondaryMonoPretty,
    mainColor: mainColorPretty,
    secondaryColor: secondaryColorPretty,
    lineBorder: lineBorderPretty,
    miniText: secondaryColorPretty
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
  changeToPretty() {
    _currentTheme = prettyTheme;
    notifyListeners();
  }

  // * ----- Utilities -----
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
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
  Color opposite;
  Color antiOpposite;

  CometThemeData({ 
    @required this.themeData,
    @required this.mainMono,
    @required this.secondaryMono,
    @required this.mainColor,
    @required this.secondaryColor,
    @required this.lineBorder,
    @required this.miniText,
   }) {
     opposite = themeData.brightness == Brightness.dark ? Colors.white : Colors.black;
     antiOpposite = themeData.brightness == Brightness.dark ? Colors.black : Colors.white;
   }
}