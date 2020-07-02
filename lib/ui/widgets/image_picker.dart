import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {

  final String iconFontFamily;
  final String iconFontPackage;
  final Function(String, bool) onTap;
  final bool selected;
  final bool isFirst;
  final String category;

  const ImageTile({Key key, this.iconFontFamily, this.iconFontPackage, this.onTap, this.selected, this.category, this.isFirst = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    return InkWell(
      onTap: () => onTap(category, selected),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: selected ? _appTheme.mainColor : _appTheme.secondaryMono,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isFirst ? _appTheme.mainColor : Colors.transparent)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icon(IconData(category.category.iconCode, fontFamily: iconFontFamily, fontPackage: iconFontPackage)),
            // Text(category.name)
          ],
        ),
      ),
    );
  }
}