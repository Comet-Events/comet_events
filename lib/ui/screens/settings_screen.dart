import 'package:comet_events/core/models/settings_model.dart';
import 'package:comet_events/core/services/auth.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    AuthService _auth = locator<AuthService>();

    return Scaffold(
      backgroundColor: _appTheme.mainMono,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('Settings', style: TextStyle(fontSize: 25)),
        leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,),
                  onPressed: () { 
                    Navigator.pop(context);
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
        
        centerTitle: true,
        // title: Text("Settings", textAlign: TextAlign.left,),
        // title: Hero(tag: "logo", child: Image.asset("assets/images/logo.png"))
      ),
      body: UserViewModelBuilder<SettingsModel>.reactive(
        userViewModelBuilder: () => SettingsModel(),
        builder: (context, model, user, _) => Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ 
                        SettingCategory(
                          categoryIcon: Icons.person_outline,
                          categoryTitle: "Account",
                          settings: <Widget>[
                            RegularSetting(
                              title: "Edit Account",
                              callback: model.editAccount,
                            ),
                            RegularSetting(
                              title: "Reset Password",
                              callback: model.resetPassword,
                            ),
                            RegularSetting(
                              title: "Clear Cache",
                              callback: model.clearCache,
                            ),
                            RegularSetting(
                              title: "Sign Out",
                              special: true,
                              callback: model.signOut,
                            ),
                          ],
                        ),
                        SettingCategory(
                          categoryIcon: Icons.format_paint,
                          categoryTitle: "Appearance",
                          settings: <Widget>[
                            IOSetting(
                              title: "Dark Theme",
                              defaultValue: Theme.of(context).brightness == Brightness.dark,
                              onCallback: model.darkThemeOn,
                              offCallback: () {locator<CometThemeManager>().changeToLight();}
                            ),
                          ],
                        ),
                        SettingCategory(
                          categoryIcon: Icons.location_on,
                          categoryTitle: "Location",
                          settings: <Widget>[
                            IOSetting(
                              title: "Current Location",
                              defaultValue: false,
                              onCallback: () {print("it is on");},
                              offCallback: () {print("it is off");}
                            ),
                          ],
                        ),
                      ]
                    ),
                    SizedBox(height: 30),
                    Image.asset('assets/images/logo-purp.png', height: 100, width: 100,)
                  ],
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}

// setting category
class SettingCategory extends StatelessWidget {
  final IconData categoryIcon;
  final String categoryTitle;
  final List<Widget> settings;
  const SettingCategory({Key key, this.categoryIcon, this.categoryTitle, this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Container(
      width: MediaQuery.of(context).size.width/1.25,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Icon(categoryIcon, size: 30.0, color: _appTheme.mainColor,),
                Text(" " + categoryTitle, style: TextStyle(fontSize: 20.0, color: _appTheme.mainColor),)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0, right: 30.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: settings.map((s) {
                bool isLast = settings.indexOf(s) == settings.length-1;
                return isLast ? Padding(child: s, padding: EdgeInsets.symmetric(vertical: 15.0)) 
                : Column(children: [Padding(child: s, padding: EdgeInsets.symmetric(vertical: 15.0)), Divider(color: Theme.of(context).primaryColor, thickness: 1.5,)]);
              }).toList()
            ),
          )
        ]
      )
    );
  }
}

// types of settings
class IOSetting extends StatefulWidget {
  final String title;
  final Function onCallback;
  final Function offCallback;
  final bool defaultValue;
  const IOSetting({Key key, this.title, this.onCallback, this.offCallback, this.defaultValue = false}) : super(key: key);

  @override
  _IOSettingState createState() => _IOSettingState();
}
class _IOSettingState extends State<IOSetting> {

  bool isOn;
  double _textSize = 18.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isOn = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.title, style: TextStyle(fontSize: _textSize),),
        GestureDetector(
          onTap: () {
            setState(() {
              isOn = false;
              widget.offCallback();
            });
          },
          child: isOn ? Text("On", style: TextStyle(color: _appTheme.mainColor, fontSize: _textSize),) 
          : GestureDetector(
          onTap: () {
            setState(() {
              isOn = true;
              widget.onCallback();
            });
          }, child: Text("Off", style: TextStyle(color: Colors.grey, fontSize: _textSize),),)
        )
      ],
    );
  }
}

class RegularSetting extends StatelessWidget {
  final String title;
  final Function callback;
  final bool special;
  const RegularSetting({Key key, this.title, this.callback, this.special = false}) : super(key: key);

  final double _textSize = 18.0;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return InkWell(
      onTap: callback,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: _textSize, color: special ? _appTheme.mainColor : _appTheme.themeData.textTheme.bodyText1.color)),
            Icon(Icons.arrow_forward_ios, color: special ? _appTheme.mainColor : _appTheme.themeData.textTheme.bodyText1.color),
          ]
        ),
      )
    );
  }
}