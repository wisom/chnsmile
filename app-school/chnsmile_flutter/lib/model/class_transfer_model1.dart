class ClassTransferModel1 {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<ClassTransfer> rows;
  List<int> rainbow;

  ClassTransferModel1(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  ClassTransferModel1.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<ClassTransfer>();
      json['rows'].forEach((v) {
        rows.add(new ClassTransfer.fromJson(v));
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

class ClassTransfer {
  String id;
  String formId;
  String orgName;
  String createTime;
  String reason;
  int status;
  String remark;
  String cname;

  ClassTransfer(
      {this.id,
        this.formId,
        this.orgName,
        this.createTime,
        this.reason,
        this.status,
        this.remark,
        this.cname});

  ClassTransfer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    orgName = json['orgName'];
    createTime = json['createTime'];
    reason = json['reason'];
    status = json['status'];
    remark = json['remark'];
    cname = json['cname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['orgName'] = this.orgName;
    data['createTime'] = this.createTime;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['cname'] = this.cname;
    return data;
  }
}
