import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/objects/objects.dart';

class DatabaseService {

  final Firestore db = Firestore.instance;

  // * ----- Collections -----
  CollectionReference get users => db.collection('/users');
  CollectionReference get events => db.collection('/events');

}
