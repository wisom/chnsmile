class StudentLeaveEarlyModel {
  int total;
  List<StudentLeaveEarly> list;

  StudentLeaveEarlyModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<StudentLeaveEarly>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(StudentLeaveEarly.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class StudentLeaveEarly {
  String id;//学生早退id

  ///统计单主键id
  String formId;//表单编号
  String schoolId;//学校id
  String classId;//班级id
  String className;//班级名称
  String headTeacherId;//班主任id
  String headTeacherName;//班主任名称
  String earlyStudentId;//早退学生id
  String earlyStudentName;//早退学生姓名
  int applyKinds;//
  int earlyType;//早退类型（1:病假，2:事假）
  String dateStart;//早退开始时间
  String dateEnd;//早退结束时间
  double hours;//
  String reason;//早退事由
  String remark;//备注
  int status;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  int reviewStatus;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  String createUser;//"1558705171129663489"
  String createName;//"丁国元"
  String createTime;//发起时间
  String ddate;//

  StudentLeaveEarly({
    this.id,
    this.formId,
    this.schoolId,
    this.classId,
    this.className,
    this.headTeacherId,
    this.headTeacherName,
    this.earlyStudentId,
    this.earlyStudentName,
    this.earlyType,
    this.applyKinds,
    this.dateStart,
    this.dateEnd,
    this.hours,
    this.reason,
    this.remark,
    this.status,
    this.reviewStatus,
    this.createUser,
    this.createName,
    this.createTime,
    this.ddate,
  });

  StudentLeaveEarly.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    schoolId = json['schoolId'];
    classId = json['classId'];
    className = json['className'];
    headTeacherId = json['headTeacherId'];
    headTeacherName = json['headTeacherName'];
    earlyStudentId = json['earlyStudentId'];
    earlyStudentName = json['earlyStudentName'];
    earlyType = json['earlyType'];
    applyKinds = json['applyKinds'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
    reason = json['reason'];
    remark = json['remark'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    createUser = json['createUser'];
    createName = json['createName'];
    createTime = json['createTime'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['schoolId'] = this.schoolId;
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['headTeacherId'] = this.headTeacherId;
    data['headTeacherName'] = this.headTeacherName;
    data['earlyStudentId'] = this.earlyStudentId;
    data['earlyStudentName'] = this.earlyStudentName;
    data['earlyType'] = this.earlyType;
    data['applyKinds'] = this.applyKinds;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['hours'] = this.hours;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['createUser'] = this.createUser;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['ddate'] = this.ddate;
    return data;
  }


}


