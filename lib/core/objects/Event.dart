import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String name;
  String description;
  List<String> instructions;
  String host;
  bool active;
  Dates dates;
  List<String> tags;
  String category;
  Stats stats;
  Location location;
  Settings settings;

  Event(
      {this.name,
      this.description,
      this.instructions,
      this.host,
      this.active,
      this.dates,
      this.tags,
      this.category,
      this.stats,
      this.location,
      this.settings});

  Event.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "Untitled Event";
    description = json['description'] ?? "This event has no description...";
    instructions = json['instructions'].cast<String>() ?? [];
    host = json['host'];
    active = json['active'] ?? true;
    dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
    tags = json['tags'].cast<String>() ?? [];
    category = json['category'];
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
    data['name'] = this.name;
    data['description'] = this.description;
    data['host'] = this.host;
    data['active'] = this.active;
    if (this.dates != null) {
      data['dates'] = this.dates.toJson();
    }
    data['tags'] = this.tags;
    data['category'] = this.category;
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
  String text;

  Address({this.text});

  Address.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text ?? "";
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