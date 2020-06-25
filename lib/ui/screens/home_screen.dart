import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key,}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _state = false;

  @override
  Widget build(BuildContext context) {
    return UserViewModelBuilder<HomeModel>.reactive(
        userViewModelBuilder: () => HomeModel(),
        onModelReady: (model, user) async {
          await model.requestLocationPerms();
          await model.getLocation();
        },
        builder: (context, model, user, child) => Scaffold(
          appBar: AppBar(
            // Here we take the value from the HomeScreen object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('SM Comet Events Example', style: TextStyle(color: locator<CometThemeManager>().theme.mainColor),),
          ),
          backgroundColor: user == null ? Colors.red : Colors.green,
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
                  // 'Latitude: ${model.currentLocation != null ? model.currentLocation.latitude : "nothing"}, Longitude: ${model.currentLocation != null ? model.currentLocation.longitude : "nothing"}',
                  'Latitude: ${model.location != null ? model.location.latitude : "nothing"}, Longitude: ${model.location != null ? model.location.longitude : "nothing"}',
                ),
                Text(
                  '${model.count}',
                  style: Theme.of(context).textTheme.display1,
                ),
                FlatButton(
                  onPressed: model.increment,
                  child: Text('increment')
                ),
                FlatButton(
                  onPressed: model.signOut,
                  child: Text('sign out')
                ),
                Hero(
                  tag: 'backdrop',
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
