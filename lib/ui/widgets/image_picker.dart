import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';



class ImageTile extends StatelessWidget {

  final Function(String, bool) onTap;
  final bool selected;
  final bool isCoverImage;
  final String category;

  const ImageTile({
    Key key,
    this.onTap,
    this.selected,
    this.category,
    this.isCoverImage = false
  }) : super(key: key);

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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isCoverImage ? _appTheme.mainColor : Colors.transparent)
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