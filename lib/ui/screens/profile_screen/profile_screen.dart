import 'package:comet_events/ui/screens/profile_screen/user.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/event_list.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/ui/widgets/user_list.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

/// * View Model Variables
/// 
/// * View Model Functions
/// viewAllFollowers()
/// viewAllEvents()
/// addUserToFollowing()

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  // Dummy User Data 
  User user = User(
    name: "John Applepie",
    location: "Dallas, TX",
    description:"I’m an influencer, world wide chad. I’m really into anime I love anime I’m kinda weeb quirky hehe.",
    profilePic: Image.network('https://img.stackshare.io/service/1161/vI0ZZlhZ_400x400.png', fit: BoxFit.cover),
    followers: List.filled(129, "Bob", growable: true),
    events: List.filled(39, "Bob", growable: true),
    following: List.filled(689, "Bob", growable: true),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // app bar
              _appBar(),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: _appTheme.mainMono,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: [
                    // profile pic
                    _profilePic(),
                    Container(
                      margin: const EdgeInsets.only(top: 65),
                      child: Column(
                        children: [
                          // name & location & description
                          _basicInfo(screenWidth),
                          SizedBox(height: 20),
                          // buttons
                          _socialButtons(screenWidth),
                          SizedBox(height: 20),
                          // statistics
                          _stats(screenWidth),
                          SizedBox(height: 14)
                        ],
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 10),
              // list of followers
              _followerList(),
              SizedBox(height: 10),
              // list of events
              _eventList()
            ],
          ),
        ),
      )
    );
  }

  Widget _appBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.arrow_back, size: 35),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.more_horiz, size: 35),
        )
      ],
    );
  }

  Widget _profilePic(){
    return Positioned(
      top: -50,
      child: Container(
        height: 108,
        width: 108,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 5, 
            color: _appTheme.secondaryMono, 
            style: BorderStyle.solid
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(41, 0, 0, 0),
              offset: Offset(0, 4),
              blurRadius: 10,
            )
          ]
        ),
        // Profile Pic
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(54.0, 54.0)),
          child: user.getProfilePic
        )
      )
    );
  }

  Widget _basicInfo(double screenWidth){
    return Column(
      children: <Widget>[
        Text(
          user.getName,
          textAlign: TextAlign.left,
          style: TextStyle( fontSize: 28 ),
        ),
        Text(
          user.getLocation,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromARGB(255, 159, 159, 159),
            fontSize: 15,
          ),
        ),
        SizedBox(height: 16),
        // description
        Container(
          width: screenWidth/1.2,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  user.getDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle( fontSize: 17 ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialButtons(double screenWidth){
    return Container(
      width: screenWidth/1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CometIconButton(Icons.message),
          Spacer(),
          Flexible(
            flex: 8,
            child: Container(
              // width: 175,
              height: 45,
              decoration: BoxDecoration(
                color: _appTheme.mainColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(90, 0, 0, 0),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(22.5)),
              ),
              child: Center(
                child: Text(
                  "Follow",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          CometIconButton(Icons.share),
        ],
      ),
    );
  }

  Widget _stats(double screenWidth){
    return Container(
      width: screenWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Spacer(),
          // following
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Container(
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    user.getFollowing.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23),
                  ),
                ),
                Text(
                  "Following",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _appTheme.miniText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: 1,
            height: 49,
            decoration: BoxDecoration(
              color: _appTheme.lineBorder,
            ),
            child: Container(),
          ),
          Spacer(),
          // followers
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  user.getFollowers.length.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23),
                ),
              ),
              Text(
                "Followers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _appTheme.miniText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 1,
            height: 49,
            decoration: BoxDecoration(
              color: _appTheme.lineBorder,
            ),
            child: Container(),
          ),
          Spacer(),
          // events
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Container(
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    user.getEvents.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23),
                  ),
                ),
                Text(
                  "Events",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _appTheme.miniText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Widget _followerList(){
    return UserList(
      title: 'Followers',
      users: <UserIcon>[
        UserIcon(
          url: 'https://flutter.dev/images/catalog-widget-placeholder.png',
          first: 'Flutter'
        )
      ]
    );
  }

  Widget _eventList(){
    return EventList(
      title: 'Last Two Events',
      eventTiles: [
        EventTile(
          imageURL: 'https://img.stackshare.io/service/1161/vI0ZZlhZ_400x400.png',
          title: 'Socket.io Workshop Workshop Workshop',
          date: 'Aug 21',
          category: 'education',
          tags: ['coding', 'workshop', 'something', 'anothertag'],
          description: 'description description description description description description description description description',
        ),
        EventTile(
          imageURL: 'https://img.stackshare.io/service/1161/vI0ZZlhZ_400x400.png',
          title: 'Socket.io Workshop Workshop Workshop',
          date: 'Aug 21',
          category: 'education',
          tags: ['coding', 'workshop', 'something', 'anothertag'],
          description: 'description description description description description description description description description',
        ),
      ]
    );
  }

}

