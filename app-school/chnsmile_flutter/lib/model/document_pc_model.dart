class DocumentPcModel {
  int permission;
  List<SchoolOaDocumentApproveList> approves;

  DocumentPcModel({this.permission, this.approves});

  DocumentPcModel.fromJson(Map<String, dynamic> json) {
    permission = json['permission'];
    if (json['schoolOaDocumentApproveList'] != null) {
      approves = new List<SchoolOaDocumentApproveList>();
      json['schoolOaDocumentApproveList'].forEach((v) {
        approves
            .add(new SchoolOaDocumentApproveList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permission'] = this.permission;
    if (this.approves != null) {
      data['schoolOaDocumentApproveList'] =
          this.approves.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchoolOaDocumentApproveList {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String schoolId;
  String formId;
  String process;
  String kinds;
  String orgId;
  String orgName;
  String approveId;
  String approveName;
  String agentId;
  String approveDate;
  String approveRemark;
  int floor;
  int sort;
  int status;

  SchoolOaDocumentApproveList(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.schoolId,
        this.formId,
        this.process,
        this.kinds,
        this.orgId,
        this.orgName,
        this.approveId,
        this.approveName,
        this.agentId,
        this.approveDate,
        this.approveRemark,
        this.floor,
        this.sort,
        this.status});

  SchoolOaDocumentApproveList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    schoolId = json['schoolId'];
    formId = json['formId'];
    process = json['process'];
    kinds = json['kinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    agentId = json['agentId'];
    approveDate = json['approveDate'];
    approveRemark = json['approveRemark'];
    floor = json['floor'];
    sort = json['sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['schoolId'] = this.schoolId;
    data['formId'] = this.formId;
    data['process'] = this.process;
    data['kinds'] = this.kinds;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['agentId'] = this.agentId;
    data['approveDate'] = this.approveDate;
    data['approveRemark'] = this.approveRemark;
    data['floor'] = this.floor;
    data['sort'] = this.sort;
    data['status'] = this.status;
    return data;
  }
}
