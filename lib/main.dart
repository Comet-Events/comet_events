import 'package:comet_events/ui/screens/auth_screen.dart';
import 'package:comet_events/ui/screens/filter_screen.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:stacked_services/stacked_services.dart';

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
        ChangeNotifierProvider<CometThemeManager>.value(value: locator<CometThemeManager>()),
      ],
      child: LayoutBuilder(
        // this is for the SizeConfig initialization
        builder: (context, constraints) {
          // SizeConfig().init(constraints, Orientation.portrait);
          return Consumer<CometThemeManager>(
            builder: (context, manager, _) => MaterialApp(
              // title of the app
              title: 'Comet Events',
              // enable firebase analytics
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
              ],
              // app theme data
              theme: manager.theme.themeData,
              // ROUTING
              onGenerateRoute: generateRoute,
              initialRoute: Routes.auth,
              // ^ comment this out when testing
              navigatorKey: locator<NavigationService>().navigatorKey,
              /// ! ROUTING FOR TESTING
              /// When testing a screen, you can comment out the 'initialRoute' param, and use 'home' instead:
              /// home: FilterScreen()
            ),
          );
        }
      ),
    );
  }
}
