import 'package:comet_events/core/models/models.dart';
import 'package:comet_events/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBaseWidget<T extends BaseModel> extends StatefulWidget {
  final Widget Function(
      BuildContext context, T model, FirebaseUser user, Widget child) builder;
  final Function(T model) onModelReady;
  final Widget child;

  UserBaseWidget({Key key, this.builder, this.onModelReady, this.child})
      : super(key: key);

  @override
  _UserBaseWidgetState<T> createState() => _UserBaseWidgetState<T>();
}

class _UserBaseWidgetState<T extends BaseModel>
    extends State<UserBaseWidget<T>> {
  T model = locator<T>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.onModelReady != null) widget.onModelReady(model);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer2<T, FirebaseUser>(
        builder: widget.builder,
        child: widget.child ?? Container(),
      ),
    );
  }
}
