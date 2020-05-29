import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/db.dart';

class UserService extends DatabaseService {

  Future<void> addNewUser(User user) async {
    await db.collection('/users').document(user.uid).setData(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await db.collection('/users').document(user.uid).setData(user.toJson(), merge: true);
  }
}