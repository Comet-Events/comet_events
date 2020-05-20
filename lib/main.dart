import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:comet_events/utils/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // This locks the orientation of the app to portrait mode
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    // This MultiProvider provides global services to the rest of the app.
    return MultiProvider(
      providers: [
        // This provides a stream of the current firebase user to the rest of the app
        StreamProvider<FirebaseUser>.value(value: locator<AuthService>().user),
        StreamProvider<ThemeData>.value(value: locator<CometEventsTheme>().theme),
      ],
      child: LayoutBuilder(
        // this is for the SizeConfig initialization
        builder: (context, constraints) {
          SizeConfig().init(constraints, Orientation.portrait);
          return Consumer<ThemeData>(
            builder: (context, themeData, _) => MaterialApp(
              // title of the app
              title: 'Comet Events',
              // enable firebase analytics
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
              ],
              // app theme data
              theme: themeData,
              home: HomeScreen(title: 'Flutter Demo Home Page'),
            ),
          );
        }
      ),
    );
  }
}
