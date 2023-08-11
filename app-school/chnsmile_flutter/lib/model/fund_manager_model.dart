class FundManagerModel {
  int total;
  List<FundManager> list;

  FundManagerModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    list = List<FundManager>.empty(growable: true);
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        list.add(FundManager.fromJson(v));
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

class FundManager {
  String id;

  ///统计单主键id
  String formId;

  ///统计单名称
  String orgName;

  ///统计单描述
  String content;
  String remark;
  String budget; //预算总金额
  int status; //状态（0未发送、1批阅中、2已备案、3已拒绝）
  String needDate;
  String createTime;

  FundManager(
      {this.id,
      this.formId,
      this.orgName,
      this.content,
      this.remark,
      this.budget,
      this.status,
      this.needDate,
      this.createTime});

  FundManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    orgName = json['orgName'];
    content = json['content'];
    remark = json['remark'];
    budget = json['budget'];
    status = json['status'];
    needDate = json['needDate'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['orgName'] = this.orgName;
    data['content'] = this.content;
    data['remark'] = this.remark;
    data['budget'] = this.budget;
    data['status'] = this.status;
    data['needDate'] = this.needDate;
    data['createTime'] = this.createTime;
    return data;
  }

  @override
  String toString() {
    return 'FundManager{id: $id, formId: $formId, orgName: $orgName, content: $content, remark: $remark, budget: $budget, status: $status, needDate: $needDate, createTime: $createTime}';
  }
}
