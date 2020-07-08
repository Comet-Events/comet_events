
import 'dart:io';

import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'package:comet_events/ui/widgets/location_marker.dart';
import 'dart:ui' as ui;
import 'package:file_cache/file_cache.dart';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> with SingleTickerProviderStateMixin{
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];
  int numMarkers = 0;

  bool isImageloaded = false;

  ValueNotifier<String> countdown = ValueNotifier("loading...");

  Size _animationFraction = Size(130, 154);
  Animation<Size> widgetAnimation;
  AnimationController widgetAnimationController;
  
  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_styles/pretty.txt').then((string) {
      _mapStyle = string;
    });

    addMarker('https://picsum.photos/200', LatLng(29.722151, -95.389622), 'myMarker');
    addMarker('https://picsum.photos/200', LatLng(29.704940, -95.425814), 'randalls');

    widgetAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500)
    );

    widgetAnimation = Tween(
      begin: Size(130, 154),
      end: Size(156, 185)
    ).animate(widgetAnimationController)
      ..addListener(() {
        setState((){
          _animationFraction = widgetAnimation.value;
        });
      })
      ..addStatusListener((status) {
        print( status );
      });
    // _startTimer(Duration(hours: 1));
  }

  @override
  void dispose(){
    widgetAnimationController.dispose();
    super.dispose();
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
            // Positioned(
            //   top: 100,
            //   left: MediaQuery.of(context).size.width * 0.05,
            //   child: GestureDetector(
            //     onTap: (){ moveToRandalls(); },
            //     child: Container(
            //       color: locator<CometThemeManager>().theme.mainMono,
            //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            //       child: Text('Go to Randalls!')
            //     )
            //   ),
            // ),
            // Positioned(
            //   top: 200,
            //   left: MediaQuery.of(context).size.width * 0.05,
            //   child: GestureDetector(
            //     onTap: deanimateMarker,
            //     child: Container(
            //       color: locator<CometThemeManager>().theme.mainMono,
            //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            //       child: Text('Kill me now!')
            //     )
            //   ),
            // ),
          ],
        )
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
  
  // CountdownFormatted _startTimer(Duration _duration){
  //   return CountdownFormatted(
  //     duration: _duration,
  //     builder: (BuildContext context, String remaining){
  //       setState(() {
  //         countdown.value = remaining;
  //       });
  //       print('hiii ' + remaining);
  //       return Text(remaining);
  //     }
  //   );
  // }

  void addMarker(String imageURL, LatLng position, String markerId) async{
    final Uint8List bitmap = await getMarkerIcon(imageURL, Size(130, 154));
    
    allMarkers.add(Marker(
      markerId: MarkerId(markerId),
      position: position ,
      icon: BitmapDescriptor.fromBytes(bitmap),
      // onTap: () {
        // print('blast off');
        // widgetAnimationController.forward();
        // animateMarker(imageURL, _animationFraction, Duration(milliseconds: 10), position);
      // },
    ));
  }

  Future<ui.Image> _initImage(String imageURL) async {
    // http.Response response = await http.get(imageURL);   
    // return await loadImage( response.bodyBytes );

    // File file = await DefaultCacheManager().getSingleFile(imageURL);
    // FileImage im = FileImage(file);
    // Uint8List bytes = (await rootBundle.load(${thisismeltingmyfuckingbrain})).buffer.asUint8List();
    // return await loadImage(bytes);
    
    FileCache fileCache = await FileCache.fromDefault();
    Uint8List bytes = await fileCache.getBytes(imageURL);
    return _loadImage(bytes);
  }

  //converts img to ui.Image
  Future<ui.Image> _loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
         isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  //this will also eventually need to take in a duration, since every marker has a diff timer
  Future<Uint8List> getMarkerIcon(String imageURL, Size widgetSize) async{
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    //  final Size widgetSize = Size(130, 154);
    
    //create custompainter
    MarkerPainter myPainter = MarkerPainter(
      // time: countdown,
      image: await _initImage(imageURL),
      // image: CachedNetworkImage(),
      markerSize: widgetSize
    );

    //paint a pwetty pwicture
    myPainter.paint(canvas, widgetSize);

    //get image
    final ui.Image markerAsImage = await recorder.endRecording().toImage(widgetSize.width.round(), widgetSize.height.round());

    //convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
  
  
  Future<void> animateMarker(String imageURL, Size markerSize, Duration duration, LatLng position) async {
    Timer timer = new Timer.periodic(duration, (timer) async {
      // print('hola');
      final Uint8List bitmap = await getMarkerIcon(imageURL, markerSize);
      getMarkerIcon(imageURL, markerSize);
  
      allMarkers.add(Marker(
        markerId: MarkerId(imageURL),
        position: position ,
        icon: BitmapDescriptor.fromBytes(bitmap),
      ));
      // numMarkers++;s

      // if( markerSize >= Size(156, 185) )
      //   timer.cancel();
    });
  }

  // Future<void> deanimateMarker(){
  //   while( numMarkers != 0)
  //     allMarkers.removeLast();
  // }
}