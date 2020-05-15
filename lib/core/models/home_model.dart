import 'package:comet_events/core/models/base_model.dart';

class HomeModel extends BaseModel {

  int _count = 0;
  int get count => _count;

  increment() {
    _count++;
    changeState(ViewState.Idle);
  }
}