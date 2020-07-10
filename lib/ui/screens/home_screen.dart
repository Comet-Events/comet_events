import 'package:comet_events/core/models/home_model.dart';
import 'package:comet_events/ui/screens/map.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/ui/widgets/user_view_model_builder.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CometThemeData _appTheme = locator<CometThemeManager>().theme;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return UserViewModelBuilder<HomeModel>.reactive(
      onModelReady: (model, _) => model.init(),
      userViewModelBuilder: () => HomeModel(),
      builder: (context, model, user, child) {
        model.rebuild();
        return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: model.moveToAddEventScreen,
          heroTag: 'add_event_button',
          child: Icon(Icons.add, size: 30),
          backgroundColor: (_appTheme.mainColor)
        ),
        bottomNavigationBar: _bottomAppBar(),
        backgroundColor: _appTheme.secondaryMono,
        body: Stack(
          children: <Widget>[
            HomeMap(
              controller: model.homeMapController,
              events: model.events,
              cameraPos: model.mapCameraPos,
            ),
            Column(
              children: <Widget>[
                _topAppBar(model),
                SizedBox(height: 7),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _searchWidget(),
                    ],
                  )
                ),
                SizedBox(height: 135),
                _eventCarousel(model),
                SizedBox(height: 45),
                SafeArea(child: Container(), top: false)
              ],
            ),
          ],
        ),
      );
      }
    );
  }

  Widget _topAppBar(HomeModel model){
    return Container(
      // height: MediaQuery.of(context).size.height*0.12,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0)
        ),
        color: locator<CometThemeManager>().theme.mainMono
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.settings, 
              size: 30, 
              color: locator<CometThemeManager>().theme.mainColor,
            ),
            GestureDetector(
              onTap: model.update,
              child: Text(
                model.rad ?? "",
                style: TextStyle(
                  fontFamily: "Lexend Deca",
                  fontSize: 18,
                )
              ),
            ),
            FlutterLogo( size: 30 )
          ],
        ),
      )
    );
  }
  
  Widget _bottomAppBar(){
    return BottomAppBar(
      color: _appTheme.mainMono,
      shape: CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              color: CometThemeManager.darken(_appTheme.opposite),
              disabledColor: CometThemeManager.lighten(_appTheme.secondaryMono),
              icon: Icon( Icons.message, size: 30.0)
            ),
            IconButton(
              onPressed: () {},
              color: CometThemeManager.darken(_appTheme.opposite),
              disabledColor: CometThemeManager.lighten(_appTheme.secondaryMono),
              icon: Icon( Icons.people, size: 30.0)
            )
          ],
        ),
      ),
    );
  }

  Row _searchWidget() {
    return Row(
      children: <Widget>[
        // SearchBar<String>(
        //   onSearch: (s) {},
        //   onItemFound: (string, inte) {},
        // ),
        Spacer(),
        GestureDetector(
          onTap: (){
            HomeModel().moveToFilterScreen();
          }, //go to filter page
          child: Hero(
            tag: 'filterIcon',
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _appTheme.secondaryMono,
                border: Border.all(
                  color: _appTheme.mainMono,
                  width: 2.0
                )
              ),
              child: Icon(MdiIcons.filter, color: _appTheme.mainColor, size: 30 )
            ),
          )
        )
      ],
    );
  }

  Widget _eventCarousel(HomeModel model){
    return Container(
      child: CarouselSlider(
        items: model.events.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                child: EventTile(event: i, scale: 1.2,),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 90*1.2,
          viewportFraction: 0.84,
          initialPage: 0,
          // enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          enlargeCenterPage: true,
          onPageChanged: (number, reason) {
            //update google maps camera position
          },
          scrollDirection: Axis.horizontal,
        ),
        carouselController: carouselController,  
      ),
    );
  }
}