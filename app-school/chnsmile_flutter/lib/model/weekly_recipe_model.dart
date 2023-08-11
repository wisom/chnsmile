class WeeklyRecipeModel {
  int total;
  List<WeeklyRecipe> list;

  WeeklyRecipeModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<WeeklyRecipe>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(WeeklyRecipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalRows'] = total;
    data['rows'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class WeeklyRecipe {
  String title;
  String author;
  String topImg;
  String intro;
  String publishTime;
  String pageUrl;

  WeeklyRecipe(
      {
        this.title,
        this.author,
        this.topImg,
        this.intro,
        this.publishTime,
        this.pageUrl});

  WeeklyRecipe.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    topImg = json['topImg'];
    intro = json['intro'];
    publishTime = json['publishTime'];
    pageUrl = json['pageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['author'] = author;
    data['topImg'] = topImg;
    data['intro'] = intro;
    data['publishTime'] = publishTime;
    data['pageUrl'] = pageUrl;
    return data;
  }
}
