import 'package:comet_events/core/models/add_event_model.dart';
import 'package:comet_events/core/objects/Tag.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_text_field.dart';
import 'package:comet_events/ui/widgets/date_time.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


class AddEventScreen extends StatelessWidget {
  AddEventScreen({Key key}) : super(key: key);

  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  Widget build(BuildContext context) {

    Widget _divider() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 10,
      color: _appTheme.secondaryMono,
    );
  }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: UserViewModelBuilder<AddEventModel>.reactive(
              userViewModelBuilder: () => AddEventModel(),
              builder: (context, model, user, _) => Column(
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
                          child: Hero(
                            tag: 'backdrop',
                            child: Container(
                              height: 108,
                              width: 108,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple,
                              ),
                            ),
                          )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 65),
                          child: Column(
                            children: <Widget>[
                              // * title & description
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Add an Event",
                                    textAlign: TextAlign.left,
                                    style: TextStyle( fontSize: 28 ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width/1.3,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Fill out the fields, and press 'create' to make a new event",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 159, 159, 159),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // * fields
                              // name
                              _nameBlock(context, model),
                              _divider(),
                              _dateBlock(context, model),
                              _divider(),
                              _tagBlock(context, model),
                              _divider(),
                              _locationBlock(context, model),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
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
          onChange: (number) {print(number);},
        ),
        SizedBox(height: 10),
        DateTimeRow(
          dateOnChange: (date) {}, 
          timeOnChange: (time) {}, 
          title: "Start"
        ),
        SizedBox(height: 10),
        DateTimeRow(
          dateOnChange: (date) {}, 
          timeOnChange: (time) {}, 
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
          onChanged: (c, d) {},
          maxChoices: 6,
          categories: <Tag>[
            Tag(name: 'education', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'food', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'fun', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'party', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'night', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'day', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
            Tag(name: 'something', popularity: 12, category: Category(category: true, iconCode: 0xe865)),
          ]
        ),
        SizedBox(height: 10),
        TagPicker(
          onChange: (list) {},
        ),
        // SizedBox(height: 10),
      ],
    );
  }


  Widget _locationBlock(BuildContext context, AddEventModel model) {
    return BlockContainer(
      title: 'Location',
      children: [
        CometTextField(
          width: MediaQuery.of(context).size.width/1.2,
          controller: model.name,
          title: 'Name',
          hint: 'Event Name',
          autocorrect: true,
          backgroundColor: _appTheme.secondaryMono,
        ),
        SizedBox(height: 10,),
        CometTextField(
          width: MediaQuery.of(context).size.width/1.2,
          controller: model.description,
          title: 'Description',
          hint: 'Event Description',
          autocorrect: true,
          backgroundColor: _appTheme.secondaryMono,
        ),
      ],
    );
  }

}

class BlockContainer extends StatelessWidget {
  const BlockContainer({Key key, @required this.children, @required this.title}) : super(key: key);

  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      color: _appTheme.mainMono,
      width: MediaQuery.of(context).size.width/1.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Text(title, style: TextStyle(fontSize: 25, color: Colors.grey[300])),
          SizedBox(height: 10),
          ...children,
          SizedBox(height: 22),
        ]
      )
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