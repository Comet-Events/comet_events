import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/objects/objects.dart';

class DatabaseService {

  final Firestore db = Firestore.instance;

  // * ----- Collections -----
  CollectionReference get usersCollection => db.collection('/users');
  CollectionReference get eventsCollection => db.collection('/events');
  CollectionReference get tagsCollection => db.collection('/tags');

  // * ----- ~~~~~~~ streams uwu wavey ~~~~~~~~ -----
  Stream<QuerySnapshot> get users => usersCollection.snapshots();
  Stream<QuerySnapshot> get events => eventsCollection.snapshots();
  Stream<QuerySnapshot> get tags => tagsCollection.snapshots();
}
