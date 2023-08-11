class TeacherTranscript1Model {
  List<TeacherTranscript1> list;

  TeacherTranscript1Model.fromJson(List json) {
    if (json != null) {
      list = List<TeacherTranscript1>.empty(growable: true);
      json.forEach((v) {
        list.add(TeacherTranscript1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class TeacherTranscript1 {
  String classId;
  String className;
  String classGrade;
  String classGradeName;
  String classYear;
  String schoolYear;
  String label;
  String operateDate;

  TeacherTranscript1(
      {this.classId,
        this.className,
        this.classGrade,
        this.classGradeName,
        this.classYear,
        this.schoolYear,
        this.label,
        this.operateDate});

  TeacherTranscript1.fromJson(Map<String, dynamic> json) {
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

