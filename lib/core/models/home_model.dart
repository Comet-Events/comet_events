import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/models/base_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/filter_screen.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeModel extends StreamViewModel<List<DocumentSnapshot>> {

  @override
  Stream<List<DocumentSnapshot>> get stream => _geo.eventStream;

  // * ----- Services -----
  GeoService _geo = locator<GeoService>();
  AuthService _auth = locator<AuthService>();
  SnackbarService _snack = locator<SnackbarService>();
  LocationService _location = locator<LocationService>();
  NavigationService _navigation = locator<NavigationService>();

  // * ----- Variables -----
  List<EventTile> _events = [
    EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200',
     title: 'Fwood Pwarty', date: '11:30 PM', category: 'Food', tags: ['Fun', 'Cool', 'Fresh'], description: 'Free buffet for all'),
    EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200', title: "Neha's the best", date: 'Everyday', category: 'Relegious', tags: ['True', 'Words', 'to' ,'Live', 'By'], description: 'Rare chance to hangout wiht the best person on earth!'),
  ];
  
  List<EventTile> get events => _events;
  LocationData get location => _location.currentLocation;

  bool locationDisabled;
  EventsFilter currentFilter = EventsFilter();
  // this currentLocation, unlike the getter above, only stores the location when the model loads
  // rather than refreshing it live
  LocationData currentLocation;

  init() async {
    LocationSetupResponse setupResponse = await requestLocationPerms();
    if(!setupResponse.serviceEnabled) {
      _snack.showSnackbar(
        title: "Location Service Required",
        message: "Your location is required to use this application. Please enable location services for this application in your device's settings.",
        duration: Duration(seconds: 20),
        isDissmissible: false
      );
      locationDisabled = true;
      return;
    }
    await getLocation();

    // fetch events nearby
    await _geo.fetch(filter: currentFilter);
  }

  // * ----- location -----
  requestLocationPerms() async {
    LocationSetupResponse setupResponse = await _location.setup();
    notifyListeners();
    return setupResponse;
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