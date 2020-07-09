import 'dart:io';
import 'package:countdown/countdown.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:comet_events/ui/widgets/location_marker.dart';
import 'dart:ui' as ui;
import 'package:file_cache/file_cache.dart';
import 'package:http/http.dart' as http;

class HomeMap extends StatefulWidget {
  //is this right lmao
  HomeMapController controller = HomeMapController();

  HomeMap( this.controller );

  @override
  State<HomeMap> createState() => HomeMapState();
}

//controller - idk if im doing this right
class HomeMapController{
  String mapStyle;
  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};
  Map<MarkerId, CountDown> allTimers = <MarkerId, CountDown>{};
}

class HomeMapState extends State<HomeMap> with SingleTickerProviderStateMixin {
  // String _mapStyle;
  // Completer<GoogleMapController> _controller = Completer();
  // Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};
  // Map<MarkerId, CountDown> allTimers = <MarkerId, CountDown>{};

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_styles/pretty.txt').then((string) {
      widget.controller.mapStyle = string;
    });

    _addMarker('https://picsum.photos/200', LatLng(29.722151, -95.389622),
        'myMarker', Duration(hours: 1, minutes: 1));
    _addMarker('https://picsum.photos/200', LatLng(29.704940, -95.425814),
        'randalls', Duration(minutes: 30));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: Set<Marker>.of(widget.controller.allMarkers.values),
              initialCameraPosition: _kHome,
              onMapCreated: (GoogleMapController controller) {
                widget.controller.mapController.complete(controller);
                controller.setMapStyle(widget.controller.mapStyle);
              },
            ),
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width * 0.05,
              child: GestureDetector(
                onTap: _moveToRandalls,
                child: Container(
                  color: locator<CometThemeManager>().theme.mainMono,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Text('Go to Randalls!')
                )
              ),
            ),
          ],
        )
      );
  }

  static final CameraPosition _kHome = CameraPosition(
    target: LatLng(29.722151, -95.389622),
    //target: LatLng(-50.606805, 165.972134),
    zoom: 14.746,
  );

  Future<void> _moveToRandalls() async {
    final GoogleMapController controller = await widget.controller.mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(29.704940, -95.425814), zoom: 14.760)));
  }

  //first time marker? <-- haha jokes
  void _addMarker(String imageURL, LatLng position, String markerId, Duration duration) async {
    final id = MarkerId(markerId); 
    ValueNotifier<String> countdown = ValueNotifier("loading...");
    
    CountDown cd = CountDown(duration);
    widget.controller.allTimers[id] = cd;
    var sub = cd.stream.listen(null);
    
    sub.onData((Duration d) {
      if( countdown.value != _getDurationString(d)){
        countdown.value = _getDurationString(d);
        _updateMarker(id, imageURL, position, countdown);
      }
    });

    sub.onDone(() {
      countdown.value = "Live!";
      _updateMarker(id, imageURL, position, countdown);
      sub.cancel();
    });
    
    final Uint8List bitmap = await _getMarkerIcon(imageURL, countdown);

    Marker newMarker = Marker(
      markerId: id,
      position: position,
      icon: BitmapDescriptor.fromBytes(bitmap),
    );

    setState(() {
      widget.controller.allMarkers[id] = newMarker;
    });
  }
 
  //to repaint a marker when its timer changes
  void _updateMarker(MarkerId markerId, String imageURL, LatLng position, ValueNotifier<String> updatedTime) async {
    print('update');
    final Uint8List bitmap = await _getMarkerIcon(imageURL, updatedTime);

    setState(() {
      widget.controller.allMarkers[markerId] = Marker(
        markerId: markerId,
        position: position,
        icon: BitmapDescriptor.fromBytes(bitmap)
      );
    });
  }

  //convert duration to hour accuracy
  String _getDurationString(Duration duration){
    if( duration.inMinutes > 60 && duration.inMinutes % 60 >= 30 )
      return "in ${duration.inHours.toString()} hours";
    else if( duration.inMinutes > 60 && duration.inMinutes % 60 < 30 )
      return "in ${(duration.inHours-1).toString()} hours";
    else if( duration.inHours == 1 )
      return "in ${duration.inHours.toString()} hour";
    else if (duration.inMinutes > 1 )
      return "in ${duration.inMinutes.toString()} mins";
    else return "in ${duration.inMinutes.toString()} min";
  }
  
  //converts img to ui.Image
  Future<ui.Image> _initImage(String imageURL) async {
    // http.Response response = await http.get(imageURL);
    // return await loadImage( response.bodyBytes );
    FileCache fileCache = await FileCache.fromDefault();
    Uint8List bytes = await fileCache.getBytes(imageURL);
    return _loadImage(bytes);
  }

  //helper function for _initImage
  Future<ui.Image> _loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  //this will also eventually need to take in a duration, since every marker has a diff timer
  Future<Uint8List> _getMarkerIcon(String imageURL, ValueNotifier<String> countdown) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Size widgetSize = Size(130, 154);

    //create custompainter
    MarkerPainter myPainter = MarkerPainter(
      time: countdown,
      image: await _initImage(imageURL),
      markerSize: widgetSize
    );

    //paint a pwetty pwicture
    myPainter.paint(canvas, widgetSize);

    //get image
    final ui.Image markerAsImage = await recorder
        .endRecording()
        .toImage(widgetSize.width.round(), widgetSize.height.round());

    //convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  } 

}