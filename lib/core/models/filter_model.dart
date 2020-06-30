import 'package:comet_events/core/objects/EventFilters.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

extension on DateTime{
  /// Checks if the dates are the same down to the minute
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day && this.hour == other.hour && this.minute == other.minute;
  }

  DateTime resetToDayStart() {
    return DateTime(this.year, this.month, this.day);
  }
}

class FilterModel extends ChangeNotifier{
  static EventFilters defaultFilters = new EventFilters(
    distanceRadius: 10.0,
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(days: 2))
  );
  EventFilters activeFilters = defaultFilters;
  EventFilters newFilters = new EventFilters();
  DateTime newStartDate;
  TimeOfDay newStartTime;
  DateTime newEndDate;
  TimeOfDay newEndTime;

  List<Tag> categories = [];

   // * ------ SERVICES ------
  TagsService _tags = locator<TagsService>();
  NavigationService _navigate = locator<NavigationService>();

  //at top of filter screen build
  void fetchCategories() async {
    categories = await _tags.fetchCategories();
    notifyListeners();
  }

  //validator
  bool isValid(){

  }

  //reset button
  void resetFilters(){
    newFilters = defaultFilters;
  }
  
  //apply filters button
  void applyFilters(){
    // configure dates
    newStartDate = newStartDate.add(Duration(hours: newStartTime.hour, minutes: newStartTime.minute));
    newEndDate = newEndDate.add(Duration(hours: newEndTime.hour, minutes: newEndTime.minute));

    //update newFilters to have correct time
    newFilters.startTime = newStartDate;
    newFilters.endTime = newEndDate;

    //set active filters for homescreen to be the new homescreen
    activeFilters = newFilters;

    //ET go homeeeeeee
    print('filters applied!');
    _navigate.popRepeated(1);
  }

  //on change handlers --thank you for like 99.9% of this code jafar
  distanceOnChange(double radius){ newFilters.distanceRadius = radius;}

  startDateOnChange(DateTime date) { newStartDate = date.resetToDayStart(); }
  startTimeOnChange(TimeOfDay time) { newStartTime = time; }
  endDateOnChange(DateTime date) { newEndDate = date.resetToDayStart(); }
  endTimeOnChange(TimeOfDay time) { newEndTime = time; }

  categoryOnChange(List<Tag> categories) { newFilters.categories = categories.map((e) => e.name).toList(); }
  tagsOnChange(List<String> tags) { newFilters.tags = tags; }

}