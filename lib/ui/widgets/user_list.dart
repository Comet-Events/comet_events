import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  
  const UserList({
    Key key, 
    this.title = 'People', 
    this.onViewAll, 
    this.users, 
    this.emptyText = "This list is empty...",
  }) : super(key: key);

  final String title;
  final String emptyText;
  final Function onViewAll;
  final List<UserIcon> users;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      padding: const EdgeInsets.all(15.0),
      height: 135,
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
          Expanded(
            child: users.isNotEmpty ? ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ...users
              ],
            ) : Center(
              child: Text(
                emptyText,
                style: TextStyle(color: _appTheme.lineBorder, fontSize: 14.5)
              )
            ),
          )
        ]
      ),
    );
  }
}

class UserIcon extends StatelessWidget {

  final String url;
  final String first;

  const UserIcon({
    Key key, 
    @required this.url, 
    @required this.first,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        children: <Widget>[
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(41, 0, 0, 0),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(54.0, 54.0)),
              child: Image.network(url, fit: BoxFit.cover)
            )
          ),
          Flexible(child: Text(first, textAlign: TextAlign.center,))
        ],
      ),
    );
  }
}