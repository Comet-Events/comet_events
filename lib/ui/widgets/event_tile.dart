import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {

  final double width;
  final String imageURL;
  final String title;
  final String date;
  final String category;
  final List<String> tags;
  final String description;
  final double scale;

  EventTile({
    Key key, 
    this.width,
    @required this.imageURL, 
    @required this.title, 
    @required this.date, 
    @required this.category, 
    @required this.tags, 
    @required this.description, 
    this.scale = 1,
  }) : super(key: key);

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    double titleScale = scale;
    double textScale = scale < 1 ? scale*0.93 : 1;

    return Container(
      width: width,
      height: 90*scale,
      decoration: BoxDecoration(
        color: _appTheme.secondaryMono,
        borderRadius: BorderRadius.all(Radius.circular(15.0*scale)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(41, 0, 0, 0),
            offset: Offset(0, 4*scale),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 85*scale,
            height: 85*scale,
            margin: EdgeInsets.all(3.5*scale),
            decoration: BoxDecoration(
              color: _appTheme.secondaryMono,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0*scale),
                topRight: Radius.circular(12.0*scale),
                bottomLeft: Radius.circular(12.0*scale),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0*scale),
                topRight: Radius.circular(12.0*scale),
                bottomLeft: Radius.circular(12.0*scale),
              ),
              child: Image.network(imageURL, fit: BoxFit.cover),
            )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0*scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 14*titleScale),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 14*titleScale,
                            color: _appTheme.mainColor,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.5*textScale),
                  FadingEdgeScrollView.fromSingleChildScrollView(
                    child: SingleChildScrollView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          CategoryChip(category, scale: textScale),
                          ...tags.map((t) => TagChip(t, scale: textScale)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.5*scale),
                  Expanded(
                    // width: 220,
                    child: Text(description,
                      style: TextStyle(fontSize: 9.5*scale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

class CategoryChip extends StatelessWidget {

  final String title;
  final double fontSize;
  final EdgeInsets spacing;
  final double radius;
  final EdgeInsets margin;
  final double scale;

  const CategoryChip(
    this.title, 
    { Key key, 
    this.fontSize = 9, 
    this.spacing = const EdgeInsets.only(left: 9.5, right: 9.5, top: 3, bottom: 3), 
    this.radius = 30,
    this.margin = const EdgeInsets.only(right: 6.0), 
    this.scale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: _appTheme.mainColor.withOpacity(0.25),
        border: Border.all(
          width: 1,
          color: _appTheme.mainColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Container(
        margin: spacing,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromARGB(255, 152, 125, 225),
            fontSize: fontSize*scale,
          ),
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {

  final String title;
  final double fontSize;
  final EdgeInsets spacing;
  final double radius;
  final EdgeInsets margin;
  final double scale;

  const TagChip(
    this.title, 
    { Key key, 
    this.fontSize = 9, 
    this.spacing = const EdgeInsets.only(left: 9.5, right: 9.5, top: 3, bottom: 3), 
    this.radius = 30,
    this.margin = const EdgeInsets.only(right: 6.0), 
    this.scale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: _appTheme.themeData.brightness == Brightness.dark ? Colors.white.withOpacity(0.25) : Colors.black.withOpacity(0.25),
        border: Border.all(
          width: 1,
          color: _appTheme.themeData.brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Container(
        margin: spacing,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: fontSize*scale),
        ),
      ),
    );
  }
}