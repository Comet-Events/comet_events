import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // two methods of retrieving user data
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  // GoogleSignIn
  Future<FirebaseUser> googleSignIn() async {
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
      return user;

    } catch (err) {
      print("There was an error attempting to sign into Comet Events through google sign in \n" + err);
      return null;
    }
  }

  // Email and Password
  Future<FirebaseUser> emailAndPasswordSignIn(String email, String password) async {
    try {
      // no need for accessTokens and idTokens :)
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return authResult.user;
    } catch (err) {
      print("There was an error attempting to sign in using email and password \n" + err);
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() {
    try {
      return _auth.signOut();
    } catch (err) {
      print("Could not sign user out for some reason...\n" + err);
      return null;
    }
  }
}