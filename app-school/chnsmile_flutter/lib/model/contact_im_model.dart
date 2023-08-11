class ContactIMModel {
  List<ContactIM> list;

  ContactIMModel.fromJson(List json) {
    if (json != null) {
      list = List<ContactIM>.empty(growable: true);
      json.forEach((v) {
        list.add(ContactIM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ContactIM {
  String toUserId;
  String toUserName;
  String toUserAvatarImg;
  String unreadMsgNum;
  List<String> studentName;
  String parentName;
  String teacherName;
  String className;
  String showName;

  ContactIM(
      {this.toUserId,
        this.toUserName,
        this.toUserAvatarImg,
        this.unreadMsgNum,
        this.studentName,
        this.teacherName = "",
        this.parentName = "",
        this.showName = "",
        this.className = ""});

  ContactIM.fromJson(Map<String, dynamic> json) {
    toUserId = json['toUserId'];
    toUserName = json['toUserName'];
    toUserAvatarImg = json['toUserAvatarImg'];
    unreadMsgNum = json['unreadMsgNum'];
    studentName = json['studentName'] != null ? json['studentName'].cast<String>() : [];
    teacherName = json['teacherName'];
    parentName = json['parentName'];
    className = json['className'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toUserId'] = this.toUserId;
    data['toUserName'] = this.toUserName;
    data['toUserAvatarImg'] = this.toUserAvatarImg;
    data['unreadMsgNum'] = this.unreadMsgNum;
    data['studentName'] = this.studentName;
    data['teacherName'] = this.teacherName;
    data['parentName'] = this.parentName;
    data['className'] = this.className;
    return data;
  }
}
