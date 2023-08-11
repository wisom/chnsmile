class OAPeople {
  String kinds; // 1 审批， 2 通知
  String approveId;
  String floor;

  OAPeople({this.kinds, this.approveId, this.floor = "0"});

  OAPeople.fromJson(Map<String, dynamic> json) {
    kinds = json['kinds'];
    approveId = json['approveId'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['kinds'] = kinds;
    data['approveId'] = approveId;
    data['floor'] = floor;
    return data;
  }

  Map<String, dynamic> toJson2() {
    Map<String, dynamic> data = Map();
    data['kinds'] = kinds;
    data['approveId'] = approveId;
    data['sort'] = floor;
    return data;
  }

  @override
  String toString() {
    return "$kinds + $approveId + $floor";
  }
}