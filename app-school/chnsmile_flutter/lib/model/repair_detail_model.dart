import 'package:chnsmile_flutter/model/attach.dart';

class RepairDetailModel {
  SchoolOaRepair schoolOaRepair;
  List<SchoolOaRepairApproveList> schoolOaRepairApproveList;
  List<Attach> schoolOaRepairEnclosureList;

  RepairDetailModel(
      {this.schoolOaRepair,
        this.schoolOaRepairApproveList,
        this.schoolOaRepairEnclosureList});

  RepairDetailModel.fromJson(Map<String, dynamic> json) {
    schoolOaRepair = json['schoolOaRepair'] != null
        ? new SchoolOaRepair.fromJson(json['schoolOaRepair'])
        : null;
    if (json['schoolOaRepairApproveList'] != null) {
      schoolOaRepairApproveList = new List<SchoolOaRepairApproveList>();
      json['schoolOaRepairApproveList'].forEach((v) {
        schoolOaRepairApproveList
            .add(new SchoolOaRepairApproveList.fromJson(v));
      });
    }
    if (json['schoolOaRepairEnclosureList'] != null) {
      schoolOaRepairEnclosureList = new List<Attach>();
      json['schoolOaRepairEnclosureList'].forEach((v) {
        schoolOaRepairEnclosureList.add(new Attach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schoolOaRepair != null) {
      data['schoolOaRepair'] = this.schoolOaRepair.toJson();
    }
    if (this.schoolOaRepairApproveList != null) {
      data['schoolOaRepairApproveList'] =
          this.schoolOaRepairApproveList.map((v) => v.toJson()).toList();
    }
    if (this.schoolOaRepairEnclosureList != null) {
      data['schoolOaRepairEnclosureList'] =
          this.schoolOaRepairEnclosureList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchoolOaRepair {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String deptName;
  String id;
  String schoolId;
  String formId;
  String workId;
  String deptId;
  String repairKinds;
  String repairMer;
  String tel;
  String email;
  String repairAddress;
  String content;
  String repairResult;
  String repairReport;
  String remark;
  int status; // status状态（0未发送、1批阅中、2已备案、3已拒绝）
  int type;
  String cname;
  String ddate;

  SchoolOaRepair(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.deptName = "",
        this.updateUser = "",
        this.id,
        this.schoolId,
        this.formId,
        this.workId,
        this.deptId,
        this.repairKinds,
        this.repairMer,
        this.tel,
        this.email,
        this.repairAddress,
        this.content,
        this.repairResult,
        this.repairReport,
        this.remark,
        this.status,
        this.type,
        this.cname,
        this.ddate});

  SchoolOaRepair.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    deptName = json['deptName'];
    updateUser = json['updateUser'];
    id = json['id'];
    schoolId = json['schoolId'];
    formId = json['formId'];
    workId = json['workId'];
    deptId = json['deptId'];
    repairKinds = json['repairKinds'];
    repairMer = json['repairMer'];
    tel = json['tel'];
    email = json['email'];
    repairAddress = json['repairAddress'];
    content = json['content'];
    repairResult = json['repairResult'];
    repairReport = json['repairReport'];
    remark = json['remark'];
    status = json['status'];
    type = json['type'];
    cname = json['cname'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['deptName'] = this.deptName;
    data['id'] = this.id;
    data['schoolId'] = this.schoolId;
    data['formId'] = this.formId;
    data['workId'] = this.workId;
    data['deptId'] = this.deptId;
    data['repairKinds'] = this.repairKinds;
    data['repairMer'] = this.repairMer;
    data['tel'] = this.tel;
    data['email'] = this.email;
    data['repairAddress'] = this.repairAddress;
    data['content'] = this.content;
    data['repairResult'] = this.repairResult;
    data['repairReport'] = this.repairReport;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['type'] = this.type;
    data['cname'] = this.cname;
    data['ddate'] = this.ddate;
    return data;
  }
}

class SchoolOaRepairApproveList {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String schoolId;
  String formId;
  String process;
  String kinds;
  String deptId;
  String deptName;
  String userId;
  String approveId;
  String approveName;
  String approveImg;
  String agentId;
  String adentName;
  String agentImg;
  String approveDate;
  String approveRemark;
  String repairResult;
  String repairReport;
  int floor;
  int sort;
  int status;

  SchoolOaRepairApproveList(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser = "",
        this.id,
        this.schoolId,
        this.formId,
        this.process,
        this.kinds,
        this.deptId,
        this.deptName,
        this.userId,
        this.approveId,
        this.approveName,
        this.approveImg,
        this.agentId,
        this.adentName = "",
        this.agentImg = "",
        this.approveDate = "",
        this.approveRemark,
        this.repairResult,
        this.repairReport,
        this.floor,
        this.sort,
        this.status});

  SchoolOaRepairApproveList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    schoolId = json['schoolId'];
    formId = json['formId'];
    process = json['process'];
    kinds = json['kinds'];
    deptId = json['deptId'];
    deptName = json['deptName'];
    userId = json['userId'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    approveImg = json['approveImg'];
    agentId = json['agentId'];
    adentName = json['adentName'];
    agentImg = json['agentImg'];
    approveDate = json['approveDate'];
    approveRemark = json['approveRemark'];
    repairResult = json['repairResult'];
    repairReport = json['repairReport'];
    floor = json['floor'];
    sort = json['sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['schoolId'] = this.schoolId;
    data['formId'] = this.formId;
    data['process'] = this.process;
    data['kinds'] = this.kinds;
    data['deptId'] = this.deptId;
    data['deptName'] = this.deptName;
    data['userId'] = this.userId;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['approveImg'] = this.approveImg;
    data['agentId'] = this.agentId;
    data['adentName'] = this.adentName;
    data['agentImg'] = this.agentImg;
    data['approveDate'] = this.approveDate;
    data['approveRemark'] = this.approveRemark;
    data['repairResult'] = this.repairResult;
    data['repairReport'] = this.repairReport;
    data['floor'] = this.floor;
    data['sort'] = this.sort;
    data['status'] = this.status;
    return data;
  }
}
