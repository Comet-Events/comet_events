import 'package:comet_events/core/models/auth/auth_model.dart';
import 'package:comet_events/core/models/auth/login_block_model.dart';
import 'package:comet_events/core/models/auth/register_block_model.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/comet_text_field.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: SingleChildScrollView(
        child: UserViewModelBuilder<AuthModel>.reactive(
          autoRedirectToAuth: false,
          userViewModelBuilder: () => AuthModel(),
          staticChild: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/4,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -90,
                  bottom: 70,
                  child: Image.asset('assets/images/logo-purp.png')
                ),
                Positioned(
                  bottom: -40,
                  right: -5,
                  child: Image.asset('assets/images/logo-purp-3.png')
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    height: 68,
                    width: 120,
                    child: Stack(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text('Comet', style: TextStyle(fontSize: 27, shadows: [BoxShadow(color: _appTheme.antiOpposite, offset: Offset(0,2), blurRadius: 10)]))
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text('Events', style: TextStyle(fontSize: 35, shadows: [BoxShadow(color: _appTheme.antiOpposite, offset: Offset(0,2), blurRadius: 10)]))
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          builder: (context, model, user, child) {
            if(user != null) {
              // runs this after view loads
              SchedulerBinding.instance.addPostFrameCallback((_) {
                model.moveToHome();
              });
            }
            return Column(
              children: <Widget>[
                child,
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width/1.25,
                  child: Row(
                    children: [
                      AuthTab(
                        title: 'Login',
                        active: model.currentScreen == 0,
                        onTap: model.moveToLogin,
                      ),
                      AuthTab(
                        title: 'Register',
                        active: model.currentScreen == 1,
                        onTap: model.moveToRegister,
                      ),
                    ]
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height/2 ,
                  height: 450,
                  // color: Colors.red,
                  child: PageView(
                    controller: model.controller,
                    onPageChanged: model.pageChanged,
                    children: <Widget>[
                      LoginBlock(),
                      RegisterBlock(),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      )
    );
  }
}

// * Login Block
class LoginBlock extends StatelessWidget {
  const LoginBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    double _width = MediaQuery.of(context).size.width/1.25;

    return ViewModelBuilder<LoginBlockModel>.reactive(
      viewModelBuilder: () => LoginBlockModel(),
      builder: (context, model, _) => Container(
        width: _width,
        // color: Colors.red,
        margin: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - _width)/2, 
          vertical: 20
        ),
        child: Column(
          children: <Widget>[
            CometTextField(
              width: _width,
              title: 'Email',
              hint: 'Enter email',
              controller: model.email,
            ),
            SizedBox(height: 20),
            CometTextField(
              width: _width,
              title: 'Password',
              hint: 'Enter password',
              obscure: true,
              controller: model.password,
            ),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight, 
              child: GestureDetector(
                onTap: model.forgotPassword,
                child: Text('forgot password?', style: TextStyle(color: _appTheme.mainColor))
              )
            ),
            SizedBox(height: 20),
            CometSubmitButton(
              width: _width,
              text: 'Login',
              onTap: model.login,
            ),
            SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 1.0,
                  width: _width/1.1,
                  color: Colors.grey[700]
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: _appTheme.secondaryMono, 
                  child: Text('OR', style: TextStyle(color: Colors.grey[700]),)
                )
              ]
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: model.moveToHome,
              child: Image.asset('assets/images/google-auth.png'),
            )
          ],
        ),
      ),
    );
  }
}

// * Register Block
class RegisterBlock extends StatelessWidget {
  const RegisterBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    double _width = MediaQuery.of(context).size.width/1.25;

    return ViewModelBuilder<RegisterBlockModel>.reactive(
      viewModelBuilder: () => RegisterBlockModel(),
      builder: (context, model, _) => Container(
        width: _width,
        // color: Colors.red,
        margin: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - _width)/2, 
          vertical: 20
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CometTextField(
                    title: 'First',
                    hint: 'First Name',
                    controller: model.first,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: CometTextField(
                    title: 'Last',
                    hint: 'Last Name',
                    controller: model.last,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CometTextField(
              width: _width,
              title: 'Email',
              hint: 'Enter email',
              controller: model.email,
            ),
            SizedBox(height: 20),
            CometTextField(
              width: _width,
              title: 'Password',
              hint: 'Enter password',
              obscure: true,
              controller: model.password,
            ),
            SizedBox(height: 20),
            CometSubmitButton(
              onTap: model.register,
              width: _width,
              text: 'Register',
            ),
            SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 1.0,
                  width: _width/1.1,
                  color: Colors.grey[700]
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: _appTheme.secondaryMono, 
                  child: Text('OR', style: TextStyle(color: Colors.grey[700]),)
                )
              ]
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Image.asset('assets/images/google-auth.png'),
            )
          ],
        ),
      ),
    );
  }
}

class AuthTab extends StatelessWidget {

  final String title;
  final bool active;
  final Function onTap;

  const AuthTab({
    Key key, 
    @required this.title, 
    @required this.active, 
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;
    Color _mono = _appTheme.themeData.brightness == Brightness.dark ? Colors.white : Colors.black;
    Color _correct = active ? _mono : _mono.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 14, color: _correct)),
          SizedBox(height: 10),
          Container(
            height: 3.0,
            width: 80.0,
            color: _correct,
          ),
        ],
      ),
    );
  }
}