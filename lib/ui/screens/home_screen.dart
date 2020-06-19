import 'dart:typed_data';

import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/location_marker.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key,}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _state = false;
  CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: UserViewModelBuilder<HomeModel>.reactive(
        userViewModelBuilder: () => HomeModel(),
        builder: (context, model, user, child) => Stack(
          children: <Widget>[
            Map(),
            Column(
              children: <Widget>[
                _topAppBar(),
                SizedBox(height: 7),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _searchWidget(),
                    ],
                  )
                ),
                // Container(
                //   //65x77
                //   width: 130,
                //   height: 154, 
                //   child: 
                //     isImageloaded ? 
                //     CustomPaint(
                //       painter: MarkerPainter(
                //         time: countdown,
                //         image: image,
                //         markerScale: 2
                //       )
                //     ) : 
                //     Text('loading')
                // ),
                // _startTimer( Duration(hours: 1)),
                SizedBox(height: 135),
                _eventCarousel(model),
                SizedBox(height: 35),
                _bottomAppBar(),
                SafeArea(child: Container(), top: false)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _topAppBar(){
    return Container(
      // height: MediaQuery.of(context).size.height*0.12,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0)
        ),
        color: locator<CometThemeManager>().theme.mainMono
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.settings, 
              size: 30, 
              color: locator<CometThemeManager>().theme.mainColor,
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
        ),
      )
    );
  }
  
  Widget _bottomAppBar(){
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          // height: MediaQuery.of(context).size.height*0.10,
          decoration: BoxDecoration(
            color: locator<CometThemeManager>().theme.mainMono,
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.only(bottom: 10, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  // alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){},
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.people, size: 50,color: locator<CometThemeManager>().theme.mainColor ),
                        Text('Fwends', style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 50),
              Expanded(
                child: Container(
                  child: GestureDetector(
                    onTap: (){},
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.message, size: 44,color: locator<CometThemeManager>().theme.mainColor ),
                        Text('Mwessages', style: TextStyle(color: locator<CometThemeManager>().theme.mainColor)),
                      ],
                    ),
                  ),
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
                center: Alignment(-0.5,-0.5),
                // center: Alignment.center,
                radius: 1,
                colors: [
                  CometThemeManager.lighten(locator<CometThemeManager>().theme.mainColor, 0.1), 
                  locator<CometThemeManager>().theme.mainColor, 
                  CometThemeManager.darken(locator<CometThemeManager>().theme.mainColor, 0.35)
                ]
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
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

  Row _searchWidget() {
    return Row(
      children: <Widget>[
        // SearchBar<String>(
        //   onSearch: (s) {},
        //   onItemFound: (string, inte) {},
        // ),
        Spacer(),
        GestureDetector(
          onTap: (){
            HomeModel().moveToFilterScreen();
          }, //go to filter page
          child: Hero(
            tag: 'filterIcon',
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _appTheme.secondaryMono,
                border: Border.all(
                  color: _appTheme.mainMono,
                  width: 2.0
                )
              ),
              child: Icon(MdiIcons.filter, color: _appTheme.mainColor, size: 30 )
            ),
          )
        )
      ],
    );
  }

  Widget _eventCarousel(HomeModel model){
    return Container(
      child: CarouselSlider(
        items: model.events.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                child: i,
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 90*1.2,
          viewportFraction: 0.84,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          enlargeCenterPage: true,
          onPageChanged: (number, reason) {
            //update google maps camera position
          },
          scrollDirection: Axis.horizontal,
        )  
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
  List<Marker> allMarkers = [];

  bool isImageloaded = false;

  ValueNotifier<String> countdown = ValueNotifier("loading...");
  
  @override
  void initState() {
    super.initState();
    _initMarkers();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    
    //this is doing literally nothing very cool very freh
    _startTimer(Duration(hours: 1));
  
  }

  _initMarkers() async{
    final bitmap = await getMarkerIcon( 'https://picsum.photos/200' );
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      position: LatLng(29.722151, -95.389622) ,
      icon: BitmapDescriptor.fromBytes(bitmap)
    ));

    allMarkers.add(Marker(
      markerId: MarkerId('randalls'),
      position: LatLng(29.704940, -95.425814),
      icon: BitmapDescriptor.fromBytes(bitmap)
    ));
  }


  Future<ui.Image> initImage(String imageURL) async {
    http.Response response = await http.get(imageURL);   
    return await loadImage( response.bodyBytes );
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Uint8List> getMarkerIcon(String imageURL) async{
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Size widgetSize = Size(130, 154);
    
    //create custompainter
    MarkerPainter myPainter = MarkerPainter(
      time: countdown,
      image: await initImage(imageURL),
      scale: 2
    );

    //paint a pwetty pwicture
    myPainter.paint(canvas, widgetSize);

    //get image
    final ui.Image markerAsImage = await recorder.endRecording().toImage(widgetSize.width.round(), widgetSize.height.round());

    //convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
  
  CountdownFormatted _startTimer(Duration _duration){
    return CountdownFormatted(
      duration: _duration,
      builder: (BuildContext context, String remaining){
        countdown.value = remaining;
        return Text(remaining);
      }
    );
  }


  static final CameraPosition _kHome = CameraPosition(
    target: LatLng(29.722151, -95.389622),
    //target: LatLng(-50.606805, 165.972134),
    zoom: 14.746,
  );

  Future<void> moveToRandalls() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(29.704940, -95.425814), zoom: 14.760)
    ));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body:
        Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: Set.from(allMarkers),
              initialCameraPosition: _kHome,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(_mapStyle);
              },
            ),
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width * 0.05,
              child: GestureDetector(
                onTap: (){ moveToRandalls(); },
                child: Container(
                  color: locator<CometThemeManager>().theme.mainMono,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Text('Go to Randalls!')
                )
              )
              // child: SearchMapPlaceWidget(
              //   darkMode: true,
              //   apiKey: Theme.of(context).platform == TargetPlatform.iOS ? "AIzaSyDgldMROs1VzrXoEiCfurKutmOps1sJR-8" : "AIzaSyAeD2KtPAnoJJXvINv6ZYUzLvmZTff406M",
              //   onSelected: (place) async {
              //     final geolocation = await place.geolocation;
              //     final GoogleMapController controller = await _controller.future;
              //     controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
              //     controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              //   },
              // ),
            ),
          ],
        )
    );
  }  
}
