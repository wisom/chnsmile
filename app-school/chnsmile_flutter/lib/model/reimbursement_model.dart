import 'package:chnsmile_flutter/model/reimburse_accessory_param.dart';
import 'package:chnsmile_flutter/model/reimburse_approve.dart';
import 'package:chnsmile_flutter/model/reimburse_item_detail.dart';

import 'attach.dart';

class ReimbursementModel {
  int total;
  List<Reimbursement> list;

  ReimbursementModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<Reimbursement>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(Reimbursement.fromJson(v));
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

class Reimbursement {
  String id;

  ///统计单主键id
  String formId;//表单编号
  String reimbursementPersonId;//报销人id
  String reimbursementPersonName;//报销人姓名
  String reimbursementDate;//报销日期
  String reimbursementCause;//报销事由
  String remark;//备注
  int status;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  int reviewStatus;//状态（0未发送、1批阅中、2已备案、3已拒绝）
  String budgetPriceTotal;//报销金额
  String userId;//发起人id
  String createName;//发起人
  String createTime;//发起时间
  List<ReimburseApprove> claimApproveList;//发起时间
  List<ReimburseItemDetail> itemList;//发起时间
  List<ReimburseAccessoryParam> accessoryList;//

  Reimbursement({
    this.id,
    this.formId,
    this.reimbursementPersonId,
    this.reimbursementPersonName,
    this.reimbursementDate,
    this.reimbursementCause,
    this.remark,
    this.status,
    this.reviewStatus,
    this.budgetPriceTotal,
    this.userId,
    this.createName,
    this.createTime
  });

  Reimbursement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    reimbursementPersonId = json['reimbursementPersonId'];
    reimbursementPersonName = json['reimbursementPersonName'];
    reimbursementDate = json['reimbursementDate'];
    reimbursementCause = json['reimbursementCause'];
    remark = json['remark'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    budgetPriceTotal = json['budgetPriceTotal'];
    userId = json['userId'];
    createName = json['createName'];
    createTime = json['createTime'];
    if (json['claimApproveList'] != null) {
      claimApproveList =
      List<ReimburseApprove>.empty(growable: true);
      json['claimApproveList'].forEach((v) {
        claimApproveList.add(ReimburseApprove.fromJson(v));
      });
    }
    if (json['itemList'] != null) {
      itemList =
      List<ReimburseItemDetail>.empty(growable: true);
      json['itemList'].forEach((v) {
        itemList.add(ReimburseItemDetail.fromJson(v));
      });
    }
    if (json['accessoryList'] != null) {
      accessoryList =
      List<ReimburseAccessoryParam>.empty(growable: true);
      json['accessoryList'].forEach((v) {
        accessoryList.add(ReimburseAccessoryParam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['reimbursementPersonId'] = this.reimbursementPersonId;
    data['reimbursementPersonName'] = this.reimbursementPersonName;
    data['reimbursementDate'] = this.reimbursementDate;
    data['reimbursementCause'] = this.reimbursementCause;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['budgetPriceTotal'] = this.budgetPriceTotal;
    data['userId'] = this.userId;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['claimApproveList'] = this.claimApproveList;
    data['itemList'] = this.itemList;
    data['accessoryList'] = this.accessoryList;
    return data;
  }

  @override
  String toString() {
    return 'Reimburse{id: $id, formId: $formId, reimbursementPersonId: $reimbursementPersonId, reimbursementPersonName: $reimbursementPersonName, reimbursementDate: $reimbursementDate, reimbursementCause: $reimbursementCause, remark: $remark, status: $status, reviewStatus: $reviewStatus, budgetPriceTotal: $budgetPriceTotal, userId: $userId, createName: $createName, createTime: $createTime, claimApproveList: $claimApproveList, itemList: $itemList, accessoryList: $accessoryList}';
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


