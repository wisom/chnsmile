class WxInfoModel {
  List<WxInfo> list = [];

  WxInfoModel.fromJson(List<dynamic> json) {
    if (json != null && json.isNotEmpty) {
      list.clear();
      json.forEach((v) {
        list.add(WxInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class WxInfo {
  String city;
  String country;
  String headimgurl;
  String language;
  String nickname;
  String openid;
  List<String> privilege;
  String province;
  int sex;
  String unionid;

  WxInfo({
    this.city,
    this.country,
    this.headimgurl,
    this.language,
    this.nickname,
    this.openid,
    this.privilege,
    this.province,
    this.sex,
    this.unionid,
  });

  WxInfo.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    headimgurl = json['headimgurl'];
    language = json['language'];
    nickname = json['nickname'];
    openid = json['openid'];
    province = json['province'];
    sex = json['sex'];
    unionid = json['unionid'];
    if (json['privilege'] != null) {
      privilege = List<String>.empty(growable: true);
      json['privilege'].forEach((v) {
        privilege.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['headimgurl'] = this.headimgurl;
    data['language'] = this.language;
    data['nickname'] = this.nickname;
    data['openid'] = this.openid;
    data['privilege'] = this.privilege;
    data['province'] = this.province;
    data['sex'] = this.sex;
    data['unionid'] = this.unionid;
    return data;
  }
}
