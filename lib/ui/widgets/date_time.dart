import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class SubBlockContainer extends StatelessWidget {
  const SubBlockContainer({Key key, this.title, this.child, this.space = 5}) : super(key: key);

  final String title;
  final Widget child;
  final double space;

  @override
  Widget build(BuildContext context) {
    
    Color labelTextColor = CometThemeManager.lighten(locator<CometThemeManager>().theme.secondaryMono, 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(color: labelTextColor)),
        SizedBox(height: space),
        child
      ]
    );
  }
}

class DateSelector extends StatefulWidget {
  const DateSelector({
    Key key, 
    this.backgroundColor, 
    this.textColor, 
    this.inkwell = true, 
    this.daysPriorFirst = 0, 
    this.daysTillLast = 2, 
    @required this.onChanged
  }) : super(key: key);
  
  final Color backgroundColor;
  final Color textColor;
  final bool inkwell;
  final int daysPriorFirst;
  final int daysTillLast;
  final Function(DateTime) onChanged;

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {

  DateTime selectedDate;
  DateTime now;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    selectedDate = DateTime.now();
    now = DateTime.now();
    widget.onChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    Future _selectDate() async {
      DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: now.subtract(Duration(days: widget.daysPriorFirst)),
        lastDate: now.add(Duration(days: widget.daysTillLast))
      );
      if(pickedDate != null) {
        setState((){selectedDate = pickedDate;});
        widget.onChanged(selectedDate);
      }
    }

    return FlatButton(
      onPressed: _selectDate,
      child: Text(
        '${showRelativeWeekday(selectedDate.weekday)}, ${getMonth(selectedDate.month)} ${selectedDate.day}',
        style: TextStyle(fontSize: 18, color: widget.textColor,)
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: widget.backgroundColor != null ? widget.backgroundColor : _appTheme.secondaryMono,
      highlightColor: _appTheme.mainColor,
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
    if( weekday == now.weekday )
      return 'Today';
    else if( weekday == now.weekday+1)
      return 'Tomorrow';
    else
      return showWeekday(weekday);
  }

  String getMonth(int month){
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      default:
        return 'December';
    }
  }

}


class TimeSelector extends StatefulWidget {
  const TimeSelector({
    Key key, 
    this.backgroundColor, 
    this.textColor, 
    this.inkwell = true, 
    @required this.onChanged
  }) : super(key: key);
  
  final Color backgroundColor;
  final Color textColor;
  final bool inkwell;
  final Function(TimeOfDay) onChanged;

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {

  TimeOfDay selectedTime;
  TimeOfDay now;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    selectedTime = TimeOfDay.now();
    now = TimeOfDay.now();
    widget.onChanged(selectedTime);
  }

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    Future _selectTime() async {
      TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime
      );

      if( pickedTime != null ) {
        setState((){selectedTime = pickedTime;});
        widget.onChanged(selectedTime);
      }
    }

    return FlatButton(
      onPressed: _selectTime,
      child: Text(
        '${selectedTime.format(context)}',
        style: TextStyle(fontSize: 18, color: widget.textColor,)
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: widget.backgroundColor != null ? widget.backgroundColor : _appTheme.secondaryMono,
      highlightColor: _appTheme.mainColor,
    );
  }
}


class DateTimeRow extends StatelessWidget {
  
  const DateTimeRow({
    Key key, 
    @required this.dateOnChange, 
    @required this.timeOnChange, 
    this.backgroundColor, 
    this.textColor, 
    this.inkwell = true, 
    @required this.title
  }) : super(key: key);

  final String title;
  final Function(DateTime) dateOnChange;
  final Function(TimeOfDay) timeOnChange;
  final Color backgroundColor;
  final Color textColor;
  final bool inkwell;
  

  @override
  Widget build(BuildContext context) {

    return SubBlockContainer(
      title: title,
      space: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DateSelector(
            onChanged: dateOnChange,
            backgroundColor: backgroundColor,
            textColor: textColor,
            inkwell: inkwell,
          ),
          TimeSelector(
            onChanged: timeOnChange,
            backgroundColor: backgroundColor,
            textColor: textColor,
            inkwell: inkwell,
          )
        ],
      ),
    );
  }
}

class HourPickerRow extends StatefulWidget {
  HourPickerRow({Key key, this.title, this.hours, this.onChange}) : super(key: key);

  final String title;
  final int hours;
  final Function(int) onChange;

  @override
  _HourPickerRowState createState() => _HourPickerRowState();
}

class _HourPickerRowState extends State<HourPickerRow> {
  
  int selectedHour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.hours >= 1) {
      setState(() {
        selectedHour = 1;
      });
      widget.onChange(selectedHour);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SubBlockContainer(
      title: widget.title,
      child: Container(
        alignment: Alignment.centerLeft,
        // color: Colors.red,
        child: Wrap(
          runSpacing: 7,
          spacing: 10,
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            for(int i = 1; i <= widget.hours; i++) 
              HourNode(
                i == selectedHour,
                value: i,
                onTap: (number) { setState(() { selectedHour = number; }); widget.onChange(selectedHour); },
              )
            ]
          ),
      ),
    );
  }
}

class HourNode extends StatelessWidget {

  HourNode(this.selected, {Key key, this.value, this.onTap}) : super(key: key);

  final bool selected;
  final int value;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    Color _background = selected ? _appTheme.mainColor : _appTheme.secondaryMono;

    return InkWell(
      highlightColor: _appTheme.mainColor,
      splashColor: _appTheme.mainColor,
      onTap: () => onTap(value),
      child: Container(
        height: 40,
        width: 30,
        decoration: BoxDecoration(
          color: _background,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Center(child: Text(value.toString(), style: TextStyle(fontSize: 18)))
      ),
    );
  }
}
