class ClassTransferModel5 {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<ClassTransfer5> rows;
  List<int> rainbow;

  ClassTransferModel5(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  ClassTransferModel5.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<ClassTransfer5>();
      json['rows'].forEach((v) {
        rows.add(new ClassTransfer5.fromJson(v));
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

class ClassTransfer5 {
  String formId;
  String dDate;
  String reason;
  String remark;
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
  String ddate;

  ClassTransfer5(
      {this.formId,
        this.dDate,
        this.reason,
        this.remark,
        this.tealId,
        this.tealName,
        this.clazz,
        this.clazzName,
        this.course,
        this.courseName,
        this.oldDate,
        this.oldNo,
        this.newDate,
        this.newNo,
        this.ddate});

  ClassTransfer5.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    dDate = json['dDate'];
    reason = json['reason'];
    remark = json['remark'];
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
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['dDate'] = this.dDate;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
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
    data['ddate'] = this.ddate;
    return data;
  }
}