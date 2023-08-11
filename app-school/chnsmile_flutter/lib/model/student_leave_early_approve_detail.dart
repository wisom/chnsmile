class StudentLeaveEarlyApproveDetail {
  String id;
  String earlyId;
  String earlyDate;
  String dateStart;
  String dateEnd;
  String hours;


  StudentLeaveEarlyApproveDetail({
      this.id,
      this.earlyId,
      this.earlyDate,
      this.dateStart,
      this.dateEnd,
      this.hours,
  });

  StudentLeaveEarlyApproveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    earlyId = json['earlyId'];
    earlyDate = json['earlyDate'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['earlyId'] = earlyId;
    data['earlyDate'] = earlyDate;
    data['dateStart'] = dateStart;
    data['dateEnd'] = dateEnd;
    data['hours'] = hours;
    return data;
  }
}
