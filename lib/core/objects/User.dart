import 'dart:core';

class User {
  String uid;
  UserName name;
  bool organization;
  String description;
  String pfpUrl;
  List<String> followers;
  List<String> following;
  UserEvents events;

  static const defaultPfp = 'https://i.ibb.co/YfD2TCk/nopfp.png';

  User({
    this.uid,
    this.name,
    this.organization = false,
    this.description,
    this.pfpUrl = defaultPfp,
    this.followers,
    this.following,
    this.events
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'] != null ? new UserName.fromJson(json['name']) : null;
    organization = json['organization'] ?? false;
    description = json['description'] ?? "";
    pfpUrl = json['pfpUrl'] ?? defaultPfp;
    followers = json['followers'].cast<String>() ?? [];
    following = json['following'].cast<String>() ?? [];
    events =
        json['events'] != null ? new UserEvents.fromJson(json['events']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    } else data['name'] = UserName().toJson();
    data['organization'] = this.organization ?? false;
    data['description'] = this.description ?? "";
    data['pfpUrl'] = this.pfpUrl ?? defaultPfp;
    data['followers'] = this.followers ?? [];
    data['following'] = this.following ?? [];
    if (this.events != null) {
      data['events'] = this.events.toJson();
    } else data['events'] = UserEvents().toJson();
    return data;
  }
}

class UserName {
  String first;
  String last;
  String company;

  UserName({this.first = "", this.last = "", this.company = ""});

  UserName.fromJson(Map<String, dynamic> json) {
    first = json['first'] ?? "";
    last = json['last'] ?? "";
    company = json['company'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first ?? "";
    data['last'] = this.last ?? "";
    data['company'] = this.company ?? "";
    return data;
  }
}

class UserEvents {
  List<String> hosted;
  List<String> attended;
  List<String> liked;

  UserEvents({this.hosted, this.attended, this.liked});

  UserEvents.fromJson(Map<String, dynamic> json) {
    hosted = json['hosted'].cast<String>() ?? [];
    attended = json['attended'].cast<String>() ?? [];
    liked = json['liked'].cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hosted'] = this.hosted ?? [];
    data['attended'] = this.attended ?? [];
    data['liked'] = this.liked ?? [];
    return data;
  }
}