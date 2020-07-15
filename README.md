# comet events
☄️ | A 📱 app that makes finding events and gatherings easier!

This app provides a way for people to find and host events happening near them in real time. The user can pop open the app and see a map of all the events happening within their proximity on the spot. The location spots are marked with a pin, that varies in color and shape based on the type of event. You can also premiere events happening soon, which will show an event countdown. Tapping on an event will take you to a detail page, where you can see the event name, description, rating, a list people attending the event, and an RSVP option you can press to indicate you are joining. 

## Contributers 
  * [Neha Rode](https://github.com/Neha-Rode)
  * [Soham Mukherjee](https://github.com/Zakenmaru)
  * [Emily Lam](https://github.com/ejlam)
  * [Vishvak Bandi](https://github.com/VishvakBandi)
  * [Swaraaj Bhattacharya](https://github.com/swarj)
  * [Bach Nguyen](https://github.com/bachnguyenTE)
  * [Trevor Tomer](https://github.com/Tmtomer)
  * [Jafar](https://github.com/jafrilli)
  Design
  * [Zach Allen]
  * [Jimmy]

## Minimum Viable Product 

  ### Backend & Middleware
  * Flutter State Management System
    * Setup a state management system using the [Provider](https://pub.dev/packages/provider) and [GetIt](https://pub.dev/packages/get_it) packages from [pub.dev](http://pub.dev)
  * Setup Firebase
    * Setup Flutter project to work with Firebase
    * Setup authentication methods in Firebase
    * Setup Firestore permissions
  * Database Architecture
    * Design a database architecture that efficiently stores and retrieves data
    * Design a schema for events that makes it easy to retrieve events based on geolocation
    * Design a schema for users and enhanced users
    * Design an efficient system to store user followers
  * Setup services (classes) in Flutter
    * Setup Firebase Auth service, including a StreamController for the current user
    * Setup Google Maps Platform services
    * Setup Firestore & Storage service
  * Work with frontend team to create view models for each screen
  * Come up with ways to efficiently retrieve data from the database without sacrificing speed, and lowers cost of operation
    
  ### Frontend & UI
  * Clean, custom-designed mockup for UI, as well as branding
    * Primary and secondary fonts
    * Color palette
    * Clean ass shit u feel me
  * Login and register UI screens
    * Buttons that support different methods of sign-in and registration
    * Button that allows user to apply for an organization account (enhanced features)
  * A Google Maps integrated home page that displays nearby events
    * Different pin sprites for event types, including a 'countdown' pin that features a timer for premiering events
    * Custom Google Maps colors that follow our branding guidelines
    * Scroll view that displays buttons containing some details of the event in focus, and redirect to a details screen
    * Filter UI popup that allows user to filter events based on a variety of variables
  * Details screen that displays details of the event
    * Detail screen that follows the mockup design
    * Tappable address redirects to a navigation app with the address autofilled
    * A button that opens a text UI that shows special instructions to get to the event
    * A list of people attending the event (list starts with people you follow) depending on whether this feature is enabled or not
  * Profile screen
    * Profile screen that follows the mockup design
    * Edit mode (viewstate that allows elements to be edited), with a save button
    * List of past hosted events
    * Toggle between open follow and 'invite-to-follow'
    * 'Host an event' button, that redirects to an event setup screen
  * Event setup screen
    * Event setup screen that follows the mockup design, and has a field for each element in the event data structure
    * Toggle between allowing people to see list of attendees
    * Tag list
    * Premiere toggle, and what time
  * Settings screen
    * Choose notification settings, and account deletion
   
   
## Resources 

### APIs
  * [⭐️ Google Maps Platform API](https://cloud.google.com/maps-platform/)
  
### Database
  * [⭐️ Firebase](https://www.firebase.google.com/)
  
### Cross-Platform Frameworks
  * [⭐️ Flutter](https://flutter.dev)

### Prototyping
  * [Figma](https://www.figma.com/)
  * [Sketch](https://www.sketch.com)
  * [⭐️ InVision Studio](https://www.adobe.com/products/illustrator.html)
  
### Text Editiors and IDEs
  * [⭐️ Visual Studio](https://visualstudio.microsoft.com/) good version control system
