import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterBlockModel extends ChangeNotifier {

  // * ----- Services -----
  AuthService _auth = locator<AuthService>();
  SnackbarService _snackbar = locator<SnackbarService>();
  NavigationService _navigation = locator<NavigationService>();

  // * ----- Login Functionality -----
  TextEditingController _first = TextEditingController();
  TextEditingController _last = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController get first => _first;
  TextEditingController get last => _last;
  TextEditingController get email => _email;
  TextEditingController get password => _password;

  void register() async {
    if(!nameCheck()) return;
    if(!emailCheck()) return;
    if(!passwordCheck()) return;
    FirebaseUser user = await _auth.registerWithEmailandPassword(email.text, password.text);
    if(user == null) {
      _snackbar.showSnackbar(
        title: 'Register Failed',
        iconData: Icons.close,
        duration: Duration(seconds: 15),
        isDissmissible: true,
        message: "For some reason, the register attempt failed. Please try again, and if it still doesn't work, try again later! We sowwy about that :("
      );
      return;
    }
    // create a new user document and add name data, as well as pfp preset
    

    // success
    _navigation.replaceWith(Routes.home);
  }

  bool nameCheck() {
    return true;
  }
  bool emailCheck() {
    return true;
  }
  bool passwordCheck() {
    return true;
  }
}