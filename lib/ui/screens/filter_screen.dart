import 'dart:ui';
import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/widgets/date_time.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class FilterScreen extends StatelessWidget{
  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    HomeModel model;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: (){ Navigator.of(context).pop(); },
                    child: Icon(Icons.arrow_forward,size: 35)
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 10,
                              color: locator<CometThemeManager>().theme.secondaryMono,
                            ),
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
        ),
      )
    );
  }

  Widget _distanceBlock(BuildContext context, HomeModel model){
    return Container(
      padding: EdgeInsets.symmetric(vertical:20),
      color: _appTheme.mainMono,
      width: MediaQuery.of(context).size.width/1.17,
      child: DistanceRadiusFilter(defaultDistance: 20.0),
    );
  }

  Widget _dateBlock(BuildContext context, HomeModel model) {
    return BlockContainer(
      title: 'Dates & Times',
      children: [
        DateTimeRow( 
          title: "Start",
          dateOnChange: (DateTime newDate){},
          timeOnChange: (TimeOfDay newTime){}
        ),
        SizedBox(height: 10),
        DateTimeRow(
          title: "End",
          dateOnChange: (DateTime newDate){},
          timeOnChange: (TimeOfDay newTime){}
        ),
      ],
    );
  }

  Widget _tagsBlock(BuildContext context, HomeModel model){
    return BlockContainer(
      title: 'Categories & Tags',
      children: [
        CategoryPicker(
          onChanged: null,
          maxChoices: 2,
          iconFontFamily: 'Material Design Icons',
          iconFontPackage: 'material_design_icons_flutter',
          categories: []
        ),
        SizedBox(height: 15),
        TagPicker(
          onChange: null,
          disabledTags: [],
        ),
        // SizedBox(height: 10),
      ],
    );
  }

  Widget _filterBlock(BuildContext context, HomeModel model){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //reset button
              InkWell(
                onTap: (){}, //reset changes and go back to homescreen
                borderRadius: BorderRadius.all(Radius.circular(22.5)),
                highlightColor: Colors.white,
                splashColor: Colors.white,
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
              //apply filters button
              CometSubmitButton(
                onTap: (){}, //apply changes and go back to homescreen
                text: 'Apply Filters'
              )
            ],
          ),
        ),
      ],
    );
  }

}

  class DistanceRadiusFilter extends StatefulWidget {
    final double min, max, defaultDistance;

    const DistanceRadiusFilter ({
      Key key,
      this.min = 0,
      this.max = 200,
      this.defaultDistance = 0
    }): super(key: key);

    @override
    _DistanceRadiusFilterState createState() => _DistanceRadiusFilterState();
  }
  class _DistanceRadiusFilterState extends State<DistanceRadiusFilter> {
    double radius;
    bool showNewVal = true;
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;

    @override
    void initState(){
      super.initState();
      radius = widget.defaultDistance;
    }

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
            showNewVal ? '${radius.toStringAsFixed(1)} mi' : '',
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
          divisions: ((widget.max-widget.min)/2).floor(),
          label: "${radius.toStringAsFixed(1)} m",
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
