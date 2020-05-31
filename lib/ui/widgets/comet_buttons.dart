import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class CometSubmitButton extends StatelessWidget {
  const CometSubmitButton({
    Key key, 
    @required this.text, 
    this.onTap, 
    this.width = 200
  }) : super(key: key);

  final String text;
  final Function onTap;
  final double width;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    double radius = 22.5;

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          color: _appTheme.mainColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(90, 0, 0, 0),
              offset: Offset(0, 4),
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
        );
  }
}
class CometIconButton extends StatelessWidget {

  final IconData data;
  final Function onTap;

  const CometIconButton(this.data, {
    Key key, 
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                color: Color.fromARGB(255, 80, 80, 80),
                width: 1,
                style: BorderStyle.solid,
              )
            ),
            borderRadius: BorderRadius.all(Radius.circular(22.5)),
          ),
          child: Icon(data, color: _appTheme.mainColor,)
        ),
      ),
    );
  }
}