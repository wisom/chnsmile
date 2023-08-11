class SelectPersonModel {
  List<SelectPerson> list;

  SelectPersonModel.fromJson(List json) {
    if (json != null) {
      list = List<SelectPerson>.empty(growable: true);
      json.forEach((v) {
        list.add(SelectPerson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class SelectPerson {
  String approveId;
  String id;
  String orgId;
  String orgName;
  String realName;

  SelectPerson(
      {
        this.approveId,
        this.id,
        this.orgId,
        this.orgName,
        this.realName,
      });

  SelectPerson.fromJson(Map<String, dynamic> json) {
    approveId = json['approveId'];
    id = json['id'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    realName = json['realName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approveId'] = this.approveId;
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['realName'] = this.realName;
    return data;
  }
}

