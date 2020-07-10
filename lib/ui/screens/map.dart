import 'dart:io';
import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:countdown/countdown.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
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
  // //is this right lmao
  // HomeMapController controller = HomeMapController();

  // HomeMap( this.controller );

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
  String mapStyle;
  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};
  // Map<MarkerId, CountDown> allTimers = <MarkerId, CountDown>{};
  // Map<MarkerId, Size> allSizes = <MarkerId, Size>{};

  Map<MarkerId, MarkerEntry> allEntries = <MarkerId, MarkerEntry>{};
  Size minSize = Size(130, 154);
  Size maxSize = Size(156, 185);
  // Size currentSize = Size(130, 154);
  // Animation<Size> bloopAnimation;
  // AnimationController bloopAnimationController;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_styles/pretty.txt').then((string) {
      mapStyle = string;
    });

    _addMarker('https://picsum.photos/200', LatLng(29.722151, -95.389622),'myMarker', Duration(hours: 1, minutes: 1));
    _addMarker('https://picsum.photos/200', LatLng(29.704940, -95.425814), 'randalls', Duration(minutes: 30));

    // bloopAnimationController = AnimationController(
    //   duration: Duration(milliseconds: 1500),
    //   vsync: this
    // );

    // bloopAnimation = Tween<Size>(
    //   begin: Size(130, 154),
    //   end: Size(156, 185)
    // ).animate(bloopAnimationController);

  }

  @override
  Widget build(BuildContext context) {
    return UserViewModelBuilder<HomeModel>.reactive(
      userViewModelBuilder: () => HomeModel(),
      builder: (context, model, user, child) =>Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              GoogleMap(
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                markers: Set<Marker>.of(allMarkers.values),
                initialCameraPosition: _kHome,
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                  controller.setMapStyle(mapStyle);
                },
                onTap: (LatLng pos){
                  allEntries.forEach((key, value) {
                    if( allEntries[key].currentSize != minSize ){
                      setState(() {
                        allEntries[key].currentSize = minSize;
                      });
                    }
                    _updateMarker(allEntries[key]);
                  });
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
        ),
    );
  }

  // @override
  // void dispose(){
  //   bloopAnimationController.dispose();
  //   super.dispose();
  // }

  static final CameraPosition _kHome = CameraPosition(
    target: LatLng(29.722151, -95.389622),
    //target: LatLng(-50.606805, 165.972134),
    zoom: 14.746,
  );

  Future<void> _moveToRandalls() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(29.704940, -95.425814), zoom: 14.760)));
  }

  //first time marker? <-- haha jokes
  void _addMarker(String imageURL, LatLng position, String markerId, Duration duration) async {
    final id = MarkerId(markerId); 
    ValueNotifier<String> countdown = ValueNotifier("loading...");
    
    //create countdown for marker <--will persist through marker updates
    CountDown cd = CountDown(duration);
    var sub = cd.stream.listen(null);

    MarkerEntry newEntry = MarkerEntry(id, imageURL, cd, countdown, position);
    Marker newMarker = await _createMarker(newEntry);

    setState(() {
      allMarkers[id] = newMarker;
      allEntries[id] = newEntry;
    });
    
    sub.onData((Duration d) {
      //update display string and redraw marker at this position accordingly
      if( countdown.value != _getDurationString(d)){
        countdown.value = _getDurationString(d);
        _updateMarker(newEntry);
      }
    });

    sub.onDone(() {
      countdown.value = "Live!";
      _updateMarker(newEntry);
      sub.cancel();
    });
    
    // final Uint8List bitmap = await _getMarkerIcon(imageURL, countdown, minSize);

    // Marker newMarker = Marker(
    //   markerId: id,
    //   position: position,
    //   icon: BitmapDescriptor.fromBytes(bitmap),
    //   onTap: () {
    //     // _animateMarker(id, imageURL, position, countdown);
    //      setState(() {
    //        allEntries[id].currentSize = maxSize;
    //      }); 
    //     _updateMarker(id, imageURL, position, countdown);
    //   },
    // );
    // MarkerEntry newEntry = MarkerEntry(id, imageURL, cd, position);
    // Marker newMarker = await _createMarker(newEntry, countdown);

    // setState(() {
    //   allMarkers[id] = newMarker;
    //   allEntries[id] = newEntry;
    // });
  }
 
  //to repaint a marker when its timer changes or onTap
  void _updateMarker(MarkerEntry entry) async {
    print('update');

    Marker newMarker = await _createMarker(entry);
    setState(() {
      allMarkers[entry.markerId] = newMarker;
    });
  }

  Future<Marker> _createMarker(MarkerEntry entry) async{
    final Uint8List bitmap = await _getMarkerIcon(entry.imageURL, entry.countdown, entry.currentSize);
    
    return Marker(
      markerId: entry.markerId,
      position: entry.position,
      icon: BitmapDescriptor.fromBytes(bitmap),
      onTap: (){
        setState(() {
          allEntries[entry.markerId].currentSize = maxSize;
        });
        _updateMarker(entry);
      }
    );
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

  //draws marker and saves as image
  Future<Uint8List> _getMarkerIcon(String imageURL, ValueNotifier<String> countdown, Size markerSize) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    // final Size widgetSize = Size(130, 154);

    //create custompainter
    MarkerPainter myPainter = MarkerPainter(
      time: countdown,
      image: await _initImage(imageURL),
      markerSize: markerSize
    );

    //paint a pwetty pwicture
    myPainter.paint(canvas, markerSize);

    //get image
    final ui.Image markerAsImage = await recorder
        .endRecording()
        .toImage(markerSize.width.round(), markerSize.height.round());

    //convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  } 

  // void _animateMarker(MarkerId id, String imageURL, LatLng position, ValueNotifier<String> countdown){
  //   print('animation started');
  //   bloopAnimationController.forward();
  //   print(bloopAnimationController.status);
  //   while( bloopAnimationController.status != AnimationStatus.completed ){
  //     _updateMarker(id, imageURL, position, countdown);
  //   }
  //     // print(bloopAnimationController.status);
  // }

}

class MarkerEntry{
  MarkerId markerId = MarkerId('hello');
  String imageURL = "";
  CountDown cd;
  LatLng position = LatLng(0,0);
  ValueNotifier<String> countdown = ValueNotifier("loading...");
  Size currentSize = Size(130, 154);

  MarkerEntry(
    MarkerId markerId,
    String imageURL,
    CountDown cd,
    ValueNotifier<String> countdown,
    LatLng position
  ) : markerId = markerId, position = position, cd = cd, countdown = countdown, imageURL = imageURL;

}