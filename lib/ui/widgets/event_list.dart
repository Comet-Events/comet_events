import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

import 'event_tile.dart';

class EventList extends StatelessWidget {

  const EventList({
    Key key, 
    this.title = 'Events',
    this.eventTiles, 
    this.spacing = 10, 
    this.onViewAll,
  }) : super(key: key);

  final String title;
  final List<EventTile> eventTiles;
  final double spacing;
  final Function onViewAll;


  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      padding: const EdgeInsets.all(15.0),
      color: _appTheme.mainMono,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(title)
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Container(
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: _appTheme.mainColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Column(
            children: <Widget>[
              for(var i = 0; i < eventTiles.length; i++) 
                i != eventTiles.length-1 ? Container(
                  margin: EdgeInsets.only(bottom: spacing), 
                  child: eventTiles[i]
                ) : eventTiles[i]
            ],
          ),
        ]
      ),
    );
  }
}
