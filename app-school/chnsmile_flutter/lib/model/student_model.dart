import 'package:chnsmile_flutter/model/family_info.dart';
import 'package:chnsmile_flutter/model/student_info.dart';

class StudentModel {
  List<Student> list;

  StudentModel.fromJson(List json) {
    if (json != null) {
      list = List<Student>.empty(growable: true);
      json.forEach((v) {
        list.add(Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class Student {
  String account;
  String deployType;
  String hostUrl;
  String hostUrl1;
  String onlineState;
  String studentName;
  String studentId;

  Student(
      {this.account,
        this.deployType,
        this.hostUrl,
        this.hostUrl1,
        this.onlineState,
        this.studentName,
        this.studentId});

  Student.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    deployType = json['deployType'];
    hostUrl = json['hostUrl'];
    hostUrl1 = json['hostUrl1'];
    onlineState = json['onlineState'];
    studentName = json['studentName'];
    studentId = json['studentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['deployType'] = this.deployType;
    data['hostUrl'] = this.hostUrl;
    data['hostUrl1'] = this.hostUrl1;
    data['onlineState'] = this.onlineState;
    data['studentName'] = this.studentName;
    data['studentId'] = this.studentId;
    return data;
  }
}


