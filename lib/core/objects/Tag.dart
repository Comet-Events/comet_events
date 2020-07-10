class Tag {
  Category category;
  String name;
  int popularity;

  Tag({this.category, this.name, this.popularity});

  Tag.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    name = json['name'] ?? "n/a";
    popularity = json['popularity'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['name'] = this.name ?? "n/a";
    data['popularity'] = this.popularity ?? 1;
    return data;
  }
}

class Category {
  bool category;
  int iconCode;

  Category({this.category, this.iconCode});

  Category.fromJson(Map<String, dynamic> json) {
    category = json['category'] ?? true;
    iconCode = int.parse(json['iconCode']) ?? 0xe000;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category ?? true;
    data['iconCode'] = this.iconCode.toString() ?? "0xe000";
    return data;
  }
}