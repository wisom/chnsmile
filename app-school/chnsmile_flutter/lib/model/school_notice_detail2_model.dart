import 'attach.dart';

class SchoolNoticeDetail2Model {
  String id;
  String formId;
  String title;
  String content;
  String remark;
  int status;
  int grade;
  String deptName;
  String releaseDate;
  int process;
  String approveRemark;
  int approveStatus;
  InfoApproveParam infoApproveParam;
  String cname;
  List<Attach> infoEnclosureList;

  SchoolNoticeDetail2Model(
      {this.id,
        this.formId,
        this.title,
        this.content,
        this.remark,
        this.status,
        this.grade,
        this.deptName,
        this.releaseDate,
        this.process,
        this.approveRemark,
        this.approveStatus,
        this.infoEnclosureList,
        this.infoApproveParam,
        this.cname});

  SchoolNoticeDetail2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    remark = json['remark'];
    status = json['status'];
    grade = json['grade'];
    deptName = json['deptName'];
    releaseDate = json['releaseDate'];
    process = json['process'];
    approveRemark = json['approveRemark'];
    approveStatus = json['approveStatus'];
    if (json['infoEnclosureList'] != null) {
      infoEnclosureList = new List<Attach>();
      json['infoEnclosureList'].forEach((v) {
        infoEnclosureList.add(new Attach.fromJson(v));
      });
    }
    infoApproveParam = json['infoApproveParam'] != null
        ? new InfoApproveParam.fromJson(json['infoApproveParam'])
        : null;
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
    data['grade'] = this.grade;
    data['deptName'] = this.deptName;
    data['releaseDate'] = this.releaseDate;
    data['process'] = this.process;
    data['approveRemark'] = this.approveRemark;
    data['approveStatus'] = this.approveStatus;
    if (this.infoEnclosureList != null) {
      data['infoEnclosureList'] =
          this.infoEnclosureList.map((v) => v.toJson()).toList();
    }
    if (this.infoApproveParam != null) {
      data['infoApproveParam'] = this.infoApproveParam.toJson();
    }
    data['cname'] = this.cname;
    return data;
  }
}

class InfoApproveParam {
  String formId;
  String orgId;
  String deptId;
  String deptName;
  String approveId;
  String jobNum;
  String approveName;
  int sort;
  int status;
  String approveRemark;
  String approveDate;

  InfoApproveParam(
      {this.formId,
        this.orgId,
        this.deptId,
        this.deptName,
        this.approveId,
        this.jobNum,
        this.approveName,
        this.sort,
        this.status,
        this.approveRemark,
        this.approveDate});

  InfoApproveParam.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    orgId = json['orgId'];
    deptId = json['deptId'];
    deptName = json['deptName'];
    approveId = json['approveId'];
    jobNum = json['jobNum'];
    approveName = json['approveName'];
    sort = json['sort'];
    status = json['status'];
    approveRemark = json['approveRemark'];
    approveDate = json['approveDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['orgId'] = this.orgId;
    data['deptId'] = this.deptId;
    data['deptName'] = this.deptName;
    data['approveId'] = this.approveId;
    data['jobNum'] = this.jobNum;
    data['approveName'] = this.approveName;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['approveRemark'] = this.approveRemark;
    data['approveDate'] = this.approveDate;
    return data;
  }
}
