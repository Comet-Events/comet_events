import 'dart:async';

import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        builder: (context, model, user, child) => Scaffold(
          body: Center(
            // Here we take the value from the HomeScreen object that was created by
            // the App.build method, and use it to set our appbar title.
            child: Stack(
              children: <Widget>[
                Map(),
                Column(
                  children: <Widget>[
                    topAppBar(),
                    Row(
                      children: <Widget>[
                        //searchBar(),
                        Spacer(),
                        filterButton()
                      ],
                    ),
                    Spacer(),
                    eventCarousel(),
                    bottomAppBar()
                  ],
                ),
              ],
            )
          ),
          backgroundColor: locator<CometThemeManager>().theme.secondaryMono,
          // body: Center(
          //   // Center is a layout widget. It takes a single child and positions it
          //   // in the middle of the parent.
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Switch(
          //         value: _state, 
          //         onChanged: (bool) {
          //           if(bool == false) locator<CometThemeManager>().changeToDark();
          //           else locator<CometThemeManager>().changeToLight();

          //           setState(() {
          //             _state = !_state;
          //           });
          //         }
          //       ),
          //       Text(
          //         'You have pushed the button this many times:',
          //       ),
          //       Text(
          //         '${model.count}',
          //         style: Theme.of(context).textTheme.display1,
          //       ),
          //       FlatButton(
          //         onPressed: model.increment,
          //         child: Text('increment')
          //       ),
          //       FlatButton(
          //         onPressed: model.signOut,
          //         child: Text('sign out')
          //       ),
          //     ],
          //   ),
          // ),
      ),
    );
  }

  Widget topAppBar(){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 40, 30, 5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0)
        ),
        color: locator<CometThemeManager>().theme.mainMono
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            color: locator<CometThemeManager>().theme.mainColor,
            //go to settings
            onPressed: () {}
          ),
          Text(
            'WELCOME, YOLANDA',
            style: TextStyle(
              fontFamily: "Lexend Deca",
              fontSize: 18,
            )
          ),
          FlutterLogo( size: 30 )
        ],
      )
    );
  }

  Widget searchBar(){
    return Scaffold(
      body: Center(
        child: SearchMapPlaceWidget(
          apiKey: "AIzaSyCsCCifR33W3czEgjQttCs4sMA825zMvhc"
        )
      )
  );
  }
  
  Widget bottomAppBar(){
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: locator<CometThemeManager>().theme.mainMono,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      size: 50,
                      color: locator<CometThemeManager>().theme.mainColor,
                    ),
                    Text(
                      'Fwends',
                      style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      size: 50,
                      color: locator<CometThemeManager>().theme.mainColor,
                    ),
                    Text(
                      'Mwessages',
                      style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)
                    )
                  ],
                ),
              )
            ],
          )
        ), 
        Center(
          child: Positioned(
            top: -20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: locator<CometThemeManager>().theme.mainColor
              ),
              child: GestureDetector(
                //add event
                onTap: (){},
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 65
                ),
              )
            ),
          ),
        )
      ],
    );
  }

  Widget filterButton(){
    return GestureDetector(
      onTap: (){}, //go to filter page
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: locator<CometThemeManager>().theme.secondaryMono,
          border: Border.all(
            color: locator<CometThemeManager>().theme.mainMono,
            width: 2.0
          )
        ),
        child: Icon( Icons.list, color: locator<CometThemeManager>().theme.mainColor, size: 30 )
      )
    );
  }

  Widget eventCarousel(){
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: CarouselSlider(
        items: [1,2,3,4,5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: locator<CometThemeManager>().theme.mainMono
                ),
                child: Text('text $i', style: TextStyle(fontSize: 16.0),)
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 80,
          autoPlay: false
        ),      
      ),
    );
  }
}

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}
class MapState extends State<Map> {
  
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-50.606805, 165.972134),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(-50.606805, 165.972134),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
