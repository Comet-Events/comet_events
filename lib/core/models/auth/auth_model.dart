import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:comet_events/utils/router.dart';

class AuthModel extends ChangeNotifier {

  // * ----- Services -----
  NavigationService _navigation = locator<NavigationService>();
  SnackbarService _snackbar = locator<SnackbarService>();

  // * ----- PAGE TRANSFORMATION -----
  int _currentScreen = 0;
  int get currentScreen => _currentScreen;
  PageController _controller = PageController();
  PageController get controller => _controller;

  void moveToRegister() {
    _currentScreen = 1;
    _controller.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
  void moveToLogin() {
    _currentScreen = 0;
    _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
  void pageChanged(int page) {
    _currentScreen = page;
    notifyListeners();
  }

  // * ----- Stuff Blocks Need -----
  void showExceptionSnackbar(PlatformException exception, {String titleDef = "", String messageDef = "", int duration = 10, IconData iconData = Icons.report}) {
    _snackbar.showSnackbar(
      title: exception.code.replaceAll("_", " ").replaceAll("ERROR", "").substring(1) ?? titleDef,
      iconData: iconData,
      duration: Duration(seconds: duration),
      isDissmissible: true,
      message: exception.message ?? messageDef
    );
  } 
  String capitalize(String word) {
    return word.length > 0 ? word[0].toUpperCase() + word.substring(1) : "";
  }
  void moveToHome() {
    _navigation.replaceWith(Routes.home);
  }
}