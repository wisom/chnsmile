class ContactDepartModel {
  List<DeptInfo> deptInfo;
  List<UserInfo> userInfo;

  ContactDepartModel({this.deptInfo, this.userInfo});

  ContactDepartModel.fromJson(Map<String, dynamic> json) {
    if (json['deptInfo'] != null) {
      deptInfo = new List<DeptInfo>();
      json['deptInfo'].forEach((v) {
        deptInfo.add(new DeptInfo.fromJson(v));
      });
    }
    if (json['userInfo'] != null) {
      userInfo = new List<UserInfo>();
      json['userInfo'].forEach((v) {
        userInfo.add(new UserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deptInfo != null) {
      data['deptInfo'] = this.deptInfo.map((v) => v.toJson()).toList();
    }
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeptInfo {
  String id;
  String parentId;
  String title;
  int unCountMessage;
  String value;
  int weight;
  List<Children> children;
  String pid;
  bool selected;

  DeptInfo(
      {this.id,
        this.parentId,
        this.title,
        this.value,
        this.unCountMessage,
        this.weight,
        this.children,
        this.selected = false,
        this.pid});

  DeptInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    title = json['title'];
    unCountMessage = json['unCountMessage'];
    value = json['value'];
    weight = json['weight'];
    selected = false;
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
    pid = json['pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['title'] = this.title;
    data['value'] = this.value;
    data['selected'] = this.selected;
    data['unCountMessage'] = this.unCountMessage;
    data['weight'] = this.weight;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['pid'] = this.pid;
    return data;
  }
}

class Children {
  String id;
  String parentId;
  String title;
  String value;
  int weight;
  List<Children> children;
  String pid;

  Children(
      {this.id,
        this.parentId,
        this.title,
        this.value,
        this.weight,
        this.children,
        this.pid});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    title = json['title'];
    value = json['value'];
    weight = json['weight'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
    pid = json['pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['title'] = this.title;
    data['value'] = this.value;
    data['weight'] = this.weight;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['pid'] = this.pid;
    return data;
  }
}

class UserInfo {
  String orgId;
  String orgName;
  String userId;
  String teacherId;
  String userName;
  String gender;
  int sex;
  String avatarImg;
  String floor;
  bool selected;

  UserInfo(
      {this.orgId,
        this.orgName,
        this.userId,
        this.teacherId,
        this.userName,
        this.gender,
        this.sex,
        this.selected = false,
        this.avatarImg});

  UserInfo.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    orgName = json['orgName'];
    userId = json['userId'];
    teacherId = json['teacherId'];
    userName = json['userName'];
    gender = json['gender'];
    sex = json['sex'];
    selected = false;
    avatarImg = json['avatarImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['userId'] = this.userId;
    data['teacherId'] = this.teacherId;
    data['userName'] = this.userName;
    data['gender'] = this.gender;
    data['sex'] = this.sex;
    data['selected'] = this.selected;
    data['avatarImg'] = this.avatarImg;
    return data;
  }
}

