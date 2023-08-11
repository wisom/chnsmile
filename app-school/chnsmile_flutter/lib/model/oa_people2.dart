class OAPeople2 {
  String kinds; // 1 审批， 2 通知
  String approveId;
  String floor;
  String approveName;
  String orgName;
  String orgId;
  String schoolId;
  String schoolName;

  OAPeople2({
    this.kinds,
    this.approveId,
    this.floor = "0",
    this.approveName,
    this.orgName,
    this.orgId,
    this.schoolId,
    this.schoolName,
  });

  OAPeople2.fromJson(Map<String, dynamic> json) {
    kinds = json['kinds'];
    approveId = json['approveId'];
    floor = json['floor'];
    approveName = json['approveName'];
    orgName = json['orgName'];
    orgId = json['orgId'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['kinds'] = kinds;
    data['approveId'] = approveId;
    data['floor'] = floor;
    data['approveName'] = approveName;
    data['orgName'] = orgName;
    data['orgId'] = orgId;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    return data;
  }

  Map<String, dynamic> toJson2() {
    Map<String, dynamic> data = Map();
    data['kinds'] = kinds;
    data['approveId'] = approveId;
    data['sort'] = floor;
    data['approveName'] = approveName;
    data['orgName'] = orgName;
    data['orgId'] = orgId;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    return data;
  }
}