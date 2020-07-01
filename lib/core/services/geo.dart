import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoService extends DatabaseService {

  // dependencies
  LocationService _location = locator<LocationService>();

  Geoflutterfire _geo = Geoflutterfire();
  Geoflutterfire get geo => _geo;

  String field = 'location.geo.geopoint';
  double defaultRadius = 20;
  GeoFirePoint center;

  Stream<List<DocumentSnapshot>> eventStream;
  StreamSubscription<List<DocumentSnapshot>> eventStreamSub;
  List<DocumentSnapshot> eventList = [];

  // * init
  fetch({EventsFilter filter}) {
    center = GeoFirePoint(_location.currentLocation.latitude, _location.currentLocation.longitude);
    if(filter.radius == null) filter.radius = defaultRadius;

    // * create the query ref
    var queryRef = eventsCollection;
    if(filter.start != null) queryRef = queryRef.where('dates.start', isGreaterThan: Timestamp.fromDate(filter.start));
    if(filter.end != null) queryRef = queryRef.where('dates.end', isLessThan: Timestamp.fromDate(filter.end));
    if(filter.categories != null) queryRef = queryRef.where('categories', arrayContainsAny: filter.categories);
    if(filter.tags != null) queryRef = queryRef.where('tags', arrayContainsAny: filter.tags);

    // * ~~~~~~~~ Event Stream ~~~~~~~~~
    if(eventStreamSub != null) eventStreamSub.cancel(); 
    eventStream = 
      _geo
      .collection(collectionRef: queryRef)
      .within(center: center, radius: filter.radius, field: field);

    eventStreamSub = eventStream.listen((event) { eventList = event; });
  }
}

class EventsFilter {
  double radius;
  DateTime start;
  DateTime end;
  List<String> categories;
  List<String> tags;

  EventsFilter({
    this.radius, 
    this.start, 
    this.end, 
    this.categories, 
    this.tags
  });
}