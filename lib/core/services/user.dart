import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/db.dart';

class UserService extends DatabaseService {

  Future<void> addNewUser(User user) async {
    await usersCollection.document(user.uid).setData(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await usersCollection.document(user.uid).setData(user.toUpdateJson(), merge: true);
  }
}