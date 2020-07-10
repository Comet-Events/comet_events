import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Event {
  String name;
  String description;
  List<String> instructions;
  String host;
  bool active;
  Dates dates;
  List<String> tags;
  List<String> categories;
  Stats stats;
  Location location;
  List<Asset> images;
  Asset coverImage;
  Settings settings;

  Event(
      {this.name = "",
      this.description,
      this.instructions,
      this.host,
      this.active,
      this.dates,
      this.tags,
      this.categories,
      this.stats,
      this.location,
      this.settings}) {
        this.tags = [];
        this.categories = [];
      }

  Event.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "Untitled Event";
    description = json['description'] ?? "This event has no description...";
    instructions = json['instructions'].cast<String>() ?? [];
    host = json['host'];
    active = json['active'] ?? true;
    dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
    tags = json['tags'].cast<String>() ?? [];
    categories = json['categories'].cast<String>() ?? [];
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name ?? "";
    data['description'] = this.description ?? "";
    data['host'] = this.host ?? "";
    data['active'] = this.active ?? false;
    if (this.dates != null) {
      data['dates'] = this.dates.toJson();
    }
    data['tags'] = this.tags ?? [];
    data['categories'] = this.categories ?? [];
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    return data;
  }
}

class Dates {
  Timestamp premiere;
  Timestamp start;
  Timestamp end;

  Dates({this.premiere, this.start, this.end});

  Dates.fromJson(Map<String, dynamic> json) {
    premiere = json['premiere'] as Timestamp;
    start = json['start'] as Timestamp;
    end = json['end'] as Timestamp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['premiere'] = this.premiere;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class Stats {
  List<String> rsvps;
  List<String> likes;

  Stats({this.rsvps, this.likes});

  Stats.fromJson(Map<String, dynamic> json) {
    rsvps = json['rsvps'].cast<String>() ?? [];
    likes = json['likes'].cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rsvps'] = this.rsvps ?? [];
    data['likes'] = this.likes ?? [];
    return data;
  }
}

class Location {
  Geo geo;
  Address address;

  Location({this.geo, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geo != null) {
      data['geo'] = this.geo.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Geo {
  String geohash;
  GeoPoint geopoint;

  Geo({this.geohash, this.geopoint});

  Geo.fromJson(Map<String, dynamic> json) {
    geohash = json['geohash'];
    geopoint = json['geopoint'] as GeoPoint;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geohash'] = this.geohash;
    data['geopoint'] = this.geopoint;
    return data;
  }
}

class Address {
  String fullAddress;
  String fullStreet;
  String streetNum;
  String street;
  String city;
  String state;
  String country;

  Address({
    this.fullAddress, 
    this.fullStreet, 
    this.streetNum, 
    this.street, 
    this.city, 
    this.state, 
    this.country
  });

  Address.fromJson(Map<String, dynamic> json) {
    fullAddress = json['fullAddress'] ?? "";
    fullStreet = json['fullStreet'] ?? "";
    streetNum = json['streetNum'] ?? "";
    street = json['street'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? null;
    country = json['country'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullAddress'] = this.fullAddress ?? "";
    data['fullStreet'] = this.fullStreet ?? "";
    data['streetNum'] = this.streetNum ?? "";
    data['street'] = this.street ?? "";
    data['city'] = this.city ?? "";
    data['state'] = this.state ?? null;
    data['country'] = this.country ?? "";
    return data;
  }
}

class Settings {
  bool followersOnly;
  bool hideOnStart;
  bool hideRSVPs;

  Settings({this.followersOnly, this.hideOnStart, this.hideRSVPs});

  Settings.fromJson(Map<String, dynamic> json) {
    followersOnly = json['followersOnly'] ?? false;
    hideOnStart = json['hideOnStart'] ?? false;
    hideRSVPs = json['hideRSVPs'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followersOnly'] = this.followersOnly ?? false;
    data['hideOnStart'] = this.hideOnStart ?? false;
    data['hideRSVPs'] = this.hideRSVPs ?? false;
    return data;
  }
}