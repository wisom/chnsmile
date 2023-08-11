import 'package:chnsmile_flutter/model/attach.dart';

class HomeWorkDetailModel {
  String id;
  String formId;
  String title;
  String content;
  int type;
  String publicUserId;
  String publicUserName;
  String publicOrgId;
  String publicOrgName;
  String publicTime;
  String cancelTime;
  int status;
  int userOperateType;
  int urgencyType;
  int readStatus;
  String noticeUserIdList;
  NoticeUserReadInfo noticeUserReadInfo;
  String attachIds;
  String noticeUserSum;
  String noticeUserUnReadNum;
  List<Attach> attachInfoList;

  HomeWorkDetailModel(
      {this.id,
        this.formId,
        this.title,
        this.content,
        this.type,
        this.publicUserId,
        this.publicUserName,
        this.publicOrgId,
        this.publicOrgName,
        this.publicTime,
        this.readStatus,
        this.cancelTime,
        this.status,
        this.userOperateType,
        this.urgencyType,
        this.noticeUserIdList,
        this.noticeUserReadInfo,
        this.attachIds,
        this.noticeUserSum,
        this.noticeUserUnReadNum,
        this.attachInfoList});

  HomeWorkDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicOrgId = json['publicOrgId'];
    publicOrgName = json['publicOrgName'];
    publicTime = json['publicTime'];
    readStatus = json['readStatus'];
    cancelTime = json['cancelTime'];
    status = json['status'];
    userOperateType = json['userOperateType'];
    urgencyType = json['urgencyType'];
    noticeUserIdList = json['noticeUserIdList'];
    noticeUserReadInfo = json['noticeUserReadInfo'] != null
        ? new NoticeUserReadInfo.fromJson(json['noticeUserReadInfo'])
        : null;
    attachIds = json['attachIds'];
    noticeUserSum = json['noticeUserSum'];
    noticeUserUnReadNum = json['noticeUserUnReadNum'];
    if (json['attachInfoList'] != null) {
      attachInfoList = new List<Attach>();
      json['attachInfoList'].forEach((v) {
        attachInfoList.add(new Attach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['type'] = this.type;
    data['publicUserId'] = this.publicUserId;
    data['readStatus'] = this.readStatus;
    data['publicUserName'] = this.publicUserName;
    data['publicOrgId'] = this.publicOrgId;
    data['publicOrgName'] = this.publicOrgName;
    data['publicTime'] = this.publicTime;
    data['cancelTime'] = this.cancelTime;
    data['status'] = this.status;
    data['userOperateType'] = this.userOperateType;
    data['urgencyType'] = this.urgencyType;
    data['noticeUserIdList'] = this.noticeUserIdList;
    if (this.noticeUserReadInfo != null) {
      data['noticeUserReadInfo'] = this.noticeUserReadInfo.toJson();
    }
    data['attachIds'] = this.attachIds;
    data['noticeUserSum'] = this.noticeUserSum;
    data['noticeUserUnReadNum'] = this.noticeUserUnReadNum;
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoticeUserReadInfo {
  String userId;
  String userName;
  int readStatus;
  String readTime;

  NoticeUserReadInfo(
      {this.userId, this.userName, this.readStatus, this.readTime});

  NoticeUserReadInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    readStatus = json['readStatus'];
    readTime = json['readTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['readStatus'] = this.readStatus;
    data['readTime'] = this.readTime;
    return data;
  }
}

