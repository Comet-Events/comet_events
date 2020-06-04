import 'package:comet_events/core/models/base_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeModel extends BaseModel {

  AuthService _auth = locator<AuthService>();
  NavigationService _navigation = locator<NavigationService>();


  int _count = 0;
  int get count => _count;

  increment() {
    _navigation.navigateWithTransition(AddEventScreen(), opaque: false, transition: NavigationTransition.Fade);
  }

  signOut() {
    _auth.signOut();
  }
}