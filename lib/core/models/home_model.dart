import 'package:comet_events/core/models/base_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeModel extends BaseModel {

  AuthService _auth = locator<AuthService>();
  LocationService _location = locator<LocationService>();
  NavigationService _navigation = locator<NavigationService>();


  // Stream<LocationData> get stream => _location.locationStream;
  LocationData get location => _location.currentLocation;

  LocationData currentLocation;
  int _count = 0;
  int get count => _count;

  requestLocationPerms() async {
    await _location.setup();
    notifyListeners();
  }

  getLocation() async {
    currentLocation = await _location.getLocation();
    notifyListeners();
  }

  increment() {
    _navigation.navigateWithTransition(AddEventScreen(), opaque: false, transition: NavigationTransition.Fade);
  }

  signOut() {
    _auth.signOut();
  }
}