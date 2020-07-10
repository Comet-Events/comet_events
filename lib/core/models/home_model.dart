import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/filter_screen.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/ui/screens/screens.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

extension on List {
  bool listContains(List list) {
    for(int i = 0; i < list.length; i++) {
      if(this.contains(list[i])) return true;
    }
    return false;
  }
}

class HomeModel extends MultipleStreamViewModel {

  // @override
  // Stream<List<Event>> get stream => _event.events.stream;
  @override
  Map<String, StreamData> get streamsMap => {
    "eventStream": StreamData<List<Event>>(_event.events.stream),
    "filterStream": StreamData<EventFilters>(_event.filter.stream)
  };

  // * ----- Services -----
  EventService _event = locator<EventService>();
  SnackbarService _snack = locator<SnackbarService>();
  LocationService _location = locator<LocationService>();
  NavigationService _navigation = locator<NavigationService>();

  // * ----- Variables -----
  // List<EventTile> _events = [
    //EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200)',
    //  title: 'Fwood Pwarty', date: '11:30 PM', category: 'Food', tags: ['Fun', 'Cool', 'Fresh'], description: 'Free buffet for all'),
    //EventTile(scale: 1.2, imageURL: 'https://picsum.photos/200', title: "Neha's the best", date: 'Everyday', category: 'Relegious', tags: ['True', 'Words', 'to' ,'Live', 'By'], description: 'Rare chance to hangout wiht the best person on earth!'),
  // ];
  
  //List<EventList> get events => eventList.map((e) => EventTile(event: e, scale: 1.2)).toList();
  List<Event> get events => _event.events.value;
  LocationData get location => _location.currentLocation;
  String get rad => _event.filter.value.radius.toString();

  bool locationDisabled;
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
    } else {
      await getLocation();
      await _event.start(cb: applyFilters);
    }
  }

  List<Event> applyFilters(List<Event> list) {
    EventFilters filter = _event.filter.value;
    // print(list.map((e) => e.name).toList());
    // * tags & categories
    if(filter.categories != null && filter.categories.isNotEmpty) list = list.where((e) => e.categories.listContains(filter.categories)).toList();
    if(filter.tags != null && filter.tags.isNotEmpty) list = list.where((e) => e.tags.listContains(filter.tags)).toList();
    // * timing
    if(filter.endRangeEnd != null) list = list.where((e) => e.dates.end.millisecondsSinceEpoch <= filter.endRangeEnd.millisecondsSinceEpoch ).toList();
    if(filter.endRangeStart != null) list = list.where((e) => e.dates.end.millisecondsSinceEpoch >= filter.endRangeStart.millisecondsSinceEpoch ).toList();
    if(filter.startRangeEnd != null) list = list.where((e) => e.dates.start.millisecondsSinceEpoch <= filter.startRangeEnd.millisecondsSinceEpoch ).toList();
    if(filter.startRangeStart != null) list = list.where((e) => e.dates.start.millisecondsSinceEpoch >= filter.startRangeStart.millisecondsSinceEpoch ).toList();
    
    // print(list.map((e) => e.name).toList());
    return list;
  }

  update() { notifyListeners(); }

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
}