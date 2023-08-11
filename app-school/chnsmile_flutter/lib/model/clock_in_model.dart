

class ClockInModel{
  int total;
  List<ClockIn> list;

  ClockInModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<ClockIn>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(ClockIn.fromJson(v));
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

class ClockIn {
  String punchId;//打卡管理主键id
  String title;//标题
  String startDate;//开始时间2023-05-23
  String endDate;//结束时间
  String punchStatusLabel;//未开始、已结束
  List<String> gradClass;//参与班级
  int releaseStatus;//发布状态（0：未发布，1：已发布，3：已撤回）
  List<int> clockFrequencys;//打卡频次（0：每天，1：周一，2：周二，3：周三，4：周四，5：周五，6：周六，7：周日）
  int dayAlready;//打卡已进行天数
  int dayTotal;//打卡总天数

  ClockIn({
    this.punchId,
    this.title,
    this.startDate,
    this.endDate,
    this.punchStatusLabel,
    this.gradClass,
    this.releaseStatus,
    this.dayAlready,
    this.dayTotal,
  });

  ClockIn.fromJson(Map<String, dynamic> json) {
    punchId = json['punchId'];
    title = json['title'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    punchStatusLabel = json['punchStatusLabel'];
    punchStatusLabel = json['punchStatusLabel'];
    gradClass = json['gradClass'] != null ? json['gradClass'].cast<String>() : [];
    releaseStatus = json['releaseStatus'];
    clockFrequencys = json['clockFrequencys'] != null ? json['clockFrequencys'].cast<int>() : [];
    dayAlready = json['dayAlready'];
    dayTotal = json['dayTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['punchId'] = this.punchId;
    data['title'] = this.title;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['punchStatusLabel'] = this.punchStatusLabel;
    data['gradClass'] = this.gradClass;
    data['releaseStatus'] = this.releaseStatus;
    data['clockFrequencys'] = this.clockFrequencys;
    data['dayAlready'] = this.dayAlready;
    data['dayTotal'] = this.dayTotal;
    return data;
  }
}


