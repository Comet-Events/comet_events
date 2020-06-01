import 'package:comet_events/ui/screens/screens.dart';
import 'package:comet_events/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String auth = '/auth';

  static const String home = '/';

  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';

  static const String event = '/event';
  static const String eventAdd = '/event/add';

  static const String settings = '/settings';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name) {
    case Routes.auth:
      return MaterialPageRoute(builder: (context) => AuthScreen());
    case Routes.home:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case Routes.settings:
      return MaterialPageRoute(builder: (context) => SettingsScreen());

    // ! in the case there is an invalid path entered
    default: 
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text("The ${settings.name} path doesn't exist")
          )
        )
      );
  }
}