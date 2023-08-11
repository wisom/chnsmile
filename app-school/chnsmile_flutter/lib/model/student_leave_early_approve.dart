class StudentLeaveEarlyApprove {
  String id;
  String kinds;
  String orgId;
  String orgName;
  String approveId;
  String approveName;
  String approveDate;
  int floor;
  int sort;
  String approveRemark;
  int status;


  StudentLeaveEarlyApprove({
      this.id,
      this.kinds,
      this.orgId,
      this.orgName,
      this.approveId,
      this.approveName,
      this.approveDate,
      this.floor,
      this.sort,
      this.approveRemark,
      this.status});

  StudentLeaveEarlyApprove.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kinds = json['kinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    approveDate = json['approveDate'];
    floor = json['floor'];
    sort = json['sort'];
    approveRemark = json['approveRemark'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kinds'] = kinds;
    data['orgId'] = orgId;
    data['orgName'] = orgName;
    data['approveId'] = approveId;
    data['approveName'] = approveName;
    data['approveDate'] = approveDate;
    data['floor'] = floor;
    data['sort'] = sort;
    data['approveRemark'] = approveRemark;
    data['status'] = status;
    return data;
  }
}
