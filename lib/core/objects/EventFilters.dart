class EventFilters{
  double distanceRadius;
  DateTime startTime;
  DateTime endTime;
  List<String> tags;
  List<String> categories;

  EventFilters({
    this.distanceRadius = 0.0,
    this.startTime,
    this.endTime,
    this.tags,
    this.categories
  }){
      this.tags = [];
      this.categories = [];
    }

  Map<String, dynamic> get map{
    return{
      "distanceRadius": distanceRadius,
      "startTime": startTime,
      "endTime": endTime,
      "tags": tags,
      "categories": categories
    };
  }  
}