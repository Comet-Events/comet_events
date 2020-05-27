import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

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