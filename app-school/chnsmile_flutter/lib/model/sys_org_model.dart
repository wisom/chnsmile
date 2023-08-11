class SysOrgModel {
  List<SysOrg> list;

  SysOrgModel.fromJson(List json) {
    if (json != null) {
      list = List<SysOrg>.empty(growable: true);
      json.forEach((v) {
        list.add(SysOrg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class SysOrg {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String pid;
  String pids;
  String name;
  String code;
  int sort;
  String remark;
  int status;

  SysOrg(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.pid,
        this.pids,
        this.name,
        this.code,
        this.sort,
        this.remark,
        this.status});

  SysOrg.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    pid = json['pid'];
    pids = json['pids'];
    name = json['name'];
    code = json['code'];
    sort = json['sort'];
    remark = json['remark'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['pids'] = this.pids;
    data['name'] = this.name;
    data['code'] = this.code;
    data['sort'] = this.sort;
    data['remark'] = this.remark;
    data['status'] = this.status;
    return data;
  }
}

