import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

/// A widget you can stack on top of stuff to indicate a loading state
class CometLoadingOverlay extends StatelessWidget {
  final double opacity;
  const CometLoadingOverlay({Key key, this.opacity = 0.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    print('build ran');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: _appTheme.mainMono.withOpacity(opacity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadingBouncingGrid.circle(
            inverted: true,
            backgroundColor: _appTheme.mainColor,
            size: 65,
          ),
        ],
      ),
    );
  }
}