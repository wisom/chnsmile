class RepairModel {
    int total;
    List<Repair> list;

    RepairModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<Repair>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(Repair.fromJson(v));
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

class Repair {
  String id;
  String formId;
  String repairMer;
  int status; // status状态（0未发送、1批阅中、2已备案、3已拒绝）
  int reviewStatus; //  reviewStatus状态（0等待、1待批/待读、2已批/已读、3拒批）
  String cname;
  String ddate;

  Repair(
      {this.id,
        this.formId,
        this.repairMer,
        this.status,
        this.reviewStatus,
        this.cname,
        this.ddate});

  Repair.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    repairMer = json['repairMer'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    cname = json['cname'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['repairMer'] = this.repairMer;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['cname'] = this.cname;
    data['ddate'] = this.ddate;
    return data;
  }

  @override
  String toString() {
    return cname;
  }
}


