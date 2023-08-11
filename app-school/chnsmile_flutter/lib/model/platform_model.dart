
class PlatformModel {
  List<Platform> list;

  PlatformModel.fromJson(List json) {
    if (json != null) {
      list = List<Platform>.empty(growable: true);
      json.forEach((v) {
        list.add(Platform.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class Platform {
  String account;
  String deployType;
  String hostUrl;
  String hostUrl1;
  String onlineState;
  String studentName;
  String studentId;
  String schoolId;

  Platform(
      {this.account,
        this.deployType,
        this.hostUrl,
        this.hostUrl1,
        this.onlineState,
        this.studentName,
        this.studentId,
        this.schoolId});

  Platform.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    deployType = json['deployType'];
    hostUrl = json['hostUrl'];
    hostUrl1 = json['hostUrl1'];
    onlineState = json['onlineState'];
    studentName = json['studentName'];
    studentId = json['studentId'];
    schoolId = json['schoolId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['deployType'] = this.deployType;
    data['hostUrl'] = this.hostUrl;
    data['hostUrl1'] = this.hostUrl1;
    data['onlineState'] = this.onlineState;
    data['studentName'] = this.studentName;
    data['studentId'] = this.studentId;
    data['schoolId'] = this.schoolId;
    return data;
  }
}



