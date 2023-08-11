import 'package:chnsmile_flutter/model/student_info.dart';

class GrowthFileModel {
  StudentInfo studentInfo;
  Growtharchive growtharchive;

  GrowthFileModel({this.studentInfo, this.growtharchive});

  GrowthFileModel.fromJson(Map<String, dynamic> json) {
    studentInfo = json['studentInfo'] != null
        ? new StudentInfo.fromJson(json['studentInfo'])
        : null;
    growtharchive = json['growtharchive'] != null
        ? new Growtharchive.fromJson(json['growtharchive'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentInfo != null) {
      data['studentInfo'] = this.studentInfo.toJson();
    }
    if (this.growtharchive != null) {
      data['growtharchive'] = this.growtharchive.toJson();
    }
    return data;
  }
}

class Growtharchive {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Growth> rows;
  List<int> rainbow;

  Growtharchive(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  Growtharchive.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<Growth>();
      json['rows'].forEach((v) {
        rows.add(new Growth.fromJson(v));
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

class Growth {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String formId;
  String studentId;
  String classId;
  String teacherId;
  String teacherName;
  String timeInfo;
  String archiveContent;
  int status;
  String schoolId;
  String publishTime;
  String studentScope;
  String studentName;

  Growth(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.formId,
        this.studentId,
        this.classId,
        this.teacherId,
        this.teacherName,
        this.timeInfo,
        this.archiveContent,
        this.status,
        this.schoolId,
        this.publishTime,
        this.studentScope,
        this.studentName});

  Growth.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    formId = json['formId'];
    studentId = json['studentId'];
    classId = json['classId'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    timeInfo = json['timeInfo'];
    archiveContent = json['archiveContent'];
    status = json['status'];
    schoolId = json['schoolId'];
    publishTime = json['publishTime'];
    studentScope = json['studentScope'];
    studentName = json['studentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['studentId'] = this.studentId;
    data['classId'] = this.classId;
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['timeInfo'] = this.timeInfo;
    data['archiveContent'] = this.archiveContent;
    data['status'] = this.status;
    data['schoolId'] = this.schoolId;
    data['publishTime'] = this.publishTime;
    data['studentScope'] = this.studentScope;
    data['studentName'] = this.studentName;
    return data;
  }
}
