class TeacherPerformanceDetail2Model {
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
  List<String> studentScope;
  String attend;
  String publishTime;
  String studentName;
  List<CommentDictList> commentDictList;
  List<CommentDictList> attendDictList;

  TeacherPerformanceDetail2Model(
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
        this.attend,
        this.publishTime,
        this.studentName,
        this.commentDictList,
        this.attendDictList});

  TeacherPerformanceDetail2Model.fromJson(Map<String, dynamic> json) {
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
    studentScope = json['studentScope'].cast<String>();
    attend = json['attend'];
    publishTime = json['publishTime'];
    studentName = json['studentName'];
    if (json['commentDictList'] != null) {
      commentDictList = new List<CommentDictList>();
      json['commentDictList'].forEach((v) {
        commentDictList.add(new CommentDictList.fromJson(v));
      });
    }
    if (json['attendDictList'] != null) {
      attendDictList = new List<CommentDictList>();
      json['attendDictList'].forEach((v) {
        attendDictList.add(new CommentDictList.fromJson(v));
      });
    }
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
    data['attend'] = this.attend;
    data['publishTime'] = this.publishTime;
    data['studentName'] = this.studentName;
    if (this.commentDictList != null) {
      data['commentDictList'] =
          this.commentDictList.map((v) => v.toJson()).toList();
    }
    if (this.attendDictList != null) {
      data['attendDictList'] =
          this.attendDictList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentDictList {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String typeId;
  String value;
  String code;
  int sort;
  String remark;
  int status;
  bool checked;

  CommentDictList(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.typeId,
        this.value,
        this.code,
        this.sort,
        this.remark,
        this.status,
        this.checked});

  CommentDictList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    typeId = json['typeId'];
    value = json['value'];
    code = json['code'];
    sort = json['sort'];
    remark = json['remark'];
    status = json['status'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['typeId'] = this.typeId;
    data['value'] = this.value;
    data['code'] = this.code;
    data['sort'] = this.sort;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['checked'] = this.checked;
    return data;
  }
}

