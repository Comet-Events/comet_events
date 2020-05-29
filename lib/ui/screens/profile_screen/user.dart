import 'package:flutter/material.dart';

class User {
  String name;
  String location;
  String description;
  Image profilePic;
  List<String> followers;
  List<String> events;
  List<String> following;

  User({
  @required this.name,
  this.location,
  this.description,
  this.profilePic,
  this.followers,
  this.events,
  this.following,
  });

  String get getName{
    return name;
  }

  String get getLocation{
    return location;
  }

  String get getDescription{
    return description;
  }

  Image get getProfilePic{
    return profilePic;
  }

  List<String> get getFollowers{
    return followers;
  }

  List<String> get getFollowing{
    return following;
  }

  List<String> get getEvents{
    return events;
  }
}