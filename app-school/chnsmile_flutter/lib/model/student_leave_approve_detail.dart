class StudentLeaveApproveDetail {
  String id;
  String leaveId;
  String leaveDate;
  String dateStart;
  String dateEnd;
  String hours;


  StudentLeaveApproveDetail({
      this.id,
      this.leaveId,
      this.leaveDate,
      this.dateStart,
      this.dateEnd,
      this.hours,
  });

  StudentLeaveApproveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveId = json['leaveId'];
    leaveDate = json['leaveDate'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['leaveId'] = leaveId;
    data['leaveDate'] = leaveDate;
    data['dateStart'] = dateStart;
    data['dateEnd'] = dateEnd;
    data['hours'] = hours;
    return data;
  }
}
