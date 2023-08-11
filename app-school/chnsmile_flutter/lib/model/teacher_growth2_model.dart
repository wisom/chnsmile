
class TeacherGrowth2Model {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<TeacherGrowth2> rows;
  List<int> rainbow;

  TeacherGrowth2Model(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  TeacherGrowth2Model.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<TeacherGrowth2>();
      json['rows'].forEach((v) {
        rows.add(new TeacherGrowth2.fromJson(v));
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

class TeacherGrowth2 {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String formId;
  String studentId;
  String classId;
  String teacherId;
  String teacherName;
  String timeInfo;
  String archiveContent;
  int status;
  String schoolId;
  String publishTime;
  String studentScope;
  String studentName;

  TeacherGrowth2(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.formId,
        this.studentId,
        this.classId,
        this.teacherId,
        this.teacherName,
        this.timeInfo,
        this.archiveContent,
        this.status,
        this.schoolId,
        this.publishTime,
        this.studentScope,
        this.studentName});

  TeacherGrowth2.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    formId = json['formId'];
    studentId = json['studentId'];
    classId = json['classId'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    timeInfo = json['timeInfo'];
    archiveContent = json['archiveContent'];
    status = json['status'];
    schoolId = json['schoolId'];
    publishTime = json['publishTime'];
    studentScope = json['studentScope'];
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
    data['studentId'] = this.studentId;
    data['classId'] = this.classId;
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['timeInfo'] = this.timeInfo;
    data['archiveContent'] = this.archiveContent;
    data['status'] = this.status;
    data['schoolId'] = this.schoolId;
    data['publishTime'] = this.publishTime;
    data['studentScope'] = this.studentScope;
    data['studentName'] = this.studentName;
    return data;
  }
}
