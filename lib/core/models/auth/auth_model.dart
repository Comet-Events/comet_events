import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {

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
}