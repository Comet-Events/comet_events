import 'package:comet_events/locator.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comet_events/core/services/services.dart';

void main() {
  setupLocator();
  runApp(CometEvents());
}

class CometEvents extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: locator<AuthService>().user),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomeScreen(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
