import 'dart:async';

import 'package:flutter/material.dart';

class CometThemeManager extends ChangeNotifier {

  CometThemeData _currentTheme = prettyTheme;
  CometThemeData get theme => _currentTheme;

  // ------- COLORS -------
  // main monos
  static const Color mainMonoDark = Color(0xff343434);
  static const Color mainMonoLight = Color(0xffF0F0F0);
  static const Color mainMonoPretty = Color(0xFF21213E);

  // secondary monos
  static const Color secondaryMonoDark = Color(0xff3E3E3E);
  static const Color secondaryMonoLight = Color(0xffDDDDDD);
  static const Color secondaryMonoPretty = Color(0XFF3A3B5D);

  //main colors
  static const Color mainColorDark = Color(0xff8B51CF);
  static const Color mainColorLight = Color(0xffF66037);
  static const Color mainColorPretty = Color(0XFFF43181);

  //secondary colors
  static const Color secondaryColorDark = Color(0xff8B51CF);
  static const Color secondaryColorLight = Color(0xff8B51CF);
  static const Color secondaryColorPretty = Color(0xFF4796D4);

  // dark uniques (list custom colors here)
  static const Color lineBorderDark = Color.fromARGB(255, 80, 80, 80);
  static const Color miniTextDark = Color.fromARGB(255, 141, 129, 147);
  static const Map<int, Color> mainColorDarkMap = {
    50: Color.fromRGBO(139, 81, 207, 0.5),
    100: Color.fromRGBO(130, 81, 207, 1)
  };
  static const MaterialColor mainColorDarkSwatch = MaterialColor(0xFF8B51CF, mainColorDarkMap);

  // light uniques (list custom colors here)
  static const Color lineBorderLight = Colors.grey;
  static const Color miniTextLight = Colors.pink;
  static const Map<int, Color> mainColorLightMap = {
    50: Color.fromRGBO(246, 96, 55, 0.5),
    100: Color.fromRGBO(246, 96, 55, 1)
  };
  static const MaterialColor mainColorLightSwatch = MaterialColor(0xffF66037, mainColorLightMap);

  // pretty uniques
  static const Color lineBorderPretty = Color(0xFF7F80A2);
  static const Map<int, Color> mainColorPrettyMap = {
    50: Color.fromRGBO(244, 49, 129, 0.5),
    100: Color.fromRGBO(244, 49, 129, 1)
  };
  static const MaterialColor mainColorPrettySwatch = MaterialColor(0xffF43181, mainColorPrettyMap);

  // dark theme data
  static CometThemeData darkTheme = CometThemeData(
    themeData: ThemeData(
      cursorColor: mainColorDark,
      primaryColor: mainMonoDark,
      brightness: Brightness.dark,
      fontFamily: "Lexend Deca",
      //this is the color of the top of the date picker
      cardColor: mainMonoDark,
      //this is the color for the background of the body of the pickers      
      dialogBackgroundColor: secondaryMonoDark,
      //the color of the time picker dial
      accentColor: mainColorDark,
      //color for head and body background of time picker
      backgroundColor: mainMonoDark,
      //color of date chosen in datepicker
      primarySwatch: mainColorDarkSwatch,
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
      brightness: Brightness.light,
      fontFamily: "Lexend Deca",
      //this is the color of the top of the date picker
      cardColor: mainMonoLight,
      //this is the color for the background of the body of the pickers      
      dialogBackgroundColor: secondaryMonoLight,
      //the color of the time picker dial
      accentColor: mainColorLight,
      //color for head and body background of time picker
      backgroundColor: mainMonoLight,
      //color of date chosen in datepicker
      primarySwatch: mainColorLightSwatch,
    ),
    mainMono: mainMonoLight,
    secondaryMono: secondaryMonoLight,
    mainColor: mainColorLight,
    secondaryColor: secondaryColorLight,
    lineBorder: lineBorderLight,
    miniText: miniTextLight
  );

  // pretty theme data
  static CometThemeData prettyTheme = CometThemeData(
    themeData: ThemeData(
      cursorColor: mainColorPretty,
      primaryColor: mainMonoPretty,
      brightness: Brightness.dark,
      fontFamily: "Lexend Deca",
      //this is the color of the top of the date picker
      cardColor: mainMonoPretty,
      //this is the color for the background of the body of the pickers      
      dialogBackgroundColor: secondaryMonoPretty,
      //the color of the time picker dial
      accentColor: mainColorPretty,
      //color for head and body background of time picker
      backgroundColor: mainMonoPretty,
      //color of date chosen in datepicker
      primarySwatch: mainColorPrettySwatch,
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