import 'package:comet_events/core/models/auth/auth_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginBlockModel extends AuthModel{

  // * ----- Services -----
  AuthService _auth = locator<AuthService>();
  SnackbarService _snackbar = locator<SnackbarService>();
  NavigationService _navigation = locator<NavigationService>();

  // * ----- Login Functionality -----
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController get email => _email;
  TextEditingController get password => _password;

  void forgotPassword() {
    _snackbar.showSnackbar(
      title: 'Tapped forgot password!',
      iconData: Icons.favorite,
      message: "This feature isn't implemented yet!"
    );
  }

  void login() async {
    if(!emailCheck()) return;
    if(!passwordCheck()) return;
    AuthResponse response = await _auth.emailAndPasswordSignIn(email.text, password.text);
    if(response.user == null && response.exception != null) {
      showExceptionSnackbar(
        response.exception,
        titleDef: "LOGIN ERROR",
        messageDef: 'Unable to authenticate via email and password. Try again, or try again later.'
      );
      return;
    }
  }

  void googleLogin() async {
    AuthResponse response = await _auth.googleSignIn();
    if(response.user == null && response.exception != null) {
      showExceptionSnackbar(
        response.exception,
        titleDef: "GOOGLE AUTH ERROR",
        messageDef: 'Unable to authenticate via Google. Try again, or try again later.'
      );
      return;
    }
  }

  bool emailCheck() {
    return true;
  }
  bool passwordCheck() {
    return true;
  }
}