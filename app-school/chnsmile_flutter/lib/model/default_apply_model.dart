class DefaultApplyModel {
  String id;
  String moduleName;
  String moduleId;
  DefaultApprove defaultApprove;
  DefaultApprove defaultNotice;

  DefaultApplyModel(
      {this.id,
        this.moduleName,
        this.moduleId,
        this.defaultApprove,
        this.defaultNotice});

  DefaultApplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['moduleName'];
    moduleId = json['moduleId'];
    defaultApprove = json['defaultApprove'] != null
        ? new DefaultApprove.fromJson(json['defaultApprove'])
        : null;
    defaultNotice = json['defaultNotice'] != null
        ? new DefaultApprove.fromJson(json['defaultNotice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['moduleName'] = this.moduleName;
    data['moduleId'] = this.moduleId;
    if (this.defaultApprove != null) {
      data['defaultApprove'] = this.defaultApprove.toJson();
    }
    if (this.defaultNotice != null) {
      data['defaultNotice'] = this.defaultNotice.toJson();
    }
    return data;
  }
}

class DefaultApprove {
  String id;
  String moduleId;
  String processName;
  int kinds;
  List<ProcessInfo> processMxList;

  DefaultApprove(
      {this.id,
        this.moduleId,
        this.processName,
        this.kinds,
        this.processMxList});

  DefaultApprove.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['moduleId'];
    processName = json['processName'];
    kinds = json['kinds'];
    if (json['processMxList'] != null) {
      processMxList = new List<ProcessInfo>();
      json['processMxList'].forEach((v) {
        processMxList.add(new ProcessInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['moduleId'] = this.moduleId;
    data['processName'] = this.processName;
    data['kinds'] = this.kinds;
    if (this.processMxList != null) {
      data['processMxList'] =
          this.processMxList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return id;
  }
}

class ProcessInfo {
  String id;
  String orgId;
  String orgName;
  String agentId; // 是否能删除，有值就说明不能删除，没值可以删除，目前只用在document_approve_page页面
  String userId;
  String approveId;
  String approveName;
  String process;
  String avatar;
  String avatarImg;
  int sort;
  String floor;
  bool isHeadMaster;

  ProcessInfo(
      {this.orgId = "",
        this.id = "",
        this.orgName = "",
        this.userId,
        this.approveId = "",
        this.approveName = "",
        this.process = "",
        this.avatar = "",
        this.floor = "0",
        this.agentId = "",
        this.avatarImg = "",
        this.isHeadMaster = false,
        this.sort = 0});

  ProcessInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    userId = json['userId'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    process = json['process'];
    floor = json['floor'];
    avatar = json['avatar'];
    agentId = json['agentId'];
    avatarImg = json['avatarImg'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['userId'] = this.userId;
    data['agentId'] = this.agentId;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['process'] = this.process;
    data['avatar'] = this.avatar;
    data['floor'] = this.floor;
    data['avatarImg'] = this.avatarImg;
    data['sort'] = this.sort;
    return data;
  }

  @override
  bool operator ==(Object other) {
    ProcessInfo p1 = other;
    return userId == p1.userId;
  }

  @override
  String toString() {
    return approveName;
  }
}
