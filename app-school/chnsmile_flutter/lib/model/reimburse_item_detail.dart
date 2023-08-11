class ReimburseItemDetail {
  String itemId;//报销明细id
  String schoolId;//学校id
  String reimbursementId;//报销id
  String reimbursementType;//报销类型
  int count;//报销数量
  double amount;//报销金额
  String remark;//备注

  ReimburseItemDetail(
      {this.itemId,
        this.schoolId,
        this.reimbursementId,
        this.reimbursementType,
        this.count,
        this.amount,
        this.remark});

  ReimburseItemDetail.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    schoolId = json['schoolId'];
    reimbursementId = json['reimbursementId'];
    reimbursementType = json['reimbursementType'];
    count = json['count'];
    amount = json['amount'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['schoolId'] = schoolId;
    data['reimbursementId'] = reimbursementId;
    data['reimbursementType'] = reimbursementType;
    data['count'] = count;
    data['amount'] = amount;
    data['remark'] = remark;
    return data;
  }


}
