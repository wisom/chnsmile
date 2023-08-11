import 'package:chnsmile_flutter/model/attach.dart';

class TeacherNoticeModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<TeacherNotice> list;

  TeacherNoticeModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.list});

  TeacherNoticeModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      list = new List<TeacherNotice>();
      json['rows'].forEach((v) {
        list.add(new TeacherNotice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.list != null) {
      data['rows'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherNotice {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String formId;
  String title;
  String content;
  int type;
  String publicUserId;
  String publicUserName;
  String publicTime;
  int status;
  String schoolId;
  int userOperateType;
  int urgencyType;
  String attachIds;
  String noticeUserSum;
  String noticeUserUnReadNum;
  String noticeUserReadNum;
  String readRecent;
  List<Attach> attachInfoList;

  TeacherNotice(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.formId,
        this.title,
        this.content,
        this.type,
        this.publicUserId,
        this.publicUserName,
        this.publicTime,
        this.status,
        this.schoolId,
        this.attachInfoList,
        this.userOperateType,
        this.noticeUserUnReadNum,
        this.noticeUserReadNum,
        this.readRecent,
        this.urgencyType,
        this.attachIds,
        this.noticeUserSum});

  TeacherNotice.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    noticeUserUnReadNum = json['noticeUserUnReadNum'];
    noticeUserReadNum = json['noticeUserReadNum'];
    readRecent = json['readRecent'];
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicTime = json['publicTime'];
    status = json['status'];
    schoolId = json['schoolId'];
    userOperateType = json['userOperateType'];
    urgencyType = json['urgencyType'];
    attachIds = json['attachIds'];
    if (json['attachInfoList'] != null) {
      attachInfoList = new List<Attach>();
      json['attachInfoList'].forEach((v) {
        attachInfoList.add(new Attach.fromJson(v));
      });
    }
    noticeUserSum = json['noticeUserSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['noticeUserUnReadNum'] = this.noticeUserUnReadNum;
    data['noticeUserReadNum'] = this.noticeUserReadNum;
    data['readRecent'] = this.readRecent;
    data['content'] = this.content;
    data['type'] = this.type;
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['publicTime'] = this.publicTime;
    data['status'] = this.status;
    data['schoolId'] = this.schoolId;
    data['userOperateType'] = this.userOperateType;
    data['urgencyType'] = this.urgencyType;
    data['attachIds'] = this.attachIds;
    data['noticeUserSum'] = this.noticeUserSum;
    return data;
  }
}

