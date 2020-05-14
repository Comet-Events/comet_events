import 'package:flutter/foundation.dart';

enum ViewState {
  Idle,
  Busy,
  NoConnection
}

class BaseModel extends ChangeNotifier {
  ViewState _state;
  ViewState get state => _state;

  changeState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}