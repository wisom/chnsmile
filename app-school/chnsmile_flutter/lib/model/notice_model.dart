import 'package:chnsmile_flutter/model/attach.dart';

class NoticeModel {
    int total;
    List<Notice> list;

    NoticeModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<Notice>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(Notice.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['total'] = total;
      data['list'] = list.map((v) => v.toJson()).toList();
      return data;
    }
}

/**
 * 通知 字段类型描述
    type    类型（字典 1通知 2公告）
    status   状态（字典 0草稿 1发布 2撤回 3删除）
    userOperateType 用户阅读操作类型：0 无需操作 1 需确认阅读 2 需签字阅读
    urgencyType        紧急程度 0 普通 1 重要 2 紧急

    用户通知字段描述
    readStatus  状态（字典 0未读 1 已读 2 确认已读 3 签字已读）
 */

class Notice {
  String id;
  String title;
  String content;
  int type;
  String publicTime;
  String publicUserName;
  String publicOrgName;
  List<String> imageList;  // 逗号分割的
  List<Attach> attachList;
  int urgencyType; // 紧急程度 0 普通 1 重要 2 紧急
  int userOperateType; // 0 无需操作 1 需确认阅读 2 需签字阅读
  int readStatus; // 状态（字典 0未读 1 已读 2 确认已读 3 签字已读）
  List<Attach> attachInfoList;

  Notice(
      {this.id,
        this.title,
        this.content,
        this.type,
        this.publicTime,
        this.publicUserName,
        this.publicOrgName,
        this.imageList,
        this.attachList,
        this.urgencyType,
        this.readStatus,
        this.attachInfoList,
        this.userOperateType});

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    publicTime = json['publicTime'];
    imageList = json['imageList']?.cast<String>();
    publicUserName = json['publicUserName'];
    publicOrgName = json['publicOrgName'];
    urgencyType = json['urgencyType'];
    readStatus = json['readStatus'];
    userOperateType = json['userOperateType'];
    if (json['attachList'] != null) {
      attachList = [];
      json['attachList'].forEach((v) {
        attachList.add(Attach.fromJson(v));
      });
    }
    if (json['attachInfoList'] != null) {
      attachInfoList = new List<Attach>();
      json['attachInfoList'].forEach((v) {
        attachInfoList.add(new Attach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['type'] = type;
    data['publicTime'] = publicTime;
    data['imageList'] = this.imageList;
    data['publicUserName'] = publicUserName;
    data['publicOrgName'] = publicOrgName;
    data['urgencyType'] = urgencyType;
    data['readStatus'] = readStatus;
    data['userOperateType'] = userOperateType;
    if (attachList != null) {
      data['attachList'] = attachList.map((v) => v.toJson()).toList();
    }
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}