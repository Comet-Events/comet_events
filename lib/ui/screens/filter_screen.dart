import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}
class _FilterScreenState extends State<FilterScreen> {

  CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      appBar: AppBar(
        backgroundColor: _appTheme.secondaryMono,
        elevation: 0.0,
        titleSpacing: 25.0,
        title: Text(
          'Filters',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 35,
            shadows: [
              Shadow(
                color: Colors.black38,
                offset: Offset(1,3)
              )
            ]
          )
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric( horizontal: 25 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                horizontalLine(),
                DistanceRadiusFilter(min: 0, max: 200),
                horizontalLine(),
                TimeFilter(),
                horizontalLine(),
                CategoriesFilter(),
                horizontalLine(),
                TagsFilter(),
                horizontalLine(),
                filterChanges(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget horizontalLine(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Container(
          color: CometThemeManager.lighten(_appTheme.secondaryMono),
          height: 1,
          width: MediaQuery.of(context).size.width
        ),
      ),
    );
  }

  Widget filterChanges(){
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(22.5)),
            highlightColor: Colors.white,
            splashColor: Colors.white,
            onTap: (){}, //reset changes and go back to homescreen
            child: Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                color: CometThemeManager.lighten(CometThemeManager.lighten(_appTheme.mainColor)),
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
          CometSubmitButton(
            onTap: (){}, //apply changes and go back to homescreen
            text: 'Apply Filters'
          )
        ],
      ),
    );
  }

}

  class DistanceRadiusFilter extends StatefulWidget {
    final double min, max;

    const DistanceRadiusFilter ({Key key, this.min, this.max}): super(key: key);

    @override
    _DistanceRadiusFilterState createState() => _DistanceRadiusFilterState();
  }
  class _DistanceRadiusFilterState extends State<DistanceRadiusFilter> {
    double radius = 0;
    bool showNewVal = false;
    
    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Distance Radius',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  shadows: [
                    Shadow( color: Colors.black26, offset: Offset(1,3))
                  ]
                )
              ),
              Text(
                showNewVal ? '${radius.toStringAsFixed(1)} mi' : '',
                style: TextStyle(
                  fontSize: 20,
                  color: CometThemeManager.lighten(locator<CometThemeManager>().theme.mainColor)
                )
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only( top: 60 ),
            child: Slider.adaptive(
              value: radius,
              onChanged: (newRadius){
                setState(() => radius = newRadius );
              },
              onChangeEnd: (newRadius){
                setState(() => radius = newRadius );
                radius == widget.min ? showNewVal = false : showNewVal = true;
              },
              min: widget.min,
              max: widget.max,
              divisions: 100,
              label: "${radius.toStringAsFixed(1)} m",
              activeColor: locator<CometThemeManager>().theme.mainColor,
              inactiveColor: locator<CometThemeManager>().theme.mainMono,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.min} miles',
                  style: TextStyle(color: CometThemeManager.darken(locator<CometThemeManager>().theme.opposite))
                ),
                Text('${widget.max} miles',
                  style: TextStyle(color: CometThemeManager.darken(locator<CometThemeManager>().theme.opposite))
                )
              ],
            ),
          )
        ],
      );
    }
  }

  class TimeFilter extends StatefulWidget {
    @override
    _TimeFilterState createState() => _TimeFilterState();
  }
  class _TimeFilterState extends State<TimeFilter> {
    
    Color labelTextColor = CometThemeManager.lighten(locator<CometThemeManager>().theme.secondaryMono);
    DateTime fromTime = DateTime.now();
    DateTime toTime = DateTime.now().add(Duration(hours: 4));

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Time',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
            )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('From', style: TextStyle(color: labelTextColor)),
                    customDateTimePicker(
                      fromTime,
                      fromTime.add(Duration(days: 2)), 
                      fromTime,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('To', style: TextStyle(color: labelTextColor)),
                    customDateTimePicker(
                      toTime,
                      toTime.add(Duration(days: 2)), 
                      toTime,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }

    String showWeekday( int weekday ){
      switch (weekday) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3: 
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        default:
          return 'Sunday';
      }
    }
    
    String showRelativeWeekday(int weekday){
      if( weekday == DateTime.now().weekday )
        return 'Today';
      else if( weekday == DateTime.now().weekday+1)
        return 'Tomorrow';
      else
        return showWeekday(weekday);
    }

    FlatButton customDateTimePicker(DateTime min, DateTime max, DateTime displayTime){
      return  FlatButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: min,
            maxTime: max,
            onConfirm: (newTime){
              setState(() => displayTime = newTime);
            },
            theme: DatePickerTheme(
              backgroundColor: locator<CometThemeManager>().theme.mainMono,
              headerColor: locator<CometThemeManager>().theme.secondaryMono,
              itemStyle: TextStyle( color: locator<CometThemeManager>().theme.opposite),
              cancelStyle: TextStyle( color: locator<CometThemeManager>().theme.opposite),
              doneStyle: TextStyle(
                color: CometThemeManager.lighten(locator<CometThemeManager>().theme.mainColor),
                fontSize: 20
              )
            )
          );
        },
        child: Text(
          '${showRelativeWeekday(displayTime.weekday)}, ${displayTime.hour}:${displayTime.minute}',
          style: TextStyle(fontSize: 18)
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        color: locator<CometThemeManager>().theme.mainMono,
      );
    }
  }

  class CategoriesFilter extends StatefulWidget {
    @override
    _CategoriesFilterState createState() => _CategoriesFilterState();
  }
  class _CategoriesFilterState extends State<CategoriesFilter> {
    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Categories',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              runSpacing: 10.0,
              spacing: 8.0,
              children: <Widget>[
                CategoryChip('Faith', scale: 2),
                CategoryChip('Trust', scale: 2),
                CategoryChip('and', scale: 2),
                CategoryChip('Pixie', scale: 2),
                CategoryChip('Dust', scale: 2),
                CategoryChip('#TinkerBell', scale: 2),
                CategoryChip('#Was', scale: 2),
                CategoryChip('#Overrated', scale: 2),
                CategoryChip('#TeamVidiaForLife', scale: 2)
              ],
            ),
          )
        ],
      );
    }
  }

  class TagsFilter extends StatefulWidget {
    @override
    _TagsFilterState createState() => _TagsFilterState();
  }
  class _TagsFilterState extends State<TagsFilter> {
    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Tags',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  shadows: [Shadow( color: Colors.black26, offset: Offset(1,3))]
                )
              ),
              SearchBar<TagChip>(
                onSearch: search,
                onItemFound: (TagChip tag, int index) {
                  return ListTile(
                    title: Text(tag.title),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              runSpacing: 10.0,
              spacing: 8.0,
              children: <Widget>[
                TagChip('Pop it', scale: 2),
                TagChip('Lock it', scale: 2),
                TagChip('Polka dot it', scale: 2),
                TagChip('Country fivin', scale: 2),
                TagChip('Hip hop it', scale: 2),
                TagChip('Put your hawk in the sky', scale: 2),
                TagChip('Move side to side', scale: 2),
                TagChip('Jump to the left', scale: 2),
                TagChip('Stick it', scale: 2),
                TagChip('Glide', scale: 2)
              ],
            ),
          )
        ],
      );
    }

    Future<List<TagChip>> search(String search) async {
      await Future.delayed(Duration(seconds: 2));
      return List.generate(search.length, (int index) {
        return TagChip("$search");
      });
    }
  }