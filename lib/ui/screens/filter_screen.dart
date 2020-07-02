// import 'dart:ui';
// import 'package:comet_events/core/models/filter_model.dart';
// import 'package:comet_events/ui/widgets/date_time.dart';
// import 'package:comet_events/ui/widgets/comet_buttons.dart';
// import 'package:comet_events/ui/widgets/layout_widgets.dart';
// import 'package:comet_events/ui/widgets/tag_category.dart';
// import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:comet_events/ui/theme/theme.dart';
// import 'package:comet_events/utils/locator.dart';
// import 'package:flutter/material.dart';

// class FilterScreen extends StatelessWidget{
//   final CometThemeData _appTheme = locator<CometThemeManager>().theme;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//         child: SafeArea(
//           bottom: false,
//           child: UserViewModelBuilder<FilterModel>.reactive(
//             userViewModelBuilder: () => FilterModel(),
//             onModelReady: (model, user){
//               model.activeFilters = model.currentFilters ?? FilterModel.defaultFilters;
//               model.fetchCategories();
//             },
//             builder: (context, model, user, _) => SingleChildScrollView(
//               physics: ClampingScrollPhysics(),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   //back button
//                   Container(
//                     alignment: Alignment.topRight,
//                     padding: const EdgeInsets.all(16.0),
//                     child: InkWell(
//                       onTap: (){ Navigator.of(context).pop(); },
//                       child: Icon(Icons.close,size: 35)
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: _appTheme.mainMono,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         topRight: Radius.circular(30.0),
//                       )
//                     ),
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       overflow: Overflow.visible,
//                       children: <Widget>[
//                         Positioned(
//                           top: -50,
//                           child: Hero(
//                             tag: 'filterIcon',
//                             child: Container(
//                               height: 105,
//                               width: 105,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:_appTheme.secondaryMono,
//                                 border: Border.all(
//                                   color: _appTheme.mainMono,
//                                   width: 2.0
//                                 )
//                               ),
//                               child: Icon(MdiIcons.filter, color: _appTheme.mainColor, size: 60 )
//                             )
//                           )
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 65),
//                           child: Column(
//                             children: <Widget>[
//                               //title & description
//                               PageTitle(
//                                 title: "Filters",
//                                 description: "Adjust the following specifications to narrow your event results",
//                               ),
//                               SizedBox(height: 16),
//                               // BlockDivider(), //torn about this
//                               _distanceBlock(context, model),
//                               BlockDivider(),
//                               _dateBlock(context, model),
//                               BlockDivider(),
//                               _tagsBlock(context, model),
//                               BlockDivider(),
//                               _filterBlock(context, model),
//                             ],
//                           )
//                         )
//                       ],
//                     )
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }

//   Widget _distanceBlock(BuildContext context, FilterModel model){
//     return Container(
//       padding: EdgeInsets.symmetric(vertical:20),
//       color: _appTheme.mainMono,
//       width: MediaQuery.of(context).size.width/1.17,
//       child: DistanceRadiusFilter(
//         defaultDistance: model.activeFilters.distanceRadius,
//         max: 20.0,
//         onChange: (radius) => model.distanceOnChange(radius),
//       ),
//     );
//   }

//   Widget _dateBlock(BuildContext context, FilterModel model) {
//     return BlockContainer(
//       title: 'Dates & Times',
//       children: [
//         DateTimeRow( 
//           title: "Start",
//           initDate: model.activeFilters.startTime,
//           //initTime:
//           dateOnChange: (date) => model.startDateOnChange(date),
//           timeOnChange: (time) => model.startTimeOnChange(time)
//         ),
//         SizedBox(height: 10),
//         DateTimeRow(
//           title: "End",
//           initDate: model.activeFilters.endTime,
//           //initTime: 
//           dateOnChange: (date) => model.endDateOnChange(date),
//           timeOnChange: (time) => model.endTimeOnChange(time)
//         ),
//       ],
//     );
//   }

//   Widget _tagsBlock(BuildContext context, FilterModel model){
//     return BlockContainer(
//       title: 'Categories & Tags',
//       children: [
//         //init selected
//         CategoryPicker(
//           onChanged: (categories) => model.categoryOnChange(categories),
//           maxChoices: 2,
//           iconFontFamily: 'Material Design Icons',
//           iconFontPackage: 'material_design_icons_flutter',
//           categories: model.categories,
//           //initCategories:
//         ),
//         SizedBox(height: 15),
//         //init selected
//         TagPicker(
//           onChange: (tags) => model.tagsOnChange(tags),
//           disabledTags: model.categories.map((e) => e.name).toList(),
//           initTags: model.activeFilters.tags,
//         ),
//         // SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _filterBlock(BuildContext context, FilterModel model){
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               //reset button
//               InkWell(
//                 onTap:(){
//                   model.resetFilters();
//                   // Navigator.pushReplacement(
//                   //   context,
//                   //   PageRouteBuilder(
//                   //     pageBuilder: (_, __, ___) => FilterScreen(),
//                   //     transitionDuration: Duration.zero,
//                   //   ),
//                   // );
//                 }, //reset filters to default
//                 borderRadius: BorderRadius.all(Radius.circular(22.5)),
//                 highlightColor: Colors.white,
//                 splashColor: Colors.white,
//                 child: Container(
//                   width: 100,
//                   height: 45,
//                   decoration: BoxDecoration(
//                     color: CometThemeManager.lighten(_appTheme.mainColor, 0.25),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromARGB(90, 0, 0, 0),
//                         offset: Offset(0, 4),
//                         blurRadius: 10,
//                       )
//                     ],
//                     borderRadius: BorderRadius.all(Radius.circular(22.5)),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Reset',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: _appTheme.mainColor,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               //apply filters button
//               CometSubmitButton(
//                 onTap: model.applyFilters, //apply changes and go back to homescreen
//                 text: 'Apply Filters'
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }

// }

// class DistanceRadiusFilter extends StatefulWidget {
//   double min, max, defaultDistance;
//   final Function(double) onChange;

//   DistanceRadiusFilter ({
//     Key key,
//     this.min = 0,
//     this.max = 50,
//     @required this.defaultDistance,
//     @required this.onChange
//   }): super(key: key);

//   @override
//   _DistanceRadiusFilterState createState() => _DistanceRadiusFilterState();
// }
// class _DistanceRadiusFilterState extends State<DistanceRadiusFilter> {
//   // double radius;
//   bool showNewVal = true;
//   final CometThemeData _appTheme = locator<CometThemeManager>().theme;

//   // @override
//   // void initState(){
//   //   super.initState();
//   //   radius = widget.defaultDistance;
//   //   print('hi jafar youre my fav');
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         sectionHeader(),
//         distanceSlider(),
//         sliderLabels()
//       ],
//     );
//   }

//   Row sectionHeader(){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           'Distance Radius',
//           textAlign: TextAlign.left,
//           style: TextStyle(
//             fontSize: 25,
//             color: CometThemeManager.darken(_appTheme.opposite, 0.15)
//           )
//         ),
//         Text(
//           showNewVal ? '${widget.defaultDistance.toStringAsFixed(1)} mi' : '',
//           style: TextStyle(
//             fontSize: 22,
//             color: CometThemeManager.lighten(_appTheme.mainColor)
//           )
//         ),
//       ],
//     );
//   }
  
//   Widget distanceSlider(){
//     return Padding(
//       padding: const EdgeInsets.only( top: 60 ),
//       child: Slider.adaptive(
//         value: widget.defaultDistance,
//         onChanged: (newRadius){
//           setState(() => widget.defaultDistance = newRadius );
//         },
//         onChangeEnd: (newRadius){
//           setState(() => widget.defaultDistance = newRadius );
//           widget.onChange(newRadius); 
//           widget.defaultDistance == widget.min ? showNewVal = false : showNewVal = true;
//         },
//         min: widget.min,
//         max: widget.max,
//         divisions: (widget.max-widget.min).floor()*4,
//         label: "${widget.defaultDistance.toStringAsFixed(1)} m",
//         activeColor: _appTheme.mainColor,
//         inactiveColor: _appTheme.secondaryMono
//       ),
//     );
//   }

//   Widget sliderLabels(){
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal:10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text('${widget.min} miles',
//             style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
//           ),
//           Text('${widget.max} miles',
//             style: TextStyle(color: CometThemeManager.darken(_appTheme.opposite))
//           )
//         ],
//       ),
//     );
//   }
// }
