class EventFilters{
  double distanceRadius;
  DateTime startRangeStart;
  DateTime startRangeEnd;
  DateTime endRangeStart;
  DateTime endRangeEnd;
  List<String> tags;
  List<String> categories;

  EventFilters({
    this.distanceRadius = 0.0,
    this.tags,
    this.categories
  }){
      this.tags = [];
      this.categories = [];
    }

  Map<String, dynamic> get map{
    return{
      "distanceRadius": distanceRadius,
      "startRangeStart": startRangeStart,
      "startRangeEnd": startRangeEnd,
      "endRangeStart": endRangeStart,
      "endRangeEnd": endRangeEnd,
      "tags": tags,
      "categories": categories
    };
  }  
}