import 'dart:core';

class User {
  final String uid;
  final String first;
  final String last;
  final String description;
  final String pfpUrl;
  // ! add birthday

  final List<String> followers;
  final List<String> following;

  final List<String> eventsHosted;
  final List<String> eventsAttended;
  final List<String> eventsLiked;
  
  static const defaultPfp = 'https://i.ibb.co/YfD2TCk/nopfp.png';

  User({
    this.uid = '', 
    this.first = '', 
    this.last = '', 
    this.description = '', 
    this.pfpUrl = defaultPfp,

    this.followers = const [], 
    this.following = const [],

    this.eventsHosted = const [], 
    this.eventsAttended = const [], 
    this.eventsLiked = const [], 
  });

  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'] ?? '',
      first: data['first'] ?? '',
      last: data['last'] ?? '',
      description: data['description'] ?? '',
      pfpUrl: data['pfpUrl'] ?? defaultPfp,

      followers: data['followers'] as List ?? [],
      following: data['following'] as List ?? [],

      eventsHosted: data['eventsHosted'] as List ?? [],
      eventsAttended: data['eventsAttended'] as List ?? [],
      eventsLiked: data['eventsLiked'] as List ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "first": first,
      "last": last,
      "description": description,
      "pfpUrl": pfpUrl,

      "followers": followers,
      "following": following,

      "eventsHosted": eventsHosted,
      "eventsAttended": eventsAttended,
      "eventsLiked": eventsLiked,
    };
  }
}