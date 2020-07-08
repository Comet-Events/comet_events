import 'dart:async';
import 'package:comet_events/core/objects/EventFilters.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class EventService extends DatabaseService {
  
  // ! ------ DEPENDENCIES ------
  LocationService _location = locator<LocationService>();
  Geoflutterfire _geo = Geoflutterfire();
  Geoflutterfire get geo => _geo;

  // ! ------ VARS ------
  String field = 'location.geo';
  double defaultRadius = 10;
  GeoFirePoint center;

  // ! ------ STREAMS ------
  BehaviorSubject<EventFilters> filter = BehaviorSubject<EventFilters>();
  BehaviorSubject<List<Event>> events = BehaviorSubject<List<Event>>();
  StreamSubscription<List<Event>> eventStreamSub;

  EventService() {
    filter.add(EventFilters());
    events.add([]);
  }
  // * init
  start({Function(List<Event>) cb}) async {
    center = GeoFirePoint(_location.currentLocation.latitude, _location.currentLocation.longitude);
    if(filter.value.radius == null) filter.value.radius = defaultRadius;
    if(eventStreamSub != null) eventStreamSub.cancel();
    eventStreamSub = 
    filter.stream.switchMap((newFilter) {
      /// * TIME FILTERS
      // start
      var queryRef = eventsCollection.where('dates.start', isLessThan: filter.value.startRangeEnd); 
      // if(filter.startRangeStart != null) { 
      //   queryRef = queryRef.where('dates.start', isGreaterThan: filter.startRangeStart); 
      // }
      // // end
      // queryRef = queryRef.where('dates.end', isGreaterThan: filter.endRangeStart);
      // if(filter.endRangeEnd != null) {
      //   queryRef = queryRef.where('dates.end', isLessThan: filter.endRangeEnd);
      // }
      /// * CATEGORY AND TAG FILTERS 
      if(filter.value.categories != null && filter.value.categories.isNotEmpty) queryRef = queryRef.where('categories', arrayContainsAny: filter.value.categories);
      if(filter.value.tags != null && filter.value.tags.isNotEmpty) queryRef = queryRef.where('tags', arrayContainsAny: filter.value.tags);
      // * ~~~~~~~~ Event Stream ~~~~~~~~~
      // if(eventStreamSub != null) eventStreamSub.cancel(); 
      return _geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: filter.value.radius, field: field, strictMode: true)
        .switchMap((docSnap) =>  Stream.value(docSnap.map((e) => Event.fromJson(e.data)).toList()));
    }).listen(cb);
  }


  // ! ---------- CRUD ----------
  Future<void> addNewEvent(Event event) async {
    await eventsCollection.document().setData(event.toJson());
  }

  Future<void> updateEvent(String id, Event updatedEvent) async {
    await eventsCollection.document(id).updateData(updatedEvent.toJson());
  }
  
}