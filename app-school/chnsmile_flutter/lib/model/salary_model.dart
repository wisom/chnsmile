class SalaryModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Salary> rows;

  SalaryModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  SalaryModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<Salary>();
      json['rows'].forEach((v) {
        rows.add(new Salary.fromJson(v));
      });
    }
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
    return data;
  }
}

class Salary {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String schoolId;
  String formId;
  String teacherId;
  String title;
  String memo;
  String author;
  String attachId;
  String importDate;
  int status;
  String publishTime;
  String headLine;
  String teacherName;
  List<TableHead> tableHead;

  Salary(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.schoolId,
        this.formId,
        this.teacherId,
        this.title,
        this.memo,
        this.author,
        this.attachId,
        this.importDate,
        this.status,
        this.publishTime,
        this.headLine,
        this.teacherName,
        this.tableHead});

  Salary.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    author = json['author'];
    schoolId = json['schoolId'];
    formId = json['formId'];
    teacherId = json['teacherId'];
    title = json['title'];
    memo = json['memo'];
    attachId = json['attachId'];
    importDate = json['importDate'];
    status = json['status'];
    publishTime = json['publishTime'];
    headLine = json['headLine'];
    teacherName = json['teacherName'];
    if (json['tableHead'] != null) {
      tableHead = new List<TableHead>();
      json['tableHead'].forEach((v) {
        tableHead.add(new TableHead.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['author'] = this.author;
    data['schoolId'] = this.schoolId;
    data['formId'] = this.formId;
    data['teacherId'] = this.teacherId;
    data['title'] = this.title;
    data['memo'] = this.memo;
    data['attachId'] = this.attachId;
    data['importDate'] = this.importDate;
    data['status'] = this.status;
    data['publishTime'] = this.publishTime;
    data['headLine'] = this.headLine;
    data['teacherName'] = this.teacherName;
    if (this.tableHead != null) {
      data['tableHead'] = this.tableHead.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableHead {
  String data;
  String dataIndex;
  String align;
  String title;

  TableHead({this.data, this.dataIndex, this.align, this.title});

  TableHead.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    dataIndex = json['dataIndex'];
    align = json['align'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['dataIndex'] = this.dataIndex;
    data['align'] = this.align;
    data['title'] = this.title;
    return data;
  }
}
