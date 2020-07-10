import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    EventFilters initFilters = EventFilters();
    initFilters.endRangeStart = DateTime.now();
    filter.add(initFilters);
    events.add([]);
  }
  // * init
  start({List<Event> Function(List<Event>) cb}) async {
    center = GeoFirePoint(_location.currentLocation.latitude, _location.currentLocation.longitude);
    if(filter.value.radius == null) filter.value.radius = defaultRadius;
    // event stream
    if(eventStreamSub != null) eventStreamSub.cancel();
    eventStreamSub = 
    filter.stream.switchMap((newFilter) {
      /// * TIME FILTERS
      // start
      // print('reached start');
      // ! you can only have one inequality filter, and that filter is being used by geofluttefire :(
      // TODO: create an eventActive bool field to check, that gets updated on firebase using a cloud function
      var queryRef = eventsCollection;
      // var queryRef = eventsCollection.where('dates.end', isGreaterThan: DateTime.now()); 
      // if(filter.value.startRangeStart != null) { 
      //   queryRef = queryRef.where('dates.start', isGreaterThan: filter.value.startRangeStart); 
      // }
      // // end
      // queryRef = queryRef.where('dates.end', isGreaterThan: filter.endRangeStart);
      // if(filter.endRangeEnd != null) {
      //   queryRef = queryRef.where('dates.end', isLessThan: filter.endRangeEnd);
      // }
      /// * CATEGORY AND TAG FILTERS 
      // if(filter.value.categories != null && filter.value.categories.isNotEmpty) queryRef = queryRef.where('categories', arrayContainsAny: filter.value.categories);
      // if(filter.value.tags != null && filter.value.tags.isNotEmpty) queryRef = queryRef.where('tags', arrayContainsAny: filter.value.tags);
      // * ~~~~~~~~ Event Stream ~~~~~~~~~
      // if(eventStreamSub != null) eventStreamSub.cancel(); 
      return _geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: filter.value.radius, field: field, strictMode: true)
        .map((list) => list.map((snapshot) => Event.fromJson(snapshot.data)).toList());
    }).listen((list) {
      if(cb != null) list = cb(list);
      events.add(list); 
    });
  }


  // ! ---------- CRUD ----------
  Future<void> addNewEvent(Event event) async {
    await eventsCollection.document().setData(event.toJson());
  }

  Future<void> updateEvent(String id, Event updatedEvent) async {
    await eventsCollection.document(id).updateData(updatedEvent.toJson());
  }
  
}