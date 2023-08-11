class TeacherGrowthDictModel {
  List<CommentList> commentList;
  List<CommentList> attendList;

  TeacherGrowthDictModel({this.commentList, this.attendList});

  TeacherGrowthDictModel.fromJson(Map<String, dynamic> json) {
    if (json['commentList'] != null) {
      commentList = new List<CommentList>();
      json['commentList'].forEach((v) {
        commentList.add(new CommentList.fromJson(v));
      });
    }
    if (json['attendList'] != null) {
      attendList = new List<CommentList>();
      json['attendList'].forEach((v) {
        attendList.add(new CommentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commentList != null) {
      data['commentList'] = this.commentList.map((v) => v.toJson()).toList();
    }
    if (this.attendList != null) {
      data['attendList'] = this.attendList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentList {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String typeId;
  String value;
  String code;
  int sort;
  String remark;
  int status;
  bool checked;

  CommentList(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.typeId,
        this.value,
        this.code,
        this.sort,
        this.remark,
        this.status,
        this.checked});

  CommentList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    typeId = json['typeId'];
    value = json['value'];
    code = json['code'];
    sort = json['sort'];
    remark = json['remark'];
    status = json['status'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['typeId'] = this.typeId;
    data['value'] = this.value;
    data['code'] = this.code;
    data['sort'] = this.sort;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['checked'] = this.checked;
    return data;
  }
}
