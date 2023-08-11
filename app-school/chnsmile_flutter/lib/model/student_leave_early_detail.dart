import 'package:chnsmile_flutter/model/student_leave_approve.dart';
import 'package:chnsmile_flutter/model/student_leave_approve_detail.dart';
import 'package:chnsmile_flutter/model/student_leave_early_approve.dart';
import 'package:chnsmile_flutter/model/student_leave_early_approve_detail.dart';

class StudentLeaveEarlyDetail {
  String id;
  String schoolId;
  String formId;
  String ddate;
  String classId;
  String className;
  String headTeacherId;
  String headTeacherName;
  String earlyStudentId;
  String earlyStudentName;
  int earlyType;//早退类型 1:代理
  String dateStart;//请假开始时间
  String dateEnd;
  double hours;//请假小时数
  int days;//请假天数，最小点位0,5天
  String reason;
  String remark;
  String createUser;//"1558705170689261570"
  String createName;//"丁国元"
  String createTime;
  int status;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  List<StudentLeaveEarlyApprove> studentEarlyApproveList;
  List<StudentLeaveEarlyApproveDetail> studentEarlyApproveDetailedList;

  StudentLeaveEarlyDetail(
      {this.id,
      this.schoolId,
      this.formId,
      this.ddate,
      this.classId,
      this.className,
      this.headTeacherId,
      this.headTeacherName,
      this.earlyStudentId,
      this.earlyStudentName,
      this.earlyType,
      this.dateStart,
      this.dateEnd,
      this.hours,
      this.days,
      this.reason,
      this.remark,
      this.createUser,
      this.createName,
      this.createTime,
      this.status,
      this.studentEarlyApproveList,
      this.studentEarlyApproveDetailedList});

  StudentLeaveEarlyDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolId = json['schoolId'];
    formId = json['formId'];
    ddate = json['ddate'];
    classId = json['classId'];
    className = json['className'];
    headTeacherId = json['headTeacherId'];
    headTeacherName = json['headTeacherName'];
    earlyStudentId = json['earlyStudentId'];
    earlyStudentName = json['earlyStudentName'];
    earlyType = json['earlyType'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
    days = json['days'];
    reason = json['reason'];
    remark = json['remark'];
    createUser = json['createUser'];
    createName = json['createName'];
    createTime = json['createTime'];
    status = json['status'];
    if (json['studentEarlyApproveList'] != null) {
      studentEarlyApproveList =
          List<StudentLeaveEarlyApprove>.empty(growable: true);
      json['studentEarlyApproveList'].forEach((v) {
        studentEarlyApproveList.add(StudentLeaveEarlyApprove.fromJson(v));
      });
    }
    if (json['studentEarlyApproveDetailedList'] != null) {
      studentEarlyApproveDetailedList =
          List<StudentLeaveEarlyApproveDetail>.empty(growable: true);
      json['studentEarlyApproveDetailedList'].forEach((v) {
        studentEarlyApproveDetailedList.add(StudentLeaveEarlyApproveDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schoolId'] = this.schoolId;
    data['formId'] = this.formId;
    data['ddate'] = this.ddate;
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['headTeacherId'] = this.headTeacherId;
    data['headTeacherName'] = this.headTeacherName;
    data['earlyStudentId'] = this.earlyStudentId;
    data['earlyStudentName'] = this.earlyStudentName;
    data['earlyType'] = this.earlyType;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['hours'] = this.hours;
    data['days'] = this.days;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
    data['createUser'] = this.createUser;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['status'] = this.status;
    data['studentEarlyApproveList'] = this.studentEarlyApproveList;
    data['studentEarlyApproveDetailedList'] = this.studentEarlyApproveDetailedList;
    return data;
  }
}
