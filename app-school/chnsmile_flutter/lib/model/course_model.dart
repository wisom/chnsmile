class CourseModel {
  List<Course> list;

  CourseModel.fromJson(List json) {
    if (json != null) {
      list = List<Course>.empty(growable: true);
      json.forEach((v) {
        list.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class Course {
  String weekName;
  String weekDate;
  List<SubNodeCourses> subNodeCourses;

  Course({this.weekName, this.weekDate, this.subNodeCourses});

  Course.fromJson(Map<String, dynamic> json) {
    weekName = json['weekName'];
    weekDate = json['weekDate'];
    if (json['subNodeCourses'] != null) {
      subNodeCourses = new List<SubNodeCourses>();
      json['subNodeCourses'].forEach((v) {
        subNodeCourses.add(new SubNodeCourses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weekName'] = this.weekName;
    data['weekDate'] = this.weekDate;
    if (this.subNodeCourses != null) {
      data['subNodeCourses'] =
          this.subNodeCourses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubNodeCourses {
  String classPlanId;
  int classSubNode;
  String courseName;
  String className;
  String teacherName;

  SubNodeCourses({this.classPlanId, this.classSubNode, this.courseName, this.className, this.teacherName});

  SubNodeCourses.fromJson(Map<String, dynamic> json) {
    classPlanId = json['classPlanId'];
    classSubNode = json['classSubNode'];
    courseName = json['courseName'];
    className = json['className'];
    teacherName = json['teacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classPlanId'] = this.classPlanId;
    data['classSubNode'] = this.classSubNode;
    data['courseName'] = this.courseName;
    data['className'] = this.className;
    data['teacherName'] = this.teacherName;
    return data;
  }
}
