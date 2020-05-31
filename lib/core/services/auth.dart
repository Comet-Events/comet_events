import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _u;

  // two methods of retrieving user data
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;
  FirebaseUser get u => _u;

  AuthService() {
    user.listen((user) { _u = user; });
  }


  // register with email and password
  Future<AuthResponse> registerWithEmailandPassword(String email, String password) async {
    try {
       AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       FirebaseUser user = result.user;
       return AuthResponse(user: user);
    } catch (err) {
      return AuthResponse(exception: err);
    }
  }

  // GoogleSignIn
  Future<AuthResponse> googleSignIn() async {
    try {
      // first three steps are simply for getting the accessToken and idToken
      GoogleSignInAccount gsia = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await gsia.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // use the auth credentials to sign in with firebase auth
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      return AuthResponse(user: user);

    } catch (err) {
      return AuthResponse(exception: err);
    }
  }

  // Email and Password
  Future<AuthResponse> emailAndPasswordSignIn(String email, String password) async {
    try {
      // no need for accessTokens and idTokens :)
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return AuthResponse(user: authResult.user);
    } catch (err) {
      return AuthResponse(exception: err);
    }
  }

  // Sign Out
  Future<void> signOut() {
    try {
      return _auth.signOut();
    } catch (err) {
      print("Could not sign user out for some reason...");
      print(err);
      return null;
    }
  }
}

class AuthResponse {
  final FirebaseUser user;
  final PlatformException exception;

  AuthResponse({this.user, this.exception});
}