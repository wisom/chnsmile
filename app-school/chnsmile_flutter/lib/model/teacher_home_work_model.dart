import 'package:chnsmile_flutter/model/attach.dart';

class TeacherHomeWorkModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<HomeWork> rows;
  List<int> rainbow;

  TeacherHomeWorkModel(
      {this.pageNo,
      this.pageSize,
      this.totalPage,
      this.totalRows,
      this.rows,
      this.rainbow});

  TeacherHomeWorkModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<HomeWork>();
      json['rows'].forEach((v) {
        rows.add(new HomeWork.fromJson(v));
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

class HomeWork {
  String createTime;
  String createUser;
  String id;
  String formId;
  String title;
  String content;
  int type;
  String publicUserId;
  String publicUserName;
  String publicOrgId;
  String publicOrgName;
  int status;
  String schoolId;
  int userOperateType;
  int urgencyType;
  String noticeUserSum;
  String noticeUserUnReadNum;
  int hasTeacherAll;
  int hasStudentAll;
  List<Attach> attachInfoList;
  String noticeUserReadNum;
  String publicTime;
  String updateTime;
  String readRecent;

  HomeWork(
      {this.createTime,
        this.createUser,
        this.id,
        this.formId,
        this.title,
        this.content,
        this.type,
        this.publicUserId,
        this.publicUserName,
        this.publicOrgId,
        this.publicOrgName,
        this.status,
        this.schoolId,
        this.userOperateType,
        this.urgencyType,
        this.noticeUserSum,
        this.noticeUserUnReadNum,
        this.publicTime,
        this.updateTime,
        this.hasTeacherAll,
        this.hasStudentAll,
        this.attachInfoList,
        this.noticeUserReadNum,
        this.readRecent});

  HomeWork.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    publicTime = json['publicTime'];
    updateTime = json['updateTime'];
    type = json['type'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicOrgId = json['publicOrgId'];
    publicOrgName = json['publicOrgName'];
    status = json['status'];
    schoolId = json['schoolId'];
    userOperateType = json['userOperateType'];
    urgencyType = json['urgencyType'];
    noticeUserSum = json['noticeUserSum'];
    noticeUserUnReadNum = json['noticeUserUnReadNum'];
    hasTeacherAll = json['hasTeacherAll'];
    hasStudentAll = json['hasStudentAll'];
    if (json['attachInfoList'] != null) {
      attachInfoList = new List<Attach>();
      json['attachInfoList'].forEach((v) {
        attachInfoList.add(new Attach.fromJson(v));
      });
    }
    noticeUserReadNum = json['noticeUserReadNum'];
    readRecent = json['readRecent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['publicTime'] = this.publicTime;
    data['type'] = this.type;
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['publicOrgId'] = this.publicOrgId;
    data['publicOrgName'] = this.publicOrgName;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    data['schoolId'] = this.schoolId;
    data['userOperateType'] = this.userOperateType;
    data['urgencyType'] = this.urgencyType;
    data['noticeUserSum'] = this.noticeUserSum;
    data['noticeUserUnReadNum'] = this.noticeUserUnReadNum;
    data['hasTeacherAll'] = this.hasTeacherAll;
    data['hasStudentAll'] = this.hasStudentAll;
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }
    data['noticeUserReadNum'] = this.noticeUserReadNum;
    data['readRecent'] = this.readRecent;
    return data;
  }
}
