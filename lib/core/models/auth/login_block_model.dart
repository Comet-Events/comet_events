import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginBlockModel extends ChangeNotifier {

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
    FirebaseUser user = await _auth.emailAndPasswordSignIn(email.text, password.text);
    if(user == null) {
      _snackbar.showSnackbar(
        title: 'Email/Password Login Failed',
        iconData: Icons.close,
        duration: Duration(seconds: 15),
        isDissmissible: true,
        message: "For some reason, the login attempt failed. Please try again, and if it still doesn't work, try again later! Sowwy :("
      );
      return;
    }
    // success
    _navigation.replaceWith(Routes.home);
  }

  void googleLogin() async {
    FirebaseUser user = await _auth.googleSignIn();
    if(user == null) {
      _snackbar.showSnackbar(
        title: 'Google Login Failed',
        iconData: Icons.close,
        duration: Duration(seconds: 15),
        isDissmissible: true,
        message: "For some reason, the login attempt via Google failed. Please try again, and if it still doesn't work, try again later! Sowwy :("
      );
      return;
    }
    // success
    _navigation.replaceWith(Routes.home);
  }

  bool emailCheck() {
    return true;
  }
  bool passwordCheck() {
    return true;
  }
}