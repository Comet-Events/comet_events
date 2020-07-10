
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {

  const PageTitle({
    Key key,
    @required this.title,
    @required this.description
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    
    return  Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle( fontSize: 28 ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/1.3,
          alignment: Alignment.center,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CometThemeManager.darken(_appTheme.opposite, 0.3),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class BlockDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      width: MediaQuery.of(context).size.width,
      height: 10,
      color: locator<CometThemeManager>().theme.secondaryMono,
    );
  }
}

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
        Text(title, style: TextStyle(color: labelTextColor), overflow: TextOverflow.fade, maxLines: 4,),
        SizedBox(height: space),
        child
      ]
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
          Text(title, style: TextStyle(fontSize: 25, color: CometThemeManager.darken(_appTheme.opposite, 0.15))),
          SizedBox(height: 12),
          ...children,
          SizedBox(height: 22),
        ]
      )
    );
  }
}