class ClassTransferDetailModel {
  String id;
  String formId;
  String dDate;
  String reason;
  int status;
  String remark;
  ChangeInfo approveInfo;
  List<ChangeInfo> detailChangeApproveInfoList;
  String ddate;

  ClassTransferDetailModel(
      {this.id,
        this.formId,
        this.dDate,
        this.reason,
        this.status,
        this.remark,
        this.approveInfo,
        this.detailChangeApproveInfoList,
        this.ddate});

  ClassTransferDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    dDate = json['dDate'];
    reason = json['reason'];
    status = json['status'];
    remark = json['remark'];
    approveInfo = json['approveInfo'] != null
        ? new ChangeInfo.fromJson(json['approveInfo'])
        : null;
    if (json['detailChangeApproveInfoList'] != null) {
      detailChangeApproveInfoList = new List<ChangeInfo>();
      json['detailChangeApproveInfoList'].forEach((v) {
        detailChangeApproveInfoList
            .add(new ChangeInfo.fromJson(v));
      });
    }
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['dDate'] = this.dDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['remark'] = this.remark;
    if (this.approveInfo != null) {
      data['approveInfo'] = this.approveInfo.toJson();
    }
    if (this.detailChangeApproveInfoList != null) {
      data['detailChangeApproveInfoList'] =
          this.detailChangeApproveInfoList.map((v) => v.toJson()).toList();
    }
    data['ddate'] = this.ddate;
    return data;
  }
}

class ChangeInfo {
  String tealId;
  String tealName;
  String clazz;
  String clazzName;
  String course;
  String courseName;
  String oldDate;
  String oldNo;
  String newDate;
  String newNo;
  String kinds;
  String deptId;
  String deptName;
  String approveId;
  String approveName;
  String approveDate;
  String approveRemark;
  int status;
  String avatarImg;

  ChangeInfo(
      {this.tealId,
        this.tealName,
        this.clazz,
        this.clazzName,
        this.course,
        this.courseName,
        this.oldDate,
        this.oldNo,
        this.newDate,
        this.newNo,
        this.kinds,
        this.deptId,
        this.deptName,
        this.approveId,
        this.approveName,
        this.approveDate,
        this.approveRemark,
        this.status,
        this.avatarImg});

  ChangeInfo.fromJson(Map<String, dynamic> json) {
    tealId = json['tealId'];
    tealName = json['tealName'];
    clazz = json['clazz'];
    clazzName = json['clazzName'];
    course = json['course'];
    courseName = json['courseName'];
    oldDate = json['oldDate'];
    oldNo = json['oldNo'];
    newDate = json['newDate'];
    newNo = json['newNo'];
    kinds = json['kinds'];
    deptId = json['deptId'];
    deptName = json['deptName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    approveDate = json['approveDate'];
    approveRemark = json['approveRemark'];
    status = json['status'];
    avatarImg = json['avatarImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tealId'] = this.tealId;
    data['tealName'] = this.tealName;
    data['clazz'] = this.clazz;
    data['clazzName'] = this.clazzName;
    data['course'] = this.course;
    data['courseName'] = this.courseName;
    data['oldDate'] = this.oldDate;
    data['oldNo'] = this.oldNo;
    data['newDate'] = this.newDate;
    data['newNo'] = this.newNo;
    data['kinds'] = this.kinds;
    data['deptId'] = this.deptId;
    data['deptName'] = this.deptName;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['approveDate'] = this.approveDate;
    data['approveRemark'] = this.approveRemark;
    data['status'] = this.status;
    data['avatarImg'] = this.avatarImg;
    return data;
  }
}
