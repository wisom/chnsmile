import 'package:chnsmile_flutter/model/family_info.dart';
import 'package:chnsmile_flutter/model/student_info.dart';

class ProfileModel {
  FamilyInfo parentInfo;
  StudentInfo studentInfo;
  List<Child> childList;

  ProfileModel({this.parentInfo, this.studentInfo, this.childList});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    parentInfo = json['parentInfo'] != null
        ? new FamilyInfo.fromJson(json['parentInfo'])
        : null;
    studentInfo = json['studentInfo'] != null
        ? new StudentInfo.fromJson(json['studentInfo'])
        : null;
    if (json['childList'] != null) {
      childList = new List<Child>();
      json['childList'].forEach((v) {
        childList.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parentInfo != null) {
      data['parentInfo'] = this.parentInfo.toJson();
    }
    if (this.studentInfo != null) {
      data['studentInfo'] = this.studentInfo.toJson();
    }
    if (this.childList != null) {
      data['childList'] = this.childList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String studentId;
  String studentName;
  String schoolId;

  Child({this.studentId, this.studentName, this.schoolId});

  Child.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    schoolId = json['schoolId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    data['schoolId'] = this.schoolId;
    return data;
  }
}

