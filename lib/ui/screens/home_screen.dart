import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _state = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeModel>.reactive(
        viewModelBuilder: () => HomeModel(),
        builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // Here we take the value from the HomeScreen object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title, style: TextStyle(color: locator<CometThemeManager>().theme.mainColor),),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Switch(
                value: _state, 
                onChanged: (bool) {
                  if(bool == false) locator<CometThemeManager>().changeToDark();
                  else locator<CometThemeManager>().changeToLight();

                  setState(() {
                    _state = !_state;
                  });
                }
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${model.count}',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
