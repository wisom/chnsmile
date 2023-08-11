class HomeModel {
  List<BannerModel> bannerList;
  List<CategoryModel> categoryList;
  SchoolProfile schoolProfile;
  String campusInfoBackImage;

  HomeModel.fromJson(Map<String, dynamic> json) {
    campusInfoBackImage = json['campusInfoBackImage'];
    schoolProfile = json['schoolProfile'] != null
        ? SchoolProfile.fromJson(json['schoolProfile'])
        : null;
    if (json['picturePosterList'] != null) {
      bannerList = List<BannerModel>.empty(growable: true);
      json['picturePosterList'].forEach((v) {
        bannerList.add(BannerModel.fromJson(v));
      });
    }
    if (json['beautifulCampusList'] != null) {
      categoryList = List<CategoryModel>.empty(growable: true);
      json['beautifulCampusList'].forEach((v) {
        categoryList.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campusInfoBackImage'] = campusInfoBackImage;
    if (schoolProfile != null) {
      data['schoolProfile'] = schoolProfile.toJson();
    }
    if (bannerList != null) {
      data['bannerList'] = bannerList.map((v) => v.toJson()).toList();
    }
    if (categoryList != null) {
      data['categoryList'] = categoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchoolProfile {
  String title;
  String intro;
  String topImg;
  String pageUrl;

  SchoolProfile({this.title, this.intro, this.topImg, this.pageUrl});

  SchoolProfile.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    intro = json['intro'];
    topImg = json['topImg'];
    pageUrl = json['pageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['intro'] = intro;
    data['topImg'] = topImg;
    data['pageUrl'] = pageUrl;
    return data;
  }
}

class BannerModel {
  String imgUrl;
  String linkUrl;
  int orderNum;

  BannerModel({this.imgUrl, this.linkUrl, this.orderNum});

  BannerModel.fromJson(Map<String, dynamic> json) {
    imgUrl = json['imgUrl'];
    linkUrl = json['linkUrl'];
    orderNum = json['orderNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imgUrl'] = imgUrl;
    data['linkUrl'] = linkUrl;
    data['orderNum'] = orderNum;
    return data;
  }
}

class CategoryModel {
  String title;
  String author;
  String intro;
  String topImg;
  String pageUrl;

  CategoryModel({this.title, this.author, this.intro, this.pageUrl, this.topImg});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    intro = json['intro'];
    topImg = json['topImg'];
    pageUrl = json['pageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['author'] = author;
    data['intro'] = intro;
    data['topImg'] = topImg;
    data['pageUrl'] = pageUrl;
    return data;
  }
}
