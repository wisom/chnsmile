class ClassTransferItem {
  String approveId;
  String clazz;
  String clazzName;
  String course;
  String courseName;
  String approveName;
  String approveDate;
  String newDate;
  String newNo;
  String newNoName;
  String oldDate;
  String oldNo;
  String oldNoName;
  String tealId;
  String tealName;
  String kinds;
  int status;
  String approveRemark;
  int type; // 本地添加: 0，保存 : 1， 发布状态 : 2

  ClassTransferItem(
      {this.approveId,
        this.clazz,
        this.clazzName,
        this.course,
        this.courseName,
        this.approveDate,
        this.newDate,
        this.newNo,
        this.newNoName,
        this.oldDate,
        this.kinds,
        this.oldNo,
        this.approveName,
        this.oldNoName,
        this.tealName,
        this.status = -1,
        this.type = 0,
        this.approveRemark,
        this.tealId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['approveId'] = approveId;
    data['clazz'] = clazz;
    data['clazzName'] = clazzName;
    data['course'] = course;
    data['courseName'] = courseName;
    data['newDate'] = newDate;
    data['kinds'] = kinds;
    data['newNo'] = newNo;
    data['oldDate'] = oldDate;
    data['status'] = status;
    data['approveName'] = approveName;
    data['approveRemark'] = approveRemark;
    data['oldNo'] = oldNo;
    data['tealId'] = tealId;
    return data;
  }
}
