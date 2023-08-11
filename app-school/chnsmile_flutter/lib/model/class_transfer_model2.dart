class ClassTransferModel2 {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<ClassTransfer2> rows;
  List<int> rainbow;

  ClassTransferModel2(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  ClassTransferModel2.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<ClassTransfer2>();
      json['rows'].forEach((v) {
        rows.add(new ClassTransfer2.fromJson(v));
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

class ClassTransfer2 {
  String id;
  String cid;
  String clazzName;
  String courseName;
  String formId;
  String dDate;
  String reason;
  int status;
  String ddate;

  ClassTransfer2(
      {this.id,
        this.cid,
        this.clazzName,
        this.courseName,
        this.formId,
        this.dDate,
        this.status,
        this.reason,
        this.ddate});

  ClassTransfer2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cid = json['cid'];
    clazzName = json['clazzName'];
    courseName = json['courseName'];
    formId = json['formId'];
    dDate = json['dDate'];
    reason = json['reason'];
    status = json['status'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cid'] = this.cid;
    data['clazzName'] = this.clazzName;
    data['courseName'] = this.courseName;
    data['reason'] = this.reason;
    data['formId'] = this.formId;
    data['dDate'] = this.dDate;
    data['status'] = this.status;
    data['ddate'] = this.ddate;
    return data;
  }
}
