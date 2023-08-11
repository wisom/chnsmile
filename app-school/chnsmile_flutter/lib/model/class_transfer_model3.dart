class ClassTransferModel3 {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<ClassTransfer3> rows;
  List<int> rainbow;

  ClassTransferModel3(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  ClassTransferModel3.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<ClassTransfer3>();
      json['rows'].forEach((v) {
        rows.add(new ClassTransfer3.fromJson(v));
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

class ClassTransfer3 {
  String id;
  String formId;
  String orgName;
  String dDate;
  String reason;
  int status;
  int reviewStatus;
  String cname;
  String ddate;

  ClassTransfer3(
      {this.id,
        this.formId,
        this.orgName,
        this.dDate,
        this.reason,
        this.status,
        this.reviewStatus,
        this.cname,
        this.ddate});

  ClassTransfer3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    orgName = json['orgName'];
    dDate = json['dDate'];
    reason = json['reason'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    cname = json['cname'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['orgName'] = this.orgName;
    data['dDate'] = this.dDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['cname'] = this.cname;
    data['ddate'] = this.ddate;
    return data;
  }
}
