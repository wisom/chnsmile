class VoteSchoolClassModel {
  List<ClassInfo> classInfo;

  VoteSchoolClassModel({this.classInfo});

  VoteSchoolClassModel.fromJson(Map<String, dynamic> json) {
    if (json['classInfo'] != null) {
      classInfo = new List<ClassInfo>();
      json['classInfo'].forEach((v) {
        classInfo.add(new ClassInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classInfo != null) {
      data['classInfo'] = this.classInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassInfo {
  String classId;
  String className;
  String classGradeName;
  String classYear;
  String schoolYear;

  ClassInfo(
      {this.classId,
        this.className,
        this.classGradeName,
        this.classYear,
        this.schoolYear});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    className = json['className'];
    classGradeName = json['classGradeName'];
    classYear = json['classYear'];
    schoolYear = json['schoolYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classGradeName'] = this.classGradeName;
    data['classYear'] = this.classYear;
    data['schoolYear'] = this.schoolYear;
    return data;
  }
}

