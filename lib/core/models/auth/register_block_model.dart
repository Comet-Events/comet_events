import 'package:comet_events/core/models/auth/auth_model.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterBlockModel extends AuthModel {

  // * ----- Services -----
  AuthService _auth = locator<AuthService>();
  UserService _users = locator<UserService>();
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
    AuthResponse response = await _auth.registerWithEmailandPassword(email.text, password.text);
    if(response.user == null && response.exception != null) {
      showExceptionSnackbar(
        response.exception,
        titleDef: "REGISTER ERROR",
        messageDef: 'Unable to register user. Make sure all fields are filled in. Try again.'
      );
      return;
    }
    // create a new user document and add name data, as well as pfp preset
    User newUser = User(
      uid: response.user.uid,
      name: UserName(
        first: capitalize(_first.text),
        last: capitalize(_last.text)
      ),
    );

    // add new user stuff to db
    try {
      await _users.addNewUser(newUser);
    } catch(err) {
      print(err);
      _snackbar.showSnackbar(
        title: 'UNABLE TO ADD TO DATABASE',
        iconData: Icons.close,
        duration: Duration(seconds: 10),
        isDissmissible: true,
        message: "For some reason, the register attempt failed. Please try again, and if it still doesn't work, try again later! We sowwy about that :("
      );
      return;
    }
  }

  // * ----- Utilities -----
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