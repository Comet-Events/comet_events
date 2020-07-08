class EventFilters{
  double radius;
  DateTime startRangeStart;
  DateTime startRangeEnd;
  DateTime endRangeStart;
  DateTime endRangeEnd;
  List<String> tags;
  List<String> categories;

  EventFilters({
    this.radius = 20,
    this.tags,
    this.categories
  }){
      this.tags = [];
      this.categories = [];
    }

  Map<String, dynamic> get map{
    return{
      "radius": radius,
      "startRangeStart": startRangeStart,
      "startRangeEnd": startRangeEnd,
      "endRangeStart": endRangeStart,
      "endRangeEnd": endRangeEnd,
      "tags": tags,
      "categories": categories
    };
  }  
}