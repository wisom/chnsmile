import 'package:chnsmile_flutter/model/attach.dart';

class SchoolNoticeDetailModel {
  String formId;
  String title;
  String content;
  String remark;
  int status; // 收到通知的状态下 1 未 2 读   发出通知下 ：status 0未发出 1已发出
  int grade;
  String deptName;
  int total;
  int process;
  int notReplyCount;
  String releaseDate;
  List<InfoApproveList> infoApproveList;
  List<Attach> infoEnclosureList;
  List<InfoApproveList> notReplyList;
  String cname;

  SchoolNoticeDetailModel(
      {this.formId,
        this.title,
        this.content,
        this.remark,
        this.status,
        this.total,
        this.grade,
        this.deptName = "",
        this.process,
        this.notReplyCount,
        this.releaseDate = "",
        this.infoApproveList,
        this.notReplyList,
        this.infoEnclosureList,
        this.cname});

  SchoolNoticeDetailModel.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    remark = json['remark'];
    status = json['status'];
    total = json['total'];
    grade = json['grade'];
    deptName = json['deptName'];
    process = json['process'];
    notReplyCount = json['notReplyCount'];
    releaseDate = json['releaseDate'];
    if (json['infoApproveList'] != null) {
      infoApproveList = new List<InfoApproveList>();
      json['infoApproveList'].forEach((v) {
        infoApproveList.add(new InfoApproveList.fromJson(v));
      });
    }
    if (json['infoEnclosureList'] != null) {
      infoEnclosureList = new List<Attach>();
      json['infoEnclosureList'].forEach((v) {
        infoEnclosureList.add(new Attach.fromJson(v));
      });
    }
    if (json['notReplyList'] != null) {
      notReplyList = new List<InfoApproveList>();
      json['notReplyList'].forEach((v) {
        notReplyList.add(new InfoApproveList.fromJson(v));
      });
    }
    cname = json['cname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['total'] = this.total;
    data['grade'] = this.grade;
    data['deptName'] = this.deptName;
    data['process'] = this.process;
    data['notReplyCount'] = this.notReplyCount;
    data['releaseDate'] = this.releaseDate;
    if (this.infoApproveList != null) {
      data['infoApproveList'] =
          this.infoApproveList.map((v) => v.toJson()).toList();
    }
    if (this.infoEnclosureList != null) {
      data['infoEnclosureList'] =
          this.infoEnclosureList.map((v) => v.toJson()).toList();
    }
    if (this.notReplyList != null) {
      data['notReplyList'] = this.notReplyList.map((v) => v.toJson()).toList();
    }
    data['cname'] = this.cname;
    return data;
  }
}

class InfoApproveList {
  String id;
  String formId;
  String deptId;
  String deptName;
  String approveId;
  String approveName;
  int sort;
  int status;
  String approveRemark;
  String approveDate;

  InfoApproveList(
      {this.id,
        this.formId,
        this.deptId,
        this.deptName = "",
        this.approveId = "",
        this.approveName,
        this.sort,
        this.status,
        this.approveRemark,
        this.approveDate = ""});

  InfoApproveList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    deptId = json['deptId'];
    deptName = json['deptName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    sort = json['sort'];
    status = json['status'];
    approveRemark = json['approveRemark'];
    approveDate = json['approveDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['deptId'] = this.deptId;
    data['deptName'] = this.deptName;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['approveRemark'] = this.approveRemark;
    data['approveDate'] = this.approveDate;
    return data;
  }
}