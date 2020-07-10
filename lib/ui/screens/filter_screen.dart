import 'dart:ui';
import 'package:comet_events/core/models/filter_model.dart';
import 'package:comet_events/ui/widgets/comet_loading.dart';
import 'package:comet_events/ui/widgets/date_time.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

extension on TimeOfDay {
  double toDouble() => this.hour + this.minute/60.0;
}

extension on double {
  TimeOfDay toTimeOfDay() {
    double val = this;
    while(val >= 24) {
      val -= 24;
    }
    return TimeOfDay(hour: val.toInt(), minute: ((val - val.toInt())*60).toInt());
  }
}

extension on DateTime {
    bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day && this.hour == other.hour && this.minute == other.minute;
  }

  bool isSameDay(DateTime other) {
    return this.resetToDayStart().isSameDate(other.resetToDayStart());
  }

  DateTime resetToDayStart() {
    return DateTime(this.year ?? DateTime.now().year, this.month, this.day);
  }
}

class FilterScreen extends StatelessWidget{
  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SafeArea(
          bottom: false,
          child: UserViewModelBuilder<FilterModel>.reactive(
            onModelReady: (model, _) async => await model.asyncInit(),
            userViewModelBuilder: () => FilterModel(),
            builder: (context, model, user, _) => Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //back button
                      Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: (){ Navigator.of(context).pop(); },
                          child: Icon(Icons.close,size: 35)
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: _appTheme.mainMono,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          )
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              top: -50,
                              child: Hero(
                                tag: 'filterIcon',
                                child: Container(
                                  height: 105,
                                  width: 105,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:_appTheme.secondaryMono,
                                    border: Border.all(
                                      color: _appTheme.mainMono,
                                      width: 2.0
                                    )
                                  ),
                                  child: Icon(MdiIcons.filter, color: _appTheme.mainColor, size: 60 )
                                )
                              )
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 65),
                              child: Column(
                                children: <Widget>[
                                  //title & description
                                  PageTitle(
                                    title: "Filters",
                                    description: "Adjust the following specifications to narrow your event results",
                                  ),
                                  SizedBox(height: 16),
                                  // BlockDivider(), //torn about this
                                  _distanceBlock(context, model),
                                  BlockDivider(),
                                  _dateBlock(context, model),
                                  BlockDivider(),
                                  _tagsBlock(context, model),
                                  BlockDivider(),
                                  _filterBlock(context, model),
                                ],
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                model.loading ? CometLoadingOverlay(opacity: 0.6) : Container()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _distanceBlock(BuildContext context, FilterModel model){
    return Container(
      padding: EdgeInsets.symmetric(vertical:20),
      color: _appTheme.mainMono,
      width: MediaQuery.of(context).size.width/1.17,
      child: DistanceRadiusFilter(
        defaultDistance: model.newFilters.radius,
        max: 100.0,
        onChange: (radius) => model.distanceOnChange(radius),
      ),
    );
  }

  Widget _dateBlock(BuildContext context, FilterModel model) {
    return BlockContainer(
      title: 'Timing',
      children: [
        Column(
          children: <Widget>[
            SubBlockContainer(
              title: 'Start Range',
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  TimeRange(
                    controller: model.startController,
                    start: model.rangeStart,
                    end: model.rangeEnd,
                    startLive: true,
                    onChanged: model.startRangeOnChange
                  )
                ],
              ),
            ),
            // sliderLabels(model.startController.live == model.startController.values.start ? "Live" : model.startController.values.start.toTimeOfDay().format(context), model.startController.values.end.toTimeOfDay().format(context)),
            sliderLabels(
              "Live",
              TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(model.rangeEnd.millisecondsSinceEpoch)).format(context))
          ],
        ),
        Column(
          children: <Widget>[
            SubBlockContainer(
              title: 'End Range',
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  TimeRange(
                    controller: model.endController,
                    start: model.rangeStart,
                    end: model.rangeEnd,
                    endLive: true,
                    onChanged: model.endRangeOnChange
                  )
                ],
              ),
            ),
            sliderLabels(
              TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(model.rangeStart.millisecondsSinceEpoch)).format(context),
              "Later"  
            )
          ],
        ),
      ],
    );
  }

  Widget _tagsBlock(BuildContext context, FilterModel model){
    return BlockContainer(
      title: 'Categories & Tags',
      children: [
        //init selected
        CategoryPicker(
          controller: model.categoryController,
          onChanged: (categories) => model.categoryOnChange(categories),
          iconFontFamily: 'Material Design Icons',
          iconFontPackage: 'material_design_icons_flutter',
          // initCategories: ['education']
        ),
        SizedBox(height: 15),
        //init selected
        TagPicker(
          controller: model.tagController,
          onChange: (tags) => model.tagsOnChange(tags),
          disabledTags: model.categoryController.categories.map((e) => e.name).toList(),
          initTags: model.activeFilters.tags,
        ),
        // SizedBox(height: 10),
      ],
    );
  }

  Widget _filterBlock(BuildContext context, FilterModel model){
    return Column(
      children: <Widget>[
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //reset button
                InkWell(
                  onTap:(){
                    model.resetFilters();
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (_, __, ___) => FilterScreen(),
                    //     transitionDuration: Duration.zero,
                    //   ),
                    // );
                  }, //reset filters to default
                  borderRadius: BorderRadius.all(Radius.circular(22.5)),
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      color: CometThemeManager.lighten(_appTheme.mainColor, 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(90, 0, 0, 0),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                    ),
                    child: Center(
                      child: Text(
                        'Reset',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _appTheme.mainColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                //apply filters button
                CometSubmitButton(
                  onTap: () => model.applyFilters(), //apply changes and go back to homescreen
                  text: 'Apply Filters'
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sliderLabels(String left, String right){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(left,
            style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
          ),
          Text(right,
            style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
          )
        ],
      ),
    );
  }
}

class TimeRangeController {
  RangeValues values;
  int divisions = 10;
  TimeRangeController({this.values}) {
    this.values = this.values ?? RangeValues(DateTime.now().millisecondsSinceEpoch.toDouble(), DateTime.now().add(Duration(hours: 13)).millisecondsSinceEpoch.toDouble());
  }
}
class TimeRange extends StatefulWidget {
  TimeRange({
    Key key, 
    this.controller,
    this.onChanged,
    @required this.start,
    @required this.end,
    this.startLive = false,
    this.endLive = false
  }) : super(key: key);
  TimeRangeController controller;
  Function(TimeRangeResult) onChanged;
  DateTime start;
  DateTime end;
  bool startLive;
  bool endLive;
  @override
  _TimeRangeState createState() => _TimeRangeState();
}
class _TimeRangeState extends State<TimeRange> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(widget.controller == null);
    //print(widget.controller.values == null);
    if(widget.controller == null) widget.controller = TimeRangeController();
    if(widget.controller.values == null) widget.controller.values = RangeValues(widget.start.millisecondsSinceEpoch.toDouble(), widget.end.millisecondsSinceEpoch.toDouble());
    widget.controller.divisions = getDivisions();
  }

  getDivisions() {
    int milliseconds = widget.end.millisecondsSinceEpoch-widget.start.millisecondsSinceEpoch;
    double divisions = milliseconds/60000;
    return divisions.toInt();
  }

  generateRangeLabels() {
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(widget.controller.values.start.toInt());
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(widget.controller.values.end.toInt());
    
    String startLabel = (startDate.isSameDay(DateTime.now()) ? "Today " : "Tomorrow ") + TimeOfDay.fromDateTime(startDate).format(context);
    String endLabel = (endDate.isSameDay(DateTime.now()) ? "Today " : "Tomorrow ") + TimeOfDay.fromDateTime(endDate).format(context);
  
    if(widget.controller.values.start == widget.start.millisecondsSinceEpoch.toDouble() && widget.startLive) startLabel = "Live";
    if(widget.controller.values.end == widget.end.millisecondsSinceEpoch.toDouble() && widget.endLive) endLabel = "Later";

    return RangeLabels(startLabel, endLabel);
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      onChanged: (RangeValues value) { 
        setState(() { widget.controller.values = value; });
         if(widget.onChanged != null) widget.onChanged(TimeRangeResult(
          start: DateTime.fromMillisecondsSinceEpoch(widget.controller.values.start.toInt()),
          end: DateTime.fromMillisecondsSinceEpoch(widget.controller.values.end.toInt()),
          startLive: widget.controller.values.start == widget.start.millisecondsSinceEpoch.toDouble() && widget.startLive,
          endLive: widget.controller.values.end == widget.end.millisecondsSinceEpoch.toDouble() && widget.endLive
        ));
      }, 
      values: widget.controller.values,
      min: widget.start.millisecondsSinceEpoch.toDouble(),
      max: widget.end.millisecondsSinceEpoch.toDouble(),
      labels: generateRangeLabels(),
      divisions: widget.controller.divisions,
    );
  }
}

class TimeRangeResult {
  final DateTime start;
  final DateTime end;
  final bool startLive;
  final bool endLive;
  TimeRangeResult({this.start, this.end, this.startLive, this.endLive});
}

// * Distance Radius Slider
class DistanceRadiusFilter extends StatefulWidget {
  double min, max, defaultDistance;
  final Function(double) onChange;

  DistanceRadiusFilter ({
    Key key,
    this.min = 0,
    this.max = 50,
    @required this.defaultDistance,
    @required this.onChange
  }): super(key: key);

  @override
  _DistanceRadiusFilterState createState() => _DistanceRadiusFilterState();
}
class _DistanceRadiusFilterState extends State<DistanceRadiusFilter> {
  // double radius;
  bool showNewVal = true;
  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  // @override
  // void initState(){
  //   super.initState();
  //   radius = widget.defaultDistance;
  //   print('hi jafar youre my fav');
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        sectionHeader(),
        distanceSlider(),
        sliderLabels()
      ],
    );
  }

  Row sectionHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Distance Radius',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
            color: CometThemeManager.darken(_appTheme.opposite, 0.15)
          )
        ),
        Text(
          showNewVal ? '${widget.defaultDistance.toStringAsFixed(1)} mi' : '',
          style: TextStyle(
            fontSize: 22,
            color: CometThemeManager.lighten(_appTheme.mainColor)
          )
        ),
      ],
    );
  }
  
  Widget distanceSlider(){
    return Padding(
      padding: const EdgeInsets.only( top: 60 ),
      child: Slider(
        value: widget.defaultDistance,
        onChanged: (newRadius){
          setState(() => widget.defaultDistance = newRadius );
        },
        onChangeEnd: (newRadius){
          setState(() => widget.defaultDistance = newRadius );
          widget.onChange(newRadius); 
          widget.defaultDistance == widget.min ? showNewVal = false : showNewVal = true;
        },
        min: widget.min,
        max: widget.max,
        divisions: (widget.max-widget.min).floor()*4,
        label: "${widget.defaultDistance.toStringAsFixed(1)} m",
        activeColor: _appTheme.mainColor,
        inactiveColor: _appTheme.secondaryMono
      ),
    );
  }

  Widget sliderLabels(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${widget.min} miles',
            style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
          ),
          Text('${widget.max} miles',
            style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
          )
        ],
      ),
    );
  }
}

