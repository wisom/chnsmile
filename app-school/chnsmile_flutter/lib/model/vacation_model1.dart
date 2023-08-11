class VacationModel1 {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Vacation> rows;
  List<int> rainbow;

  VacationModel1(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  VacationModel1.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<Vacation>();
      json['rows'].forEach((v) {
        rows.add(new Vacation.fromJson(v));
      });
    }
    rainbow = json['rainbow'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['rainbow'] = this.rainbow;
    return data;
  }
}

class Vacation {
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
  String hours;
  String reason;
  String remark;
  int status;
  int reviewStatus; //（1待批/待读、2已批/已读、3拒批）
  String ddate;

  Vacation(
      {this.id,
        this.formId,
        this.dDate,
        this.applyKinds,
        this.orgId,
        this.orgName,
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
        this.reviewStatus,
        this.ddate});

  Vacation.fromJson(Map<String, dynamic> json) {
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
    reviewStatus = json['reviewStatus'];
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
    data['reviewStatus'] = this.reviewStatus;
    data['ddate'] = this.ddate;
    return data;
  }
}
