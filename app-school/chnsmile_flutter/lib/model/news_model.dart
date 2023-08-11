class NewsModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<News> rows;
  List<int> rainbow;

  NewsModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  NewsModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<News>();
      json['rows'].forEach((v) {
        rows.add(new News.fromJson(v));
      });
    }
    rainbow = json['rainbow'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['rainbow'] = this.rainbow;
    return data;
  }
}

class News {
  String title;
  String author;
  String topImg;
  String intro;
  String publishTime;
  String pageUrl;

  News(
      {this.title,
        this.author,
        this.topImg,
        this.intro,
        this.publishTime,
        this.pageUrl});

  News.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    topImg = json['topImg'];
    intro = json['intro'];
    publishTime = json['publishTime'];
    pageUrl = json['pageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['author'] = this.author;
    data['topImg'] = this.topImg;
    data['intro'] = this.intro;
    data['publishTime'] = this.publishTime;
    data['pageUrl'] = this.pageUrl;
    return data;
  }
}
