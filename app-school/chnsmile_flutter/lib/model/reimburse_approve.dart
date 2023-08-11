class ReimburseApprove {
  String claimApproveId;//审批人、通知人主键
  String kinds;//批阅/通知（1：批阅，2：通知）
  String orgId;//部门id
  String orgName;//部门名称
  String approveId;//批阅人/通知人id
  String approveName;//批阅人/通知人姓名
  int floor;//批阅层级
  int sort;//顺序
  String approveRemark;//审批意见
  String approveDate;
  int status;//状态（0未发送、1批阅中、2已备案、3已拒绝）


  ReimburseApprove({
      this.claimApproveId,
      this.kinds,
      this.orgId,
      this.orgName,
      this.approveId,
      this.approveName,
      this.floor,
      this.sort,
      this.approveRemark,
      this.approveDate,
      this.status});

  ReimburseApprove.fromJson(Map<String, dynamic> json) {
    claimApproveId = json['claimApproveId'];
    kinds = json['kinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    floor = json['floor'];
    sort = json['sort'];
    approveDate = json['approveDate'];
    approveRemark = json['approveRemark'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claimApproveId'] = claimApproveId;
    data['kinds'] = kinds;
    data['orgId'] = orgId;
    data['orgName'] = orgName;
    data['approveId'] = approveId;
    data['approveName'] = approveName;
    data['floor'] = floor;
    data['sort'] = sort;
    data['approveDate'] = approveDate;
    data['approveRemark'] = approveRemark;
    data['status'] = status;
    return data;
  }
}
