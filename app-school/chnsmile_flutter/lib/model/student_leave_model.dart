class StudentLeaveModel {
  int total;
  List<StudentLeave> list;

  StudentLeaveModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<StudentLeave>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(StudentLeave.fromJson(v));
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

class StudentLeave {
  String id;

  ///统计单主键id
  String formId;//表单编号
  String className;//班级名称
  String leaveStudentName;//请假学生姓名
  String headTeacherName;//班主任名称
  String dDate;//申请日期
  String dateStart;//请假开始时间
  String dateEnd;//请假结束时间
  int leaveType;//请假类型（1:病假，2:事假）
  int status;//表单状态（0未发送、1批阅中、2已备案、3已拒绝）
  int reviewStatus;//表单状态（0未发送、1批阅中、2已备案、3已拒绝）
  String approveDate;//审批时间
  double hours;//请假小时数

  String leaveDate;//缺勤日期
  String classId;//班级id
  String reason;//请假事由

  StudentLeave({
    this.id,
    this.formId,
    this.className,
    this.leaveStudentName,
    this.headTeacherName,
    this.dDate,
    this.dateStart,
    this.dateEnd,
    this.leaveType,
    this.status,
    this.reviewStatus,
    this.approveDate,
    this.hours,
    this.leaveDate,
    this.classId,
    this.reason,
  });

  StudentLeave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    className = json['className'];
    leaveStudentName = json['leaveStudentName'];
    headTeacherName = json['headTeacherName'];
    dDate = json['dDate'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    leaveType = json['leaveType'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    approveDate = json['approveDate'];
    hours = json['hours'];
    leaveDate = json['leaveDate'];
    classId = json['classId'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['className'] = this.className;
    data['leaveStudentName'] = this.leaveStudentName;
    data['headTeacherName'] = this.headTeacherName;
    data['dDate'] = this.dDate;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['leaveType'] = this.leaveType;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['approveDate'] = this.approveDate;
    data['hours'] = this.hours;
    data['leaveDate'] = this.leaveDate;
    data['classId'] = this.classId;
    data['reason'] = this.reason;
    return data;
  }


}


