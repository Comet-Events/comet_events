import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: Center(
          child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: _appTheme.mainColor,
                    size: 50.0,
                  ),
                  SizedBox(
                    height: 20
                  ),
                  Text(
                    "LOADING",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}