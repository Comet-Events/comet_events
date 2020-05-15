import 'package:comet_events/core/models/models.dart';
import 'package:comet_events/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelWidget<T extends BaseModel> extends StatefulWidget {
  
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Widget child;

  ViewModelWidget({Key key, this.builder, this.onModelReady, this.child}) : super(key: key);

  @override
  _ViewModelWidgetState<T> createState() => _ViewModelWidgetState<T>();
}

class _ViewModelWidgetState<T extends BaseModel> extends State<ViewModelWidget<T>> {

  T model = locator<T>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.onModelReady != null) widget.onModelReady(model);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child ?? Container()
      ),
    );
  }
}