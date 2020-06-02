import 'dart:async';

import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key,}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _state = false;
  List<EventTile> events = [
    EventTile(imageURL: 'https://picsum.photos/200',
     title: 'Fwood Pwarty', date: 'January 9, 1876', category: 'Food', tags: ['Fun', 'Cool', 'Fresh'], description: 'Free buffet for all'),
    EventTile(imageURL: 'https://picsum.photos/200', title: "Neha's the best", date: 'Everyday', category: 'Relegious', tags: ['True', 'Words', 'to' ,'Live', 'By'], description: 'Rare chance to hangout wiht the best person on earth!'),
  ];

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
      ),
    );
  }

  Widget topAppBar(){
    return Container(
      height: MediaQuery.of(context).size.height*0.12,
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
  
  Widget bottomAppBar(){
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.10,
          decoration: BoxDecoration(
            color: locator<CometThemeManager>().theme.mainMono,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
          padding: EdgeInsets.fromLTRB(60, 5, 60, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 2.0,
                          left: 2.0,
                          child: Icon(
                            Icons.people,
                            size: 50,
                            color: Colors.black26,
                          ),
                        ),
                        Icon(Icons.people, size: 50,color: locator<CometThemeManager>().theme.mainColor )
                      ],
                    ),
                    Text('Fwends', style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 2.0,
                          left: 2.0,
                          child: Icon(
                            Icons.message,
                            size: 50,
                            color: Colors.black26,
                          ),
                        ),
                        Icon(Icons.message, size: 50,color: locator<CometThemeManager>().theme.mainColor )
                      ],
                    ),
                    Text('Mwessages', style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)),
                  ],
                ),
              )
            ],
          )
        ), 
        Positioned(
          top: -20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [locator<CometThemeManager>().theme.mainColor, CometThemeManager.mainColorDark]
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3)
                )
              ]
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
        child: Icon(Icons.filter_list, color: locator<CometThemeManager>().theme.mainColor, size: 30 )
      )
    );
  }

  Widget eventCarousel(){
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: CarouselSlider(
        items: events.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                child: i,
                padding: EdgeInsets.symmetric(horizontal: 3),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height*0.12,
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
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  static final CameraPosition _kHome = CameraPosition(
    //target: LatLng(29.722151, -95.389622),
    target: LatLng(-50.606805, 165.972134),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body:
        Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _kHome,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(_mapStyle);
              },
            ),
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width * 0.05,
              child: SearchMapPlaceWidget(
                darkMode: true,
                apiKey: Theme.of(context).platform == TargetPlatform.iOS ? "AIzaSyDgldMROs1VzrXoEiCfurKutmOps1sJR-8" : "AIzaSyAeD2KtPAnoJJXvINv6ZYUzLvmZTff406M",
                onSelected: (place) async {
                  final geolocation = await place.geolocation;
                  final GoogleMapController controller = await _controller.future;
                  controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                  controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
            ),
          ],
        )
    );
  }  
}
