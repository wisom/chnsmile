import 'package:chnsmile_flutter/model/upload_attach.dart';

class SuperFileDetailModel {
  String id;
  String formId;
  String title;
  String content;
  String remark;
  int process;//批阅要求（1仅阅读、2需回复）
  int status;//状态（0：未发送、1：已发送、2:已撤销、3：已删除）
  int grade;//重要程度（1普通、2重要、3紧急）
  String createUser;
  String createName;
  String createTime;
  List<UploadAttach> papersDowmAccessoryList;
  List<InfoDownNotice> infoDownNoticeList;

  SuperFileDetailModel({
    this.id,
    this.formId,
    this.title,
    this.content,
    this.remark,
    this.process,
    this.status,
    this.grade,
    this.createUser,
    this.createName,
    this.createTime,
    this.papersDowmAccessoryList,
    this.infoDownNoticeList
  });

  SuperFileDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    remark = json['remark'];
    process = json['process'];
    status = json['status'];
    grade = json['grade'];
    createUser = json['createUser'];
    createName = json['createName'];
    createTime = json['createTime'];
    if (json['papersDowmAccessoryList'] != null) {
      papersDowmAccessoryList = new List<UploadAttach>();
      json['papersDowmAccessoryList'].forEach((v) {
        papersDowmAccessoryList.add(new UploadAttach.fromJson(v));
      });
    }
    if (json['infoDownNoticeList'] != null) {
      infoDownNoticeList = new List<InfoDownNotice>();
      json['infoDownNoticeList'].forEach((v) {
        infoDownNoticeList.add(new InfoDownNotice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['remark'] = this.remark;
    data['process'] = this.process;
    data['status'] = this.status;
    data['grade'] = this.grade;
    data['createUser'] = this.createUser;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    if (this.papersDowmAccessoryList != null) {
      data['papersDowmAccessoryList'] =
          this.papersDowmAccessoryList.map((v) => v.toJson()).toList();
    }
    if (this.infoDownNoticeList != null) {
      data['infoDownNoticeList'] =
          this.infoDownNoticeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuperFileDetail {
  String id;
  String formId;
  String title;
  String content;
  String remark;
  int status; // status状态（0未发送、1批阅中、2已备案、3已拒绝）
  int process; // status状态（0未发送、1批阅中、2已备案、3已拒绝）
  int grade; // status状态（0未发送、1批阅中、2已备案、3已拒绝）
  String createUser;
  String createName;
  String createTime;

  SuperFileDetail({
    this.id,
    this.formId,
    this.title,
    this.content,
    this.remark,
    this.process,
    this.status,
    this.grade,
    this.createUser,
    this.createName,
    this.createTime,
  });

  SuperFileDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    remark = json['remark'];
    process = json['process'];
    status = json['status'];
    grade = json['grade'];
    createUser = json['createUser'];
    createName = json['createName'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['remark'] = this.remark;
    data['process'] = this.process;
    data['status'] = this.status;
    data['grade'] = this.grade;
    data['createUser'] = this.createUser;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    return data;
  }
}


class InfoDownNotice {
  String id;
  String schoolId;
  String schoolName;
  String orgId;
  String orgName;
  String noticeUserId;
  String noticeUserName;
  String replyRemark;
  int sort;
  int status;
  List<UploadAttach> dowmNoticeAccessoryList;

  InfoDownNotice({
    this.id,
    this.schoolId,
    this.schoolName,
    this.orgId,
    this.orgName,
    this.noticeUserId,
    this.noticeUserName,
    this.replyRemark,
    this.sort,
    this.status
  });

  InfoDownNotice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    noticeUserId = json['noticeUserId'];
    noticeUserName = json['noticeUserName'];
    replyRemark = json['replyRemark'];
    sort = json['sort'];
    status = json['status'];
    if (json['dowmNoticeAccessoryList'] != null) {
      dowmNoticeAccessoryList = new List<UploadAttach>();
      json['dowmNoticeAccessoryList'].forEach((v) {
        dowmNoticeAccessoryList.add(new UploadAttach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schoolId'] = this.schoolId;
    data['schoolName'] = this.schoolName;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['noticeUserId'] = this.noticeUserId;
    data['noticeUserName'] = this.noticeUserName;
    data['replyRemark'] = this.replyRemark;
    data['sort'] = this.sort;
    data['status'] = this.status;
    if (this.dowmNoticeAccessoryList != null) {
      data['dowmNoticeAccessoryList'] =
          this.dowmNoticeAccessoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
