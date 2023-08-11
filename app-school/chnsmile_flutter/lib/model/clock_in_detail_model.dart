

class ClockInDetail {
  String startDate;//开始时间2023-05-23
  String endDate;//结束时间
  List<int> punchDays;//打卡频次（0：每天，1：周一，2：周二，3：周三，4：周四，5：周五，6：周六，7：周日）

  ClockInDetail({
    this.startDate,
    this.endDate,
    this.punchDays,
  });

  ClockInDetail.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    punchDays = json['punchDays'] != null ? json['punchDays'].cast<int>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['punchDays'] = this.punchDays;
    return data;
  }

  @override
  String toString() {
    return 'ClockInDetail{startDate: $startDate, endDate: $endDate, punchDays: $punchDays}';
  }
}


