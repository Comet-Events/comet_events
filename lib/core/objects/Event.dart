class Event {
  String name;
  String description;
  String category;
  String date;
  List<String> tags;
  List<String> rsvps;
  List<String> likes;
  Location location;

  Event(
      {this.name,
      this.description,
      this.category,
      this.date,
      this.tags,
      this.rsvps,
      this.likes,
      this.location});

  Event.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    category = json['category'];
    date = json['date'];
    tags = json['tags'].cast<String>();
    rsvps = json['rsvps'].cast<String>();
    likes = json['likes'].cast<String>();
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    data['date'] = this.date;
    data['tags'] = this.tags;
    data['rsvps'] = this.rsvps;
    data['likes'] = this.likes;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  String geohash;
  Address address;

  Location({this.geohash, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    geohash = json['geohash'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geohash'] = this.geohash;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Address {
  String street;
  int number;
  String type;
  String country;
  String city;
  String state;
  int zip;

  Address(
      {this.street,
      this.number,
      this.type,
      this.country,
      this.city,
      this.state,
      this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    number = json['number'];
    type = json['type'];
    country = json['country'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['number'] = this.number;
    data['type'] = this.type;
    data['country'] = this.country;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    return data;
  }
}