class VacationDetailModel {
  String id;
  String formId;
  String dDate;
  String applyKinds;
  String orgId;
  String orgName;
  String applyId;
  String applyName;
  String leaveId;
  String leaveName;
  String kinds;
  String dateStart;
  String dateEnd;
  double hours;
  String reason;
  String remark;
  int status;
  List<ApproveInfoList> approveInfoList;
  String ddate;

  VacationDetailModel(
      {this.id,
        this.formId,
        this.dDate,
        this.applyKinds,
        this.orgId = "",
        this.orgName = "",
        this.applyId,
        this.applyName,
        this.leaveId,
        this.leaveName,
        this.kinds,
        this.dateStart,
        this.dateEnd,
        this.hours,
        this.reason,
        this.remark,
        this.status,
        this.approveInfoList,
        this.ddate});

  VacationDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    dDate = json['dDate'];
    applyKinds = json['applyKinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    applyId = json['applyId'];
    applyName = json['applyName'];
    leaveId = json['leaveId'];
    leaveName = json['leaveName'];
    kinds = json['kinds'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
    reason = json['reason'];
    remark = json['remark'];
    status = json['status'];
    if (json['approveInfoList'] != null) {
      approveInfoList = new List<ApproveInfoList>();
      json['approveInfoList'].forEach((v) {
        approveInfoList.add(new ApproveInfoList.fromJson(v));
      });
    }
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['dDate'] = this.dDate;
    data['applyKinds'] = this.applyKinds;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['applyId'] = this.applyId;
    data['applyName'] = this.applyName;
    data['leaveId'] = this.leaveId;
    data['leaveName'] = this.leaveName;
    data['kinds'] = this.kinds;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['hours'] = this.hours;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
    data['status'] = this.status;
    if (this.approveInfoList != null) {
      data['approveInfoList'] =
          this.approveInfoList.map((v) => v.toJson()).toList();
    }
    data['ddate'] = this.ddate;
    return data;
  }
}

class ApproveInfoList {
  String id;
  String formId;
  String process;
  String kinds;
  String orgId;
  String orgName;
  String approveId;
  String approveName;
  String avatarImg;
  String approveDate;
  String approveRemark;
  int sort;
  int status;

  ApproveInfoList(
      {this.id,
        this.formId,
        this.process,
        this.kinds,
        this.orgId = "",
        this.orgName = "",
        this.approveId = "",
        this.approveName = "",
        this.avatarImg = "",
        this.approveDate = "",
        this.approveRemark = "",
        this.sort,
        this.status});

  ApproveInfoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    process = json['process'];
    kinds = json['kinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    avatarImg = json['avatarImg'];
    approveDate = json['approveDate'];
    approveRemark = json['approveRemark'];
    sort = json['sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['process'] = this.process;
    data['kinds'] = this.kinds;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['avatarImg'] = this.avatarImg;
    data['approveDate'] = this.approveDate;
    data['approveRemark'] = this.approveRemark;
    data['sort'] = this.sort;
    data['status'] = this.status;
    return data;
  }
}
