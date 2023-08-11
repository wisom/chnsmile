class TeacherPerformance2Model {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<TeacherPerformance2> rows;

  TeacherPerformance2Model(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  TeacherPerformance2Model.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<TeacherPerformance2>();
      json['rows'].forEach((v) {
        rows.add(new TeacherPerformance2.fromJson(v));
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

class TeacherPerformance2 {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String formId;
  String title;
  String schoolId;
  String studentId;
  String teacherId;
  String teacherName;
  String classId;
  int status;
  String operateDate;
  String studentScope;
  String comments;
  String attend;
  String publishTime;
  String studentName;

  TeacherPerformance2(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.formId,
        this.title,
        this.schoolId,
        this.studentId,
        this.teacherId,
        this.teacherName,
        this.classId,
        this.status,
        this.operateDate,
        this.studentScope,
        this.comments,
        this.attend,
        this.publishTime,
        this.studentName});

  TeacherPerformance2.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    schoolId = json['schoolId'];
    studentId = json['studentId'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    classId = json['classId'];
    status = json['status'];
    operateDate = json['operateDate'];
    studentScope = json['studentScope'];
    comments = json['comments'];
    attend = json['attend'];
    publishTime = json['publishTime'];
    studentName = json['studentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['schoolId'] = this.schoolId;
    data['studentId'] = this.studentId;
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['classId'] = this.classId;
    data['status'] = this.status;
    data['operateDate'] = this.operateDate;
    data['studentScope'] = this.studentScope;
    data['comments'] = this.comments;
    data['attend'] = this.attend;
    data['publishTime'] = this.publishTime;
    data['studentName'] = this.studentName;
    return data;
  }
}

