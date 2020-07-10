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
  DateTime changeDay(DateTime newDay) {
    return DateTime(this.year, this.month, newDay.day, this.minute, this.second, this.millisecond, this.microsecond);
  }
  /// Checks if the dates are the same down to the minute
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day && this.hour == other.hour && this.minute == other.minute;
  }

  bool isSameDay(DateTime other) {
    return this.resetToDayStart().isSameDate(other.resetToDayStart());
  }

  bool isTomorrow(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day+1 == other.day;
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
  double findTrueEndDouble(TimeOfDay start) {
    if(this.toDouble() <= start.toDouble()) {
      return 24 + this.toDouble();
    } else return this.toDouble();
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
  String epochTime() {
    TimeOfDay time = TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(this.toInt()));
    return "${time.hour}:${time.minute}";
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

  DateTime rangeStart;
  DateTime rangeEnd;

  CategoryPickerController categoryController = CategoryPickerController();
  TagPickerController tagController = TagPickerController();

  TimeRangeController startController;
  TimeRangeController endController;

  FilterModel() {
    if(activeFilters != null) newFilters = activeFilters;
    // define range variables
    rangeStart = DateTime.now();
    rangeEnd = rangeStart.add(Duration(hours: 12));
    startController = TimeRangeController();
    endController = TimeRangeController();
    startController.values = setupValues(activeFilters.startRangeStart, activeFilters.startRangeEnd);
    endController.values = setupValues(activeFilters.endRangeStart, activeFilters.endRangeEnd);
    // setup range controllers 
  }

  setupValues(DateTime oldStartDate, DateTime oldEndDate) {
    DateTime oldDay = activeFilters.originalDay.resetToDayStart();
    DateTime newDay = rangeStart.resetToDayStart();

    double start = rangeStart.millisecondsSinceEpoch.toDouble();
    double end = rangeEnd.millisecondsSinceEpoch.toDouble();

    if(activeFilters == null) return RangeValues(start, end);
    if(activeFilters.lastUpdated != null && activeFilters.lastUpdated.difference(rangeStart).inMinutes > 20) return RangeValues(start, end); // new range start is now

    if(oldStartDate != null) {
      DateTime oldStartDateTest = DateTime.fromMillisecondsSinceEpoch((oldStartDate.millisecondsSinceEpoch - oldDay.millisecondsSinceEpoch)+newDay.millisecondsSinceEpoch);
      if(oldStartDateTest.millisecondsSinceEpoch >= rangeStart.millisecondsSinceEpoch && oldStartDateTest.millisecondsSinceEpoch <= rangeEnd.millisecondsSinceEpoch) {
        start = oldStartDateTest.millisecondsSinceEpoch.toDouble();
      }
    }
    if(oldEndDate != null) {
      DateTime oldEndDateTest = DateTime.fromMillisecondsSinceEpoch((oldEndDate.millisecondsSinceEpoch - oldDay.millisecondsSinceEpoch)+newDay.millisecondsSinceEpoch);
      if(oldEndDateTest.millisecondsSinceEpoch >= rangeStart.millisecondsSinceEpoch && oldEndDateTest.millisecondsSinceEpoch <= rangeEnd.millisecondsSinceEpoch) {
        end = oldEndDateTest.millisecondsSinceEpoch.toDouble();
      }
    }
    return RangeValues(start, end);
  }

  // ? Init but for async stuff
  Future<void> asyncInit() async {
    await fetchCategories();
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
    newFilters.lastUpdated = DateTime.now();
    newFilters.originalDay = rangeStart;
    // add to filter stream
    _event.filter.add(newFilters);
    _navigate.popRepeated(1);
  }
  //reset button
  void resetFilters(){
    // reset time ranges
    startController.values = RangeValues(rangeStart.millisecondsSinceEpoch.toDouble(), rangeEnd.millisecondsSinceEpoch.toDouble());
    endController.values = RangeValues(rangeStart.millisecondsSinceEpoch.toDouble(), rangeEnd.millisecondsSinceEpoch.toDouble());
    // reset categories and tags
    categoryController.selected = [];
    tagController.tags = [];
    newFilters = EventFilters();
    notifyListeners();
  }
  
  //on change handlers --thank you for like 99.9% of this code jafar
  distanceOnChange(double radius){ newFilters.radius = radius; }

  startRangeOnChange(TimeRangeResult result) {
    newFilters.startRangeStart = result.startLive ? null : result.start;
    newFilters.startRangeEnd = result.endLive ? null : result.end;
  }
  endRangeOnChange(TimeRangeResult result) {
    newFilters.endRangeStart = result.startLive ? null : result.start;
    newFilters.endRangeEnd = result.endLive ? null : result.end;
  }

  categoryOnChange(List<Tag> categories) { newFilters.categories = categories.map((e) => e.name).toList(); }
  tagsOnChange(List<String> tags) { newFilters.tags = tags; }

}