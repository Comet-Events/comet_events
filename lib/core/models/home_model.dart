import 'package:comet_events/core/models/base_model.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';

class HomeModel extends BaseModel {

  AuthService _auth = locator<AuthService>();

  int _count = 0;
  int get count => _count;

  increment() {
    _count++;
    // changeState(ViewState.Idle);
    notifyListeners();
  }

  signOut() {
    _auth.signOut();
  }
}