import 'package:chnsmile_flutter/model/attach.dart';

class HomeWorkModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<HomeWork> rows;

  HomeWorkModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  HomeWorkModel.fromJson(Map<String, dynamic> json) {
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

class HomeWork {
  String id;
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
  int readStatus;
  String readTime;
  int userOperateType;
  int urgencyType;
  List<Attach> attachInfoList;

  HomeWork(
      {this.id,
        this.title,
        this.content,
        this.type,
        this.publicUserId,
        this.publicUserName,
        this.publicOrgId,
        this.publicOrgName,
        this.publicTime,
        this.cancelTime,
        this.status,
        this.readStatus,
        this.readTime,
        this.userOperateType,
        this.urgencyType,
        this.attachInfoList});

  HomeWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicOrgId = json['publicOrgId'];
    publicOrgName = json['publicOrgName'];
    publicTime = json['publicTime'];
    cancelTime = json['cancelTime'];
    status = json['status'];
    readStatus = json['readStatus'];
    readTime = json['readTime'];
    userOperateType = json['userOperateType'];
    urgencyType = json['urgencyType'];
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
    data['title'] = this.title;
    data['content'] = this.content;
    data['type'] = this.type;
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['publicOrgId'] = this.publicOrgId;
    data['publicOrgName'] = this.publicOrgName;
    data['publicTime'] = this.publicTime;
    data['cancelTime'] = this.cancelTime;
    data['status'] = this.status;
    data['readStatus'] = this.readStatus;
    data['readTime'] = this.readTime;
    data['userOperateType'] = this.userOperateType;
    data['urgencyType'] = this.urgencyType;
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
