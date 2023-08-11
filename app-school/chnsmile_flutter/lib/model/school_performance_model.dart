import 'package:chnsmile_flutter/model/behavior.dart';
import 'package:chnsmile_flutter/model/student_info.dart';

class SchoolPerformanceModel {
  StudentInfo studentInfo;
  BehaviorInfo behavior;

  SchoolPerformanceModel({this.studentInfo, this.behavior});

  SchoolPerformanceModel.fromJson(Map<String, dynamic> json) {
    studentInfo = json['studentInfo'] != null
        ? new StudentInfo.fromJson(json['studentInfo'])
        : null;
    behavior = json['behavior'] != null
        ? new BehaviorInfo.fromJson(json['behavior'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentInfo != null) {
      data['studentInfo'] = this.studentInfo.toJson();
    }
    if (this.behavior != null) {
      data['behavior'] = this.behavior.toJson();
    }
    return data;
  }
}

class BehaviorInfo {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Performance> rows;

  BehaviorInfo(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  BehaviorInfo.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<Performance>();
      json['rows'].forEach((v) {
        rows.add(new Performance.fromJson(v));
      });
    }
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
    return data;
  }
}

class Performance {
  String title;
  String id;
  String createTime;
  String teacherId;
  String teacherName;
  List<Behavior> contentResults;

  Performance(
      {this.title,
        this.id,
        this.createTime,
        this.teacherId,
        this.teacherName,
        this.contentResults});

  Performance.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    createTime = json['createTime'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    if (json['contentResults'] != null) {
      contentResults = new List<Behavior>();
      json['contentResults'].forEach((v) {
        contentResults.add(new Behavior.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    if (this.contentResults != null) {
      data['contentResults'] =
          this.contentResults.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

