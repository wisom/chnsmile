class ClassPlanModel {
  List<ClassPlan> list;

  ClassPlanModel.fromJson(List json) {
    if (json != null) {
      list = List<ClassPlan>.empty(growable: true);
      json.forEach((v) {
        list.add(ClassPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ClassPlan {
  String classDate;
  int classSubNode;
  String tealId;
  String tealName;
  String courseId;
  String course;

  ClassPlan(
      {this.classDate,
        this.classSubNode,
        this.tealId,
        this.tealName,
        this.courseId,
        this.course});

  ClassPlan.fromJson(Map<String, dynamic> json) {
    classDate = json['classDate'];
    classSubNode = json['classSubNode'];
    tealId = json['tealId'];
    tealName = json['tealName'];
    courseId = json['courseId'];
    course = json['course'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classDate'] = this.classDate;
    data['classSubNode'] = this.classSubNode;
    data['tealId'] = this.tealId;
    data['tealName'] = this.tealName;
    data['courseId'] = this.courseId;
    data['course'] = this.course;
    return data;
  }
}
