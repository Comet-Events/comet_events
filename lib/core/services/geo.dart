import 'package:comet_events/core/services/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoService extends DatabaseService {

  Geoflutterfire _geo = Geoflutterfire();
  Geoflutterfire get geo => _geo;
  
}