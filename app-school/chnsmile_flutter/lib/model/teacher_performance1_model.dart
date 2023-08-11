class TeacherPerformance1Model {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<TeacherPerformance1> rows;

  TeacherPerformance1Model(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  TeacherPerformance1Model.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<TeacherPerformance1>();
      json['rows'].forEach((v) {
        rows.add(new TeacherPerformance1.fromJson(v));
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

class TeacherPerformance1 {
  String classId;
  String className;
  String classGrade;
  String classGradeName;
  String classYear;
  String schoolYear;
  String label;
  String operateDate;

  TeacherPerformance1(
      {this.classId,
        this.className,
        this.classGrade,
        this.classGradeName,
        this.classYear,
        this.schoolYear,
        this.label,
        this.operateDate});

  TeacherPerformance1.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    className = json['className'];
    classGrade = json['classGrade'];
    classGradeName = json['classGradeName'];
    classYear = json['classYear'];
    schoolYear = json['schoolYear'];
    label = json['label'];
    operateDate = json['operateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classGrade'] = this.classGrade;
    data['classGradeName'] = this.classGradeName;
    data['classYear'] = this.classYear;
    data['schoolYear'] = this.schoolYear;
    data['label'] = this.label;
    data['operateDate'] = this.operateDate;
    return data;
  }
}
