import 'package:chnsmile_flutter/model/attach.dart';

class SchoolNoticeModel {
    int total;
    List<SchoolNotice> list;

    SchoolNoticeModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<SchoolNotice>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(SchoolNotice.fromJson(v));
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

class SchoolNotice {
  String id;
  String formId;
  String title;
  String content;
  String remark;
  int status; // 收到通知的状态下 1 未 2 读   发出通知下 ：status 0未发出 1已发出
  int approveStatus; // （0等待、1待读、2已读）
  int grade;
  String deptName;
  int process; // 1 只阅读  2 需老师回复
  String releaseDate;
  List<InfoApproveList> infoApproveList;
  List<Attach> infoEnclosureList;
  String cname;
  int notReplyCount;

  SchoolNotice(
      {this.formId,
        this.id,
        this.title,
        this.content,
        this.remark,
        this.status,
        this.approveStatus,
        this.grade,
        this.deptName,
        this.process = 1,
        this.releaseDate,
        this.infoApproveList,
        this.infoEnclosureList,
        this.notReplyCount = 0,
        this.cname});

  SchoolNotice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    remark = json['remark'];
    status = json['status'];
    approveStatus = json['approveStatus'];
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
    cname = json['cname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['approveStatus'] = this.approveStatus;
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
    data['cname'] = this.cname;
    return data;
  }
}

class InfoApproveList {
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
      {this.formId,
        this.deptId,
        this.deptName,
        this.approveId,
        this.approveName,
        this.sort,
        this.status,
        this.approveRemark,
        this.approveDate});

  InfoApproveList.fromJson(Map<String, dynamic> json) {
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
