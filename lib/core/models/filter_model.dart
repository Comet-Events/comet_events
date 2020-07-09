import 'package:comet_events/core/objects/EventFilters.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/screens/filter_screen.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
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
    return DateTime(this.year ?? DateTime.now().year, this.month, this.day);
  }

  TimeOfDay getTimeOfDay() {
    return TimeOfDay(hour: this.hour, minute: this.minute);
  }

  TimeOfDay toTimeOfDay(DateTime now, {bool reduce = false}) {
    DateTime nowDay = now.resetToDayStart();
    DateTime dateDay = this.resetToDayStart();
    return (this.getTimeOfDay().toDouble() + (24*dateDay.difference(nowDay).inDays)).toTimeOfDay(reduce: reduce);
  }

  double toDouble(DateTime now) {
    DateTime nowDay = now.resetToDayStart();
    DateTime dateDay = this.resetToDayStart();
    return (this.getTimeOfDay().toDouble() + (24*dateDay.difference(nowDay).inDays));
  }
}

extension on TimeOfDay {
  double toDouble() => this.hour + this.minute/60.0;

  DateTime toDateTime(DateTime now) {
    DateTime day = now.resetToDayStart();
    TimeOfDay time = now.getTimeOfDay();
    if(time.toDouble() > this.toDouble()) {
      return day.add(Duration(days: 1, hours: this.hour, minutes: this.minute));
    }
    return day.add(Duration(hours: this.hour, minutes: this.minute));
  }
  bool isTomorrow(DateTime now) {
    TimeOfDay time = now.getTimeOfDay();
    if(time.toDouble() > this.toDouble()) {
      return true;
    }
    return false;
  }
}

extension on double {
  TimeOfDay toTimeOfDay({bool reduce = true}) {
    double val = this;
    while(val >= 24 && reduce) {
      val -= 24;
    }
    return TimeOfDay(hour: val.toInt(), minute: ((val - val.toInt())*60).toInt());
  }
}

class FilterModel extends ChangeNotifier{

  // * ------ SERVICES ------
  EventService _event = locator<EventService>(); // <- contains current filter
  TagsService _tags = locator<TagsService>();
  NavigationService _navigate = locator<NavigationService>();
  SnackbarService _snack = locator<SnackbarService>(); // yum
  CometThemeData _appTheme = locator<CometThemeManager>().theme;

  // * ----- VARS -------  
  bool loading = false;
  EventFilters get activeFilters => _event.filter.value;
  EventFilters newFilters = EventFilters();

  TimeOfDay rangeStart;
  TimeOfDay rangeEnd;
  DateTime rangeDay;

  TimeRangeController startController = TimeRangeController();
  TimeRangeController endController = TimeRangeController();
  CategoryPickerController categoryController = CategoryPickerController();
  TagPickerController tagController = TagPickerController();

  FilterModel() {
    if(activeFilters != null) newFilters = activeFilters;
    // define range variables
    rangeDay = DateTime.now();
    rangeStart = TimeOfDay.now();
    rangeEnd = (rangeStart.toDouble() + 12).toTimeOfDay(reduce: false);
    // setup range controllers 
    if(activeFilters.startRangeStart != null || activeFilters.startRangeEnd != null) {
      print(activeFilters.startRangeStart);
      print(activeFilters.startRangeEnd);
      startController.values = RangeValues(
        activeFilters.startRangeStart.toDouble(rangeDay) ?? rangeStart.toDouble(),
        activeFilters.startRangeEnd.toDouble(rangeDay) ?? rangeEnd.toDouble(),
      );
    }
    if(activeFilters.endRangeStart != null || activeFilters.endRangeEnd != null) {
      print(activeFilters.endRangeStart);
      print(activeFilters.endRangeEnd);
      endController.values = RangeValues(
        activeFilters.endRangeStart.toDouble(rangeDay) ?? rangeStart.toDouble(),
        activeFilters.endRangeEnd.toDouble(rangeDay) ?? rangeEnd.toDouble(),
      );
    }
    // if(activeFilters.startRangeStart != null && activeFilters.startRangeEnd != null) {
    //   double activeEnd = activeFilters.startRangeStart.getTimeOfDay().toDouble() > activeFilters.startRangeEnd.getTimeOfDay().toDouble() 
    //     ? activeFilters.startRangeEnd.getTimeOfDay().toDouble() + 24 
    //     : activeFilters.startRangeEnd.getTimeOfDay().toDouble();
    //     startController.values = RangeValues(_event.filter.value.startRangeStart.getTimeOfDay().toDouble(), activeEnd);
    // }
    // if(activeFilters.endRangeStart != null && activeFilters.endRangeEnd != null) {
    //   double activeEnd = activeFilters.endRangeStart.getTimeOfDay().toDouble() > activeFilters.endRangeEnd.getTimeOfDay().toDouble() 
    //     ? activeFilters.endRangeEnd.getTimeOfDay().toDouble() + 24 
    //     : activeFilters.endRangeEnd.getTimeOfDay().toDouble();
    //     endController.values = RangeValues(_event.filter.value.endRangeStart.getTimeOfDay().toDouble(), activeEnd);
    // }
    // timing
 }

  // ? Init but for async stuff
  Future<void> asyncInit() async {
    await fetchCategories();
    if(activeFilters.startRangeStart != null ) print(activeFilters.startRangeStart.toTimeOfDay(DateTime.now()).toDouble());
    if(activeFilters.startRangeEnd != null ) print(activeFilters.startRangeEnd.toTimeOfDay(DateTime.now()).toDouble());
  }

  //at top of filter screen build
  Future<void> fetchCategories() async {
    categoryController.categories = await _tags.fetchCategories();
    notifyListeners();
    categoryController.selected = categoryController.categories.where((e) => activeFilters.categories.contains(e.name)).toList();
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

    if(activeFilters.radius < minDistance) {
      cometSnackBar(
        title: "Distance Invalid",
        message: "The distance radius you've chosen is invalid! It should be at least $minDistance miles.",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    }
    return true;
  }
  
  //apply filters button
  void applyFilters() async {
    // validate
    bool valid = isValid();
    // if not valid reset date values to prevent time from stacking, and return
    if(!valid) return;
    // set active filters for homescreen to be the new homescreen
    _event.filter.add(newFilters);
    _navigate.popRepeated(1);
  }
  //reset button
  void resetFilters(){
    // reset time ranges
    startController.values = RangeValues(startController.start, startController.end);
    endController.values = RangeValues(endController.start, endController.end);
    // reset categories and tags
    categoryController.selected = [];
    tagController.tags = [];
    newFilters = EventFilters();
    notifyListeners();
  }
  
  //on change handlers --thank you for like 99.9% of this code jafar
  distanceOnChange(double radius){ newFilters.radius = radius; }

  startRangeOnChange(TimeRangeResult result) {
    newFilters.startRangeStart = result.startLive ? null : result.start.toDateTime(result.originalDay); 
    newFilters.startRangeEnd = result.endLive ? null : result.end.toDateTime(result.originalDay); 
  }
  endRangeOnChange(TimeRangeResult result) {
    newFilters.endRangeStart = result.startLive ? null : result.start.toDateTime(result.originalDay); 
    newFilters.endRangeEnd = result.endLive ? null : result.end.toDateTime(result.originalDay); 
  }

  categoryOnChange(List<Tag> categories) { newFilters.categories = categories.map((e) => e.name).toList(); }
  tagsOnChange(List<String> tags) { newFilters.tags = tags; }

}