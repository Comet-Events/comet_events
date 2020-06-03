import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {

  AuthService _auth = locator<AuthService>();
  CometThemeManager _theme = locator<CometThemeManager>();

  int _count = 0;
  int get count => _count;

  // tabs
  editAccount() {}
  resetPassword() {}
  clearCache() {}


  darkThemeOn() {
    _theme.changeToDark();
  }

  darkThemeOff() {
    _theme.changeToDark();
  }

  void signOut() {
    _auth.signOut();
  }
}