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

  EventTile({
    Key key, 
    this.width,
    @required this.imageURL, 
    @required this.title, 
    @required this.date, 
    @required this.category, 
    @required this.tags, 
    @required this.description,
  }) : super(key: key);

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      width: width,
      height: 90,
      decoration: BoxDecoration(
        color: _appTheme.secondaryMono,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(41, 0, 0, 0),
            offset: Offset(0, 4),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 85,
            height: 85,
            margin: const EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              color: _appTheme.secondaryMono,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
              child: Image.network(imageURL, fit: BoxFit.cover),
            )
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 14,
                            color: _appTheme.mainColor,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.5),
                  FadingEdgeScrollView.fromSingleChildScrollView(
                    child: SingleChildScrollView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          CategoryChip(category),
                          ...tags.map((t) => TagChip(t)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.5),
                  Expanded(
                    // width: 220,
                    child: Text(description,
                      style: TextStyle(fontSize: 9.5),
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

  const CategoryChip(
    this.title, 
    { Key key, 
    this.fontSize = 9, 
    this.spacing = const EdgeInsets.only(left: 9.5, right: 9.5, top: 3, bottom: 3), 
    this.radius = 30,
    this.margin = const EdgeInsets.only(right: 6.0),
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
            fontSize: fontSize,
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

  const TagChip(
    this.title, 
    { Key key, 
    this.fontSize = 9, 
    this.spacing = const EdgeInsets.only(left: 9.5, right: 9.5, top: 3, bottom: 3), 
    this.radius = 30,
    this.margin = const EdgeInsets.only(right: 6.0),
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
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}