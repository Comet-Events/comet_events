import 'dart:async';
import 'package:location/location.dart';

class LocationService {

  LocationData currentLocation;
  PermissionStatus _permission;
  var location = Location();

  // * ~~~~~~~ STREAMS ~~~~~~~
  StreamSubscription<LocationData> _subscription;
  StreamController<LocationData> _locationController = StreamController<LocationData>.broadcast();
  Stream<LocationData> get locationStream => _locationController.stream;

  Future<LocationSetupResponse> setup() async {
    // Setup needs to run frequently.
    LocationSetupResponse _response = await checkService();

    if(!_response.issue) {
      if(_subscription != null) await _subscription.cancel();
      _subscription = location.onLocationChanged().listen((locationData) {
        if (locationData != null) {
          _locationController.add(locationData);
          currentLocation = locationData;
        }
      });
    }
    return _response;
  }

  Future<LocationData> getLocation() async {
    await setup();
    try {
      var userLocation = await location.getLocation();
      currentLocation = userLocation;
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return currentLocation;
  }

  // * ------ service activation and checking ------

  Future<LocationSetupResponse> checkService() async {
    bool _enabled = await serviceEnabled();
    if(!_enabled) return LocationSetupResponse(
      serviceEnabled: false,
      permissionGranted: false,
      issue: true
    );

    bool _granted = await permissionGranted();
    if(!_granted) return LocationSetupResponse(
      serviceEnabled: true,
      permissionGranted: false,
      issue: true
    );

    return LocationSetupResponse(
      serviceEnabled: true,
      permissionGranted: true,
      issue: false,
    );
  }

  Future<bool> serviceEnabled() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> permissionGranted() async {
    _permission = await location.hasPermission();
    if (_permission == PermissionStatus.DENIED) {
      _permission = await location.requestPermission();
      if (_permission != PermissionStatus.GRANTED) {
        return false;
      }
    }
    return true;
  }

}

class LocationSetupResponse {
  final bool serviceEnabled;
  final bool permissionGranted;
  final bool issue;

  LocationSetupResponse({this.serviceEnabled, this.permissionGranted, this.issue});
}