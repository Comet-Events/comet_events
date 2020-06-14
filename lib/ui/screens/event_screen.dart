import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/comet_buttons.dart';
import 'package:comet_events/ui/widgets/event_list.dart';
import 'package:comet_events/ui/widgets/event_tile.dart';
import 'package:comet_events/ui/widgets/user_list.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class EventScreen extends StatelessWidget {
  
  EventScreen({Key key}) : super(key: key);


  // Dummy Event

  Event event = Event(
    name: "Socket.io workshop wooo coding", 
    description: "I’m an influencer, world wide chad. I’m really into anime I love anime I’m kinda weeb quirky hehe.",
    instructions: List.filled(5, "second door on your left as soon as you walk in", growable: true),
    host: "Jafar A.",
    active: true,
    dates: Dates (start: Timestamp.fromDate(DateTime.now())), 
    tags: List.filled(5, "coding", growable: true),
    category: 'education',
    stats: Stats(rsvps: List.filled(1, "32"), likes: List.filled(1, "100")),
    location: Location(geo: Geo(geohash: "UT Dallas", geopoint: GeoPoint(33, 97)) , address: Address(text: "800 W Campbell Rd, Richardson, TX 75080" )),
    settings: Settings(followersOnly: false, hideOnStart: false, hideRSVPs: false)

  );

  final List<String> imageURLs = [
    'https://i.picsum.photos/id/866/536/354.jpg',
    'https://i.picsum.photos/id/866/536/354.jpg',
    'https://picsum.photos/200',
    'https://picsum.photos/200'
  ];

  final String category = 'education';

  final List<String> tags = [
    'coding', 'workshop', 'learning', 'another', 'and-another'
  ];

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return Scaffold(
      backgroundColor: _appTheme.secondaryMono,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: _appTheme.mainMono,
                child: Column(
                  children: <Widget>[
                    // 'appbar'
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16),
                          child: Icon(Icons.arrow_back, size: 35),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, right: 16),
                          child: Icon(Icons.more_horiz, size: 35),
                        )
                      ],
                    ),
                    // image carousel
                    CarouselSlider(
                      items: [
                        ...imageURLs.map((url) {
                          return Container(
                            width: MediaQuery.of(context).size.width/1.3,
                            // height: 300,
                            decoration: BoxDecoration(
                              color: _appTheme.secondaryMono,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(url, fit: BoxFit.contain)
                            ),
                          );
                        })
                      ],
                      options: CarouselOptions(
                        // height: 90,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (number, reason) {},
                        scrollDirection: Axis.horizontal,
                      )
                    ),
                    SizedBox(height: 12),
                    // name & details
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.name,
                          style: TextStyle( fontSize: 28 ),
                        ),
                        // location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Starts at ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 159, 159, 159),
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              event.dates.start.toString(),
                              style: TextStyle(
                                color: _appTheme.mainColor,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              event.location.address.text,
                              style: TextStyle(
                                color: _appTheme.mainColor,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              ", " + event.location.geo.geohash.toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 159, 159, 159),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ),
                    SizedBox(height: 3),
                    // tags
                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          CategoryChip(
                            category,
                            fontSize: 12,
                            spacing: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.only(top: 10, right: 6),
                          ),
                          ...tags.map((tag) {
                            return TagChip(
                              tag,
                              fontSize: 12,
                              spacing: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: EdgeInsets.only(top: 10, right: 6),
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(height: 13),
                    // description
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              event.description,
                              textAlign: TextAlign.center,
                              style: TextStyle( fontSize: 14 ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 13),
                    // RSVP button
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 45,
                      // margin: const EdgeInsets.all(20.0),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "RSVP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lexend Deca",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    // buttons
                    Container(
                      width: MediaQuery.of(context).size.width/1.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CometIconButton(Icons.share),
                          Spacer(flex: 1),
                          CometIconButton(Icons.favorite),
                          Spacer(flex: 10),
                          CometIconButton(Icons.assignment),
                          Spacer(flex: 1),
                          CometIconButton(Icons.navigation),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    // statistics
                    Stack(
                      alignment: Alignment.center,
                      overflow: Overflow.visible,
                      children: [
                        Positioned(
                          top: -45,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2, 
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.elliptical(54.0, 54.0)),
                              child: Image.network('https://img.stackshare.io/service/1161/vI0ZZlhZ_400x400.png', fit: BoxFit.cover)
                            )
                          ),
                        ),             
                        Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Spacer(),
                            // rsvps
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    // margin: EdgeInsets.symmetric(horizontal: 13),
                                    child: Text(
                                      event.stats.rsvps.toString().replaceAll("[", "").replaceAll("]", ""),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 23),
                                    ),
                                  ),
                                  Text(
                                    "RSVPs",
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
                            // host
                            Column(
                                children: [
                                  Text(
                                    event.host,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 23,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          offset: Offset(0, 1),
                                          blurRadius: 7,
                                        )
                                      ]
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Host",
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
                            // likes
                            Flexible(
                              flex: 2,
                                child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    // margin: EdgeInsets.symmetric(horizontal: 13),
                                    child: Text(
                                      event.stats.likes.toString().replaceAll("[", "").replaceAll("]", ""),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 23),
                                    ),
                                  ),
                                  Text(
                                    "Likes",
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
                          ],
                        ),
                      ),
                      ]
                    ),
                    SizedBox(height: 14)
                  ],
                )
              ),
              SizedBox(height: 10),
              // RSVP list
              UserList(
                title: 'RSVPs',
                onViewAll: () => print('tried to view all of RSVPs'),
                users: <UserIcon>[
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                ]
              ),
              SizedBox(height: 10),
              // Likes List
              UserList(
                title: 'Likes',
                onViewAll: () => print('tried to view all of likes'),
                users: <UserIcon>[
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                  UserIcon(
                    url: 'https://picsum.photos/200',
                    first: 'Bobby'
                  ),
                ]
              ),
              SizedBox(height: 10),
              // Similar Events
              EventList(
                title: 'Similar Events',
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
              ),
            ],
          ),
        ),
      )
    );
  }
}



