import 'package:comet_events/core/models/add_event_model.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/comet_text_field.dart';
import 'package:comet_events/ui/widgets/date_time.dart';
import 'package:comet_events/ui/widgets/upload_image.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'dart:ui';


class AddEventScreen extends StatefulWidget {
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SafeArea(
          bottom: false,
          child: UserViewModelBuilder<AddEventModel>.reactive(
            userViewModelBuilder: () => AddEventModel(),
            onModelReady: (model, user) {
              model.newEvent.host = user.uid;
              model.fetchCategories();
            },
            builder: (context, model, user, _) => Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(onTap: () {Navigator.of(context).pop();}, child: Icon(Icons.arrow_back, size: 35)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.more_horiz, size: 35),
                            )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 500,
                          decoration: BoxDecoration(
                            color: _appTheme.mainMono,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                top: -50,
                                child: Container(
                                  height: 105,
                                  width: 105,
                                  child: FloatingActionButton(
                                    onPressed: () {},
                                    heroTag: 'add_event_button',
                                    child: Icon(Icons.add, size: 60),
                                    backgroundColor: (_appTheme.mainColor)
                                  ),
                                )
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 65),
                                child: Column(
                                  children: <Widget>[
                                    // * title & description
                                    PageTitle(
                                      title: "Add an Event",
                                      description: "Fill out the fields, and press 'create' to make a new event",
                                    ),
                                    SizedBox(height: 16),
                                    // * fields
                                    // name
                                    _nameBlock(context, model),
                                    BlockDivider(),
                                    _dateBlock(context, model),
                                    BlockDivider(),
                                    _tagBlock(context, model),
                                    BlockDivider(),
                                    _imageBlock(context, model),
                                    BlockDivider(),
                                    _locationBlock(context, model),
                                    BlockDivider(),
                                    _createBlock(context, model)
                                  ],
                                ),
                              ),
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

  Widget _nameBlock(BuildContext context, AddEventModel model) {
    return BlockContainer(
      title: 'Name & Details',
      children: [
        HoriExpanded(
          child: CometTextField(
            controller: model.name,
            title: 'Name',
            hint: 'Event Name',
            autocorrect: true,
            backgroundColor: _appTheme.secondaryMono,
          ),
        ),
        SizedBox(height: 10,),
        HoriExpanded(
          child: CometTextField(
            controller: model.description,
            title: 'Description',
            hint: 'Event Description',
            autocorrect: true,
            backgroundColor: _appTheme.secondaryMono,
          ),
        ),
      ],
    );
  }

  Widget _dateBlock(BuildContext context, AddEventModel model) {
    return BlockContainer(
      title: 'Dates & Times',
      children: [
        HourPickerRow(
          hours: 12,
          title: "Premiere (hours before start)",
          onChange: model.premiereOnChange,
        ),
        SizedBox(height: 10),
        DateTimeRow(
          dateOnChange: (date) => model.startDateOnChange(date), 
          timeOnChange: (time) => model.startTimeOnChange(time), 
          title: "Start"
        ),
        SizedBox(height: 10),
        DateTimeRow(
          dateOnChange: (date) => model.endDateOnChange(date),
          timeOnChange: (time) => model.endTimeOnChange(time),
          title: "End"
        ),
      ],
    );
  }

  Widget _tagBlock(BuildContext context, AddEventModel model) {
    return BlockContainer(
      title: 'Categories & Tags',
      children: [
        CategoryPicker(
          onChanged: (categories) => model.categoryOnChange(categories),
          maxChoices: 2,
          iconFontFamily: 'Material Design Icons',
          iconFontPackage: 'material_design_icons_flutter',
          categories: model.categories
        ),
        SizedBox(height: 15),
        TagPicker(
          onChange: (tags) => model.tagsOnChange(tags),
          disabledTags: model.categories.map((e) => e.name).toList(),
        ),
        // SizedBox(height: 10),
      ],
    );
  }

  Widget _locationBlock(BuildContext context, AddEventModel model) {
    
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return BlockContainer(
      title: "Location",
      children: [
        SubBlockContainer(
          title: "Tap to select a location",
          child: InkWell(          
            onTap: () => model.showPlacePicker(context),
            child: HoriExpanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _appTheme.secondaryMono,
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    model.newLocation.address != null ? model.newLocation.address.fullAddress : "Choose an address",
                    style: TextStyle(color: _appTheme.mainColor, fontSize: 18),
                  ),
                )
              ),
            )
          ),
        ),
      ],
    );
  }

  Widget _imageBlock(BuildContext context, AddEventModel model){
    return BlockContainer(
      title: 'Images',
      children: [
        ImageUploader()
        // SizedBox(height: 10),
      ],
    );
  }

  Widget _createBlock(BuildContext context, AddEventModel model) {
    return SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          CometSubmitButton(
            text: "Create Event",
            onTap: model.createEvent,
          ),
          SizedBox(height: 20),
          // GestureDetector(child: Text('check enddate'),onTap: () => model.checkDates(),)
        ],
      ),
    );
  }
}

/// A widget you can stack on top of stuff to indicate a loading state
class CometLoadingOverlay extends StatelessWidget {
  final double opacity;
  const CometLoadingOverlay({Key key, this.opacity = 0.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    print('build ran');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: _appTheme.mainMono.withOpacity(opacity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadingBouncingGrid.circle(
            inverted: true,
            backgroundColor: _appTheme.mainColor,
            size: 65,
          ),
        ],
      ),
    );
  }
}


class HoriExpanded extends StatelessWidget {
  const HoriExpanded({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: child,
        )
      ],
    );
  }
}