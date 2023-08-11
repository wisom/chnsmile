import 'package:chnsmile_flutter/model/reimburse_accessory_param.dart';

import 'attach.dart';

class ReimbursementDetailModel {
  String id = "";
  String reimbursementPersonId = "";
  String reimbursementPersonName = "";
  String formId = "";
  String reimbursementDate = "";
  String reimbursementCause = "";
  String remark = "";
  int status = 0;///状态（0未发送、1批阅中、2已备案、3已拒绝）
  String budgetPriceTotal = "0";
  String createName = "";
  String createTime = "";
  List<ReimburseAccessoryParam> accessoryList;
  List<ClaimApproveList> claimApproveList;
  List<ItemList> itemList;

  ReimbursementDetailModel(
      {this.id,
      this.reimbursementPersonId,
      this.reimbursementPersonName,
      this.formId,
      this.reimbursementDate,
      this.reimbursementCause,
      this.remark,
      this.status,
      this.budgetPriceTotal,
      this.createName,
      this.createTime,
      this.accessoryList,
      this.claimApproveList,
      this.itemList});

  ReimbursementDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reimbursementPersonName = json['reimbursementPersonName'];
    reimbursementPersonId = json['reimbursementPersonId'];
    formId = json['formId'];
    reimbursementDate = json['reimbursementDate'];
    reimbursementCause = json['reimbursementCause'];
    remark = json['remark'];
    status = json['status'];
    budgetPriceTotal = json['budgetPriceTotal'];
    createName = json['createName'];
    createTime = json['createTime'];
    if (json['accessoryList'] != null) {
      accessoryList = new List<ReimburseAccessoryParam>();
      json['accessoryList'].forEach((v) {
        accessoryList.add(new ReimburseAccessoryParam.fromJson(v));
      });
    }
    if (json['claimApproveList'] != null) {
      claimApproveList = new List<ClaimApproveList>();
      json['claimApproveList'].forEach((v) {
        claimApproveList.add(new ClaimApproveList.fromJson(v));
      });
    }
    if (json['itemList'] != null) {
      itemList = new List<ItemList>();
      json['itemList'].forEach((v) {
        itemList.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reimbursementPersonId'] = this.reimbursementPersonId;
    data['reimbursementPersonName'] = this.reimbursementPersonName;
    data['formId'] = this.formId;
    data['reimbursementDate'] = this.reimbursementDate;
    data['reimbursementCause'] = this.reimbursementCause;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['budgetPriceTotal'] = this.budgetPriceTotal;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    if (this.accessoryList != null) {
      data['accessoryList'] =
          this.accessoryList.map((v) => v.toJson()).toList();
    }
    if (this.claimApproveList != null) {
      data['claimApproveList'] =
          this.claimApproveList.map((v) => v.toJson()).toList();
    }
    if (this.itemList != null) {
      data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Attach> toAttachList() {
    List<Attach> list = [];
    accessoryList?.forEach((element) {
      list.add(Attach(
          attachId: element.fileId,
          attachUrl: element.fileUrl,
          origionName: element.fileName,
          attachSuffix: element.fileType,
          attachSizeInfo: element.fileSize));
    });
    return list;
  }
}

class ItemList {
  String itemId;
  String schoolId;
  String reimbursementId;
  String reimbursementType;
  int count;
  String amount;
  String remark;

  ItemList({
    this.itemId,
    this.schoolId,
    this.reimbursementId,
    this.reimbursementType,
    this.count,
    this.amount,
    this.remark,
  });

  ItemList.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    schoolId = json['schoolId'];
    reimbursementId = json['reimbursementId'];
    reimbursementType = json['reimbursementType'];
    count = json['count'];
    amount = json['amount'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['schoolId'] = this.schoolId;
    data['reimbursementId'] = this.reimbursementId;
    data['reimbursementType'] = this.reimbursementType;
    data['count'] = this.count;
    data['amount'] = this.amount;
    data['remark'] = this.remark;
    return data;
  }
}

class ClaimApproveList {
  String claimApproveId;
  String kinds;
  String orgId;
  String orgName;
  String approveId;
  String approveName;
  String approveTime;
  String createTime;
  int floor;
  String approveRemark;
  int sort;
  int status;

  ClaimApproveList({
    this.claimApproveId,
    this.kinds,
    this.orgId,
    this.orgName,
    this.approveId,
    this.approveName,
    this.approveTime,
    this.createTime,
    this.floor,
    this.approveRemark,
    this.sort,
    this.status,
  });

  ClaimApproveList.fromJson(Map<String, dynamic> json) {
    claimApproveId = json['claimApproveId'];
    kinds = json['kinds'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    approveId = json['approveId'];
    approveName = json['approveName'];
    approveTime = json['approveTime'];
    createTime = json['createTime'];
    floor = json['floor'];
    approveRemark = json['approveRemark'];
    sort = json['sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claimApproveId'] = this.claimApproveId;
    data['kinds'] = this.kinds;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['approveId'] = this.approveId;
    data['approveName'] = this.approveName;
    data['approveTime'] = this.approveTime;
    data['createTime'] = this.createTime;
    data['floor'] = this.floor;
    data['approveRemark'] = this.approveRemark;
    data['sort'] = this.sort;
    data['status'] = this.status;
    return data;
  }

}
