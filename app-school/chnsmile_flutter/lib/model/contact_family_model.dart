class ContactFamilyModel {
  int selectedCount;
  bool allSelected;
  List<ClassInfo> classInfo;
  List<StudentParentInfo> studentParentInfo;

  ContactFamilyModel({this.classInfo, this.studentParentInfo, this.allSelected = false});

  ContactFamilyModel.fromJson(Map<String, dynamic> json) {
    if (json['classInfo'] != null) {
      classInfo = new List<ClassInfo>();
      json['classInfo'].forEach((v) {
        classInfo.add(new ClassInfo.fromJson(v));
      });
    }
    if (json['studentParentInfo'] != null) {
      studentParentInfo = new List<StudentParentInfo>();
      json['studentParentInfo'].forEach((v) {
        studentParentInfo.add(new StudentParentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classInfo != null) {
      data['classInfo'] = this.classInfo.map((v) => v.toJson()).toList();
    }
    if (this.studentParentInfo != null) {
      data['studentParentInfo'] =
          this.studentParentInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ContactFamilyModel{classInfo: $classInfo, studentParentInfo: $studentParentInfo}';
  }
}

class ClassInfo {
  String classId;
  String className;
  String classGradeName;
  String classYear;
  String schoolYear;
  bool selected;

  ClassInfo(
      {this.classId,
        this.className,
        this.classGradeName = "",
        this.classYear,
        this.selected = false,
        this.schoolYear});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    className = json['className'];
    classGradeName = json['classGradeName'];
    classYear = json['classYear'];
    selected = json['selected'];
    schoolYear = json['schoolYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classGradeName'] = this.classGradeName;
    data['classYear'] = this.classYear;
    data['selected'] = this.selected;
    data['schoolYear'] = this.schoolYear;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is ClassInfo) {
      return classId == other.classId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + classId.hashCode;
    return result;
  }

  @override
  String toString() {
    return 'ClassInfo{classId: $classId, className: $className, selected: $selected}';
  }
}

class StudentParentInfo {
  String classId;
  String className;
  String classGradeName;
  String classYear;
  String schoolYear;
  String studentName;
  String studentId;
  String parentName;
  String relations;
  String userId;
  String avatarImg;
  bool selected;

  StudentParentInfo(
      {this.classId,
        this.className,
        this.classGradeName = "",
        this.classYear,
        this.schoolYear,
        this.studentName,
        this.studentId,
        this.parentName,
        this.relations,
        this.userId,
        this.selected = false,
        this.avatarImg = ""});

  StudentParentInfo.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    className = json['className'];
    classGradeName = json['classGradeName'];
    classYear = json['classYear'];
    schoolYear = json['schoolYear'];
    studentName = json['studentName'];
    studentId = json['studentId'];
    parentName = json['parentName'];
    relations = json['relations'];
    selected = json['selected'];
    userId = json['userId'];
    avatarImg = json['avatarImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classGradeName'] = this.classGradeName;
    data['classYear'] = this.classYear;
    data['schoolYear'] = this.schoolYear;
    data['studentName'] = this.studentName;
    data['studentId'] = this.studentId;
    data['parentName'] = this.parentName;
    data['relations'] = this.relations;
    data['userId'] = this.userId;
    data['selected'] = this.selected;
    data['avatarImg'] = this.avatarImg;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is StudentParentInfo) {
      return studentId == other.studentId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + studentId.hashCode;
    return result;
  }

  @override
  String toString() {
    return 'StudentParentInfo{classId: $classId, className: $className, studentName: $studentName, studentId: $studentId, selected: $selected}';
  }
}
