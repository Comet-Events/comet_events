import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/widgets/tag_category.dart';
import 'package:comet_events/ui/widgets/upload_image.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:place_picker/place_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';


extension on DateTime{
  /// Checks if the dates are the same down to the minute
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day && this.hour == other.hour && this.minute == other.minute;
  }

  DateTime resetToDayStart() {
    return DateTime(this.year, this.month, this.day);
  }
}

class AddEventModel extends ChangeNotifier {

  // * ------ SERVICES ------
  EventService _events = locator<EventService>();
  TagsService _tags = locator<TagsService>();
  RemoteConfigService _rc = locator<RemoteConfigService>();
  NavigationService _navigate = locator<NavigationService>();
  SnackbarService _snack = locator<SnackbarService>(); // yum
  StorageService _storage = locator<StorageService>();

  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  int premiereHours;
  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;
  Event newEvent = Event();
  Dates newDates = Dates();
  Location newLocation = Location();
  Stats newStats = Stats(likes: [], rsvps: []);
  Settings newSettings = Settings();
  Asset coverImage;
  List<Asset> images = [];

  bool loading = false;
  CategoryPickerController categoryController = CategoryPickerController();
  TagPickerController tagController = TagPickerController();
  List<Tag> categories = [];
  // List<FirebaseStorageResult> images = [];
  // Timestamp premiere;
  // Timestamp start;
  // Timestamp end;
  // List<Tag> category;
  // List<Tag> tags;
  // Geo geo;

  TextEditingController get name => _name;
  TextEditingController get description => _description;

  void fetchCategories() async {
    categoryController.categories = await _tags.fetchCategories();
    notifyListeners();
  }

  void cometSnackBar({String title, String message, IconData iconData = Icons.error, Duration duration = const Duration(seconds: 8)}) {
    _snack.showCustomSnackBar(
      title: title,
      message: message,
      icon: Icon(iconData),
      duration: duration,
      borderRadius: 15,
      shouldIconPulse: true,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
  // ! Validator function !
  bool validateDetails() {
    int minName = 3;
    int maxName = 30;
    int minDescription = 0;
    int maxDescription = 200;
    Duration snackDuration = Duration(seconds: 10);
    // run a bunch of validating checks
    // * name & description check
    if(name.text.length > maxName || name.text.length < minName) {
      cometSnackBar(
        title: "Name Invalid",
        message: "The name of your event has an invalid length! It should be between $minName & $maxName characters. It's currently ${name.text.length} characters long.",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    }
    if(description.text.length > maxDescription || description.text.length < minDescription) {
      cometSnackBar(
        title: "Description Invalid",
        message: "The description of your event has an invalid length! It should be between $minDescription & $maxDescription characters. It's currently ${description.text.length} characters long.",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    }

    // * time check
    if(startDate.isSameDate(endDate)) {
      cometSnackBar(
        title: "Dates Invalid",
        message: "Your start and end dates cannot be the same!",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    } else if(startDate.compareTo(endDate) > 0) {
      cometSnackBar(
        title: "Start Date Invalid",
        message: "Your start date can't be after your end date genius smh",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    } 

    // * tag check
    // nothing really needs to be checked yet

    // * location check
    if(newLocation.geo == null) {
      cometSnackBar(
        title: "No Location",
        message: "A location is required! You must select a location",
        iconData: Icons.error,
        duration: snackDuration,
      );
      return false;
    }

    return true;
  }

  // ! Create event function !
  void createEvent() async {
    // configure dates
    startDate = startDate.add(Duration(hours: startTime.hour, minutes: startTime.minute));
    endDate = endDate.add(Duration(hours: endTime.hour, minutes: endTime.minute));

    // validate
    bool valid = validateDetails();
    // if not valid reset date values to prevent time from stacking, and return
    if(!valid) {
      startDate = startDate.resetToDayStart();
      endDate = endDate.resetToDayStart();
      return;
    }

    // add event to firebase
    loading = true;
    notifyListeners();

    Uuid uuid = Uuid();
    String postID = uuid.v1();

    // * setup images
    String coverUrl;
    if(coverImage != null) {
      FirebaseStorageResult coverResult = await _storage.uploadImage(imageToUpload: coverImage, title: postID);
      if(coverResult.success && coverResult.imageUrl != null) coverUrl = coverResult.imageUrl;
    }
    List<String> imageUrls = [];
    for(int i = 0; i < images.length; i++) {
      FirebaseStorageResult result = await _storage.uploadImage(imageToUpload: images[i], title: "${postID}_${i+1}");
      if(result.success && result.imageUrl != null) imageUrls.add(result.imageUrl);
    }
    if(coverUrl == null && imageUrls.length > 0) {
      coverUrl = imageUrls[0];
      imageUrls.remove(coverUrl);
    }

    // * data is valid

    newEvent.coverImage = coverUrl ?? "";
    newEvent.images = imageUrls ?? [];
    // set up firebase timestamps and other fields
    newDates.premiere = Timestamp.fromDate(startDate.subtract(Duration(hours: premiereHours)));
    newDates.start = Timestamp.fromDate(startDate);
    newDates.end = Timestamp.fromDate(endDate);
    newEvent.name = name.text;
    newEvent.description = description.text;
    newEvent.active = startDate.isBefore(DateTime.now());

    newEvent.dates = newDates;
    newEvent.location = newLocation;
    newEvent.stats = newStats;
    newEvent.settings = newSettings;

    
    /// * ----firebase----
    await _events.addNewEvent(newEvent, postID);
    // can be syncronous
    _tags.incrementTags(newEvent.tags);
    _tags.incrementCategories(newEvent.categories);

    /// * ----firebase----
    loading = false;
    notifyListeners();

    // pop back to home screen
    _navigate.popRepeated(1);
  }

  // image functions
  void viewFullScreen(Asset img){
    _navigate.navigateWithTransition(
      FullImageScreen(image: img),
      opaque: false,
      transition: NavigationTransition.Fade
    );
  }


  // * ----- onChange handlers -----
  // dates and times
  premiereOnChange(int hour) { premiereHours = hour; }
  startDateOnChange(DateTime date) { startDate = date.resetToDayStart(); }
  startTimeOnChange(TimeOfDay time) { startTime = time; }
  endDateOnChange(DateTime date) { endDate = date.resetToDayStart(); }
  endTimeOnChange(TimeOfDay time) { endTime = time; }

  // categories and tags
  categoryOnChange(List<Tag> categories) { newEvent.categories = categories.map((e) => e.name).toList(); }
  tagsOnChange(List<String> tags) { newEvent.tags = tags; }

  //images
  imageOnChange(List<Asset> imgs, Asset coverImg) { images = imgs ?? []; coverImage = coverImg; }

  // location
  void showPlacePicker(BuildContext context) async {
    loading = true;
    notifyListeners();

    await _rc.fetch();
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
        PlacePicker(
          _rc.remoteConfig.getString('google_places_key')
        )));
    
    if(result != null) {
      newLocation = Location(
        geo: Geo(
          geohash: GeoHasher().encode(result.latLng.longitude, result.latLng.latitude),
          geopoint: GeoPoint(result.latLng.latitude, result.latLng.longitude),
        ),
        address: Address( 
          fullAddress: result.formattedAddress,
          fullStreet: "${result.name} ${result.locality}",
          streetNum: result.name,
          street: result.subLocalityLevel2.name,
          city: result.city.name,
          state: result.administrativeAreaLevel2.name != null ? result.administrativeAreaLevel2.name : null,
          country: result.country.name
        )
      );
      loading = false;
      notifyListeners();
      // print(result.administrativeAreaLevel1.name);
      // print(result.administrativeAreaLevel2.name);
      // print(result.subLocalityLevel1.name);
      // print(result.subLocalityLevel2.name);
      // print("${result.name} ${result.locality}");
    }
  }

}