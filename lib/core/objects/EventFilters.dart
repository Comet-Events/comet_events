import 'package:flutter/material.dart';

class EventFilters{
  double radius;
  DateTime startRangeStart;
  DateTime startRangeEnd;
  DateTime endRangeStart;
  DateTime endRangeEnd;

  // last time updated
  DateTime originalDay;
  DateTime lastUpdated;

  List<String> tags;
  List<String> categories;

  EventFilters({
    this.radius = 20,
    this.tags,
    this.categories
  }){
      this.tags = this.tags ?? [];
      this.categories = this.categories ?? [];
      this.lastUpdated = this.originalDay = DateTime.now();
    }

  Map<String, dynamic> get map{
    return{
      "radius": radius,
      "startRangeStart": startRangeStart,
      "startRangeEnd": startRangeEnd,
      "endRangeStart": endRangeStart,
      "endRangeEnd": endRangeEnd,
      "tags": tags,
      "categories": categories
    };
  }  
}