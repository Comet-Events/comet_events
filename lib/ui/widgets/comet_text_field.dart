import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class CometTextField extends StatelessWidget {
  
  const CometTextField({
    Key key, 
    this.width = 200, 
    this.title = 'Field', 
    this.hint = 'Enter Text', 
    this.obscure = false,
    this.autocorrect = false,
    this.backgroundColor,
    @required this.controller,
  }) : super(key: key);

  final double width;
  final String title;
  final String hint;
  final bool obscure;
  final bool autocorrect;
  final Color backgroundColor;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      height: 57,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        color: backgroundColor != null ? backgroundColor : _appTheme.mainMono
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Text(title, overflow: TextOverflow.fade, style: TextStyle(color: _appTheme.mainColor)),
          Container(
            // color: Colors.red,
            child: SizedBox(
              height: 23,
              child: TextField(
                controller: controller,
                obscureText: obscure,
                autocorrect: autocorrect,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: -23),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}