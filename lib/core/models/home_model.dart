import 'package:comet_events/core/models/base_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/filter_screen.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:location/location.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeModel extends BaseModel {

  // * ----- Services -----
  AuthService _auth = locator<AuthService>();

  LocationService _location = locator<LocationService>();
  NavigationService _navigation = locator<NavigationService>();

  // * ----- Variables -----
  List<EventTile> _events = [
    // EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200',
    //  title: 'Fwood Pwarty', date: '11:30 PM', category: 'Food', tags: ['Fun', 'Cool', 'Fresh'], description: 'Free buffet for all'),
    // EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200', title: "Neha's the best", date: 'Everyday', category: 'Relegious', tags: ['True', 'Words', 'to' ,'Live', 'By'], description: 'Rare chance to hangout wiht the best person on earth!'),
  ];
  
  List<EventTile> get events => _events;
  LocationData get location => _location.currentLocation;

  LocationData currentLocation;
  int _count = 0;
  int get count => _count;

  // * ----- location -----
  requestLocationPerms() async {
    await _location.setup();
    notifyListeners();
  }

  getLocation() async {
    currentLocation = await _location.getLocation();
    notifyListeners();
  }

  // * ----- page navigation -----
  moveToFilterScreen() {
    _navigation.navigateWithTransition(
      FilterScreen(),
      opaque: false,
      transition: NavigationTransition.Fade
    );
  }
  moveToAddEventScreen() {
    _navigation.navigateWithTransition(
      AddEventScreen(),
      opaque: false,
      transition: NavigationTransition.Fade
    );
  }
  

  signOut() {
    _auth.signOut();
  }
}