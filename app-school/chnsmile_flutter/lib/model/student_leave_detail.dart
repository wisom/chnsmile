import 'package:chnsmile_flutter/model/student_leave_approve.dart';
import 'package:chnsmile_flutter/model/student_leave_approve_detail.dart';

class StudentLeaveDetail {
  String id;
  String formId;
  String ddate;
  String classId;
  String className;
  String headTeacherId;
  String headTeacherName;
  String leaveStudentId;
  String leaveStudentName;
  int leaveType;//请假类型（1:病假，2:事假）
  String dateStart;//请假开始时间
  String dateEnd;
  double hours;//请假小时数
  int days;//请假天数，最小点位0,5天
  int weekendDays;
  String reason;
  String remark;
  int status;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  List<StudentLeaveApprove> studentLeaveApproveResultList;
  List<StudentLeaveApproveDetail> studentLeaveApproveDetailedList;

  StudentLeaveDetail(
      {this.id,
      this.formId,
      this.ddate,
      this.classId,
      this.className,
      this.headTeacherId,
      this.headTeacherName,
      this.leaveStudentId,
      this.leaveStudentName,
      this.leaveType,
      this.dateStart,
      this.dateEnd,
      this.hours,
      this.days,
      this.weekendDays,
      this.reason,
      this.remark,
      this.status,
      this.studentLeaveApproveResultList,
      this.studentLeaveApproveDetailedList});

  StudentLeaveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    ddate = json['ddate'];
    classId = json['classId'];
    className = json['className'];
    headTeacherId = json['headTeacherId'];
    headTeacherName = json['headTeacherName'];
    leaveStudentId = json['leaveStudentId'];
    leaveStudentName = json['leaveStudentName'];
    leaveType = json['leaveType'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
    days = json['days'];
    weekendDays = json['weekendDays'];
    reason = json['reason'];
    remark = json['remark'];
    status = json['status'];
    if (json['studentLeaveApproveResultList'] != null) {
      studentLeaveApproveResultList =
          List<StudentLeaveApprove>.empty(growable: true);
      json['fundClaimApproveParamList'].forEach((v) {
        studentLeaveApproveResultList.add(StudentLeaveApprove.fromJson(v));
      });
    }
    if (json['studentLeaveApproveDetailedList'] != null) {
      studentLeaveApproveDetailedList =
          List<StudentLeaveApproveDetail>.empty(growable: true);
      json['studentLeaveApproveDetailedList'].forEach((v) {
        studentLeaveApproveDetailedList.add(StudentLeaveApproveDetail.fromJson(v));
      });
    }
  }

  // List<Attach> toAttachList() {
  //   List<Attach> list = [];
  //   fundApplyAccessoryParamList.forEach((element) {
  //     list.add(Attach(
  //         attachId: element.fileId,
  //         attachUrl: element.fileUrl,
  //         origionName: element.fileName,
  //         attachSuffix: element.fileType,
  //         attachSizeInfo: element.fileSize));
  //   });
  //   return list;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['ddate'] = this.ddate;
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['headTeacherId'] = this.headTeacherId;
    data['headTeacherName'] = this.headTeacherName;
    data['leaveStudentId'] = this.leaveStudentId;
    data['leaveStudentName'] = this.leaveStudentName;
    data['leaveType'] = this.leaveType;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['hours'] = this.hours;
    data['days'] = this.days;
    data['weekendDays'] = this.weekendDays;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['studentLeaveApproveResultList'] = this.studentLeaveApproveResultList;
    data['studentLeaveApproveDetailedList'] = this.studentLeaveApproveDetailedList;
    return data;
  }
}
