class NoticeReadModel {
  String classId;
  List<Read> unReadList;
  List<Read> readList;

  NoticeReadModel({this.classId, this.unReadList, this.readList});

  NoticeReadModel.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    if (json['unReadList'] != null) {
      unReadList = new List<Read>();
      json['unReadList'].forEach((v) {
        unReadList.add(new Read.fromJson(v));
      });
    }
    if (json['readList'] != null) {
      readList = new List<Read>();
      json['readList'].forEach((v) {
        readList.add(new Read.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    if (this.unReadList != null) {
      data['unReadList'] = this.unReadList.map((v) => v.toJson()).toList();
    }
    if (this.readList != null) {
      data['readList'] = this.readList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Read {
  String studentId;
  String studentName;
  List<ParentInfoList> parentInfoList;

  Read({this.studentId, this.studentName, this.parentInfoList});

  Read.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    if (json['parentInfoList'] != null) {
      parentInfoList = new List<ParentInfoList>();
      json['parentInfoList'].forEach((v) {
        parentInfoList.add(new ParentInfoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    if (this.parentInfoList != null) {
      data['parentInfoList'] =
          this.parentInfoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentInfoList {
  String userId;
  String parentId;
  String parentName;
  String relation;

  ParentInfoList({this.userId, this.parentId, this.parentName, this.relation});

  ParentInfoList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    parentId = json['parentId'];
    parentName = json['parentName'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['parentId'] = this.parentId;
    data['parentName'] = this.parentName;
    data['relation'] = this.relation;
    return data;
  }
}
