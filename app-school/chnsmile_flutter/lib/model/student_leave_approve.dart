class StudentLeaveApprove {
  String id;
  String kinds;
  String orgId;
  String orgName;
  String approveId;
  String approveName;
  int floor;
  int sort;
  String approveRemark;
  String approveDate;
  int status;


  StudentLeaveApprove({
      this.id,
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

  StudentLeaveApprove.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['id'] = id;
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
