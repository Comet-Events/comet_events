import 'package:comet_events/ui/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(CometEvents());
}

class CometEvents extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
