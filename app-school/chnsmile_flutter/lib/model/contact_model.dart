import 'package:chnsmile_flutter/model/attach.dart';

class ContactModel {
  List<Contact> list;

  ContactModel.fromJson(List json) {
    if (json != null) {
      list = List<Contact>.empty(growable: true);
      json.forEach((v) {
        list.add(Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contact {
  String teacherId;
  String className;
  String classGradeName;
  String courseName;
  String avatarImg;
  String teacherName;
  String unreadMsgNum;
  String userId;
  int isHeader;

  Contact(
      {this.teacherId,
        this.className,
        this.classGradeName,
        this.courseName,
        this.avatarImg,
        this.teacherName,
        this.unreadMsgNum,
        this.userId,
        this.isHeader});

  Contact.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    className = json['className'];
    classGradeName = json['classGradeName'];
    courseName = json['courseName'];
    avatarImg = json['avatarImg'];
    teacherName = json['teacherName'];
    unreadMsgNum = json['unreadMsgNum'];
    userId = json['userId'];
    isHeader = json['isHeader'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['className'] = this.className;
    data['classGradeName'] = this.classGradeName;
    data['courseName'] = this.courseName;
    data['avatarImg'] = this.avatarImg;
    data['teacherName'] = this.teacherName;
    data['unreadMsgNum'] = this.unreadMsgNum;
    data['userId'] = this.userId;
    data['isHeader'] = this.isHeader;
    return data;
  }
}
