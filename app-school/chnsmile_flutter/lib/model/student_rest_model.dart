class StudentRestModel {
    int total;
    List<StudentRest> list;

    StudentRestModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<StudentRest>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(StudentRest.fromJson(v));
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

class StudentRest {
  String id;
  String formId;
  String className;
  String leaveStudentName;
  String headTeacherName;
  String dDate;
  String dateStart;
  String dateEnd;
  int leaveType;//请假类型（1:病假，2:事假）
  int status;
  int hours;
  int reviewStatus;
  String ddate;

  StudentRest(
      {this.id,
        this.formId,
        this.className,
        this.leaveStudentName,
        this.headTeacherName,
        this.dDate,
        this.dateStart,
        this.dateEnd,
        this.leaveType,
        this.status,
        this.hours,
        this.reviewStatus,
        this.ddate,
      });

  StudentRest.fromJson(Map<String, dynamic> json) {
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
    hours = json['hours'];
    reviewStatus = json['reviewStatus'];
    ddate = json['ddate'];
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
    data['hours'] = this.hours;
    data['reviewStatus'] = this.reviewStatus;
    data['ddate'] = this.ddate;
    return data;
  }

}


