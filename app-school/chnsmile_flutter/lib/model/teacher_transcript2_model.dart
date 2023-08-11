class TeacherTranscript2Model {
  List<TeacherTranscript2> list;

  TeacherTranscript2Model.fromJson(List json) {
    if (json != null) {
      list = List<TeacherTranscript2>.empty(growable: true);
      json.forEach((v) {
        list.add(TeacherTranscript2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class TeacherTranscript2 {
  String id;
  String parentId;
  String orderNum;
  String name;
  int type;
  String label;
  ScopedSlots scopedSlots;
  List<Student> children;

  TeacherTranscript2(
      {this.id,
        this.parentId,
        this.orderNum,
        this.name,
        this.type,
        this.label,
        this.scopedSlots,
        this.children});

  TeacherTranscript2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    orderNum = json['orderNum'].toString();
    name = json['name'];
    type = json['type'];
    label = json['label'];
    scopedSlots = json['scopedSlots'] != null
        ? new ScopedSlots.fromJson(json['scopedSlots'])
        : null;
    if (json['children'] != null) {
      children = new List<Student>();
      json['children'].forEach((v) {
        children.add(new Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['orderNum'] = this.orderNum;
    data['name'] = this.name;
    data['type'] = this.type;
    data['label'] = this.label;
    if (this.scopedSlots != null) {
      data['scopedSlots'] = this.scopedSlots.toJson();
    }
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScopedSlots {
  String title;

  ScopedSlots({this.title});

  ScopedSlots.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}

class Student {
  String id;
  String parentId;
  String orderNum;
  String name;
  int type;
  String label;
  ScopedSlots scopedSlots;

  Student(
      {this.id,
        this.parentId,
        this.orderNum,
        this.name,
        this.type,
        this.label,
        this.scopedSlots});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    orderNum = json['orderNum'].toString();
    name = json['name'];
    type = json['type'];
    label = json['label'];
    scopedSlots = json['scopedSlots'] != null
        ? new ScopedSlots.fromJson(json['scopedSlots'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['orderNum'] = this.orderNum;
    data['name'] = this.name;
    data['type'] = this.type;
    data['label'] = this.label;
    if (this.scopedSlots != null) {
      data['scopedSlots'] = this.scopedSlots.toJson();
    }
    return data;
  }
}

