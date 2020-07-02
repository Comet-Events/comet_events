import 'package:comet_events/core/objects/EventFilters.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/theme/theme.dart';
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
  EventFilters currentFilters;

  FilterModel({
    this.currentFilters
  });

  // * ------ SERVICES ------
  TagsService _tags = locator<TagsService>();
  NavigationService _navigate = locator<NavigationService>();
  SnackbarService _snack = locator<SnackbarService>(); // yum
  CometThemeData _appTheme = locator<CometThemeManager>().theme;

  // * ----- VARS -------  
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

  //at top of filter screen build
  void fetchCategories() async {
    categories = await _tags.fetchCategories();
    notifyListeners();
  }
  
  //get rid of this
  void cometSnackBar({String title, String message, IconData iconData = Icons.error, Duration duration = const Duration(seconds: 8)}) {
    _snack.showCustomSnackBar(
      title: title,
      message: message,
      icon: Icon(iconData),
      duration: duration,
      borderRadius: 15,
      shouldIconPulse: true,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: _appTheme.secondaryMono,
      borderColor: _appTheme.mainMono
    );
  }
  
  //validator
  bool isValid(){
    double minDistance = 0.25;    
    Duration snackDuration = Duration(seconds: 10);

    if(activeFilters.distanceRadius < minDistance) {
      cometSnackBar(
        title: "Distance Invalid",
        message: "The distance radius you've chosen is invalid! It should be at least $minDistance miles.",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    }
    // * time check
    if(newStartDate.isSameDate(newEndDate)) {
      cometSnackBar(
        title: "Dates Invalid",
        message: "Your start and end dates cannot be the same!",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    } else if(newStartDate.compareTo(newEndDate) > 0) {
      cometSnackBar(
        title: "Start Date Invalid",
        message: "Your start date can't be after your end date genius smh",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    } 

    return true;
  }

  //reset button
  void resetFilters(){
    activeFilters = newFilters = defaultFilters;
    notifyListeners();
    print('hasta luego');
  }
  
  //apply filters button
  void applyFilters(){
    // configure dates
    newStartDate = newStartDate.add(Duration(hours: newStartTime.hour, minutes: newStartTime.minute));
    newEndDate = newEndDate.add(Duration(hours: newEndTime.hour, minutes: newEndTime.minute));

    //update newFilters to have correct time
    newFilters.startTime = newStartDate;
    newFilters.endTime = newEndDate;

    //validate
    bool valid = isValid();
    // if not valid reset date values to prevent time from stacking, and return
    if(!valid) {
      newStartDate = newStartDate.resetToDayStart();
      newEndDate = newEndDate.resetToDayStart();
      return;
    }

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