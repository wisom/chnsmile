class SuperFileModel {
    int total;
    List<SuperFile> list;

    SuperFileModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<SuperFile>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(SuperFile.fromJson(v));
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

class SuperFile {
  String formId;
  String title;
  int grade; // 重要程度（1普通、2重要、3紧急）
  String createName;
  String createTime;
  int approveStatus; // 被通知人状态（0：待回复、1待读、2已读、3：已回复）

  SuperFile(
      {
        this.formId,
        this.title,
        this.grade,
        this.createName,
        this.createTime});

  SuperFile.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    title = json['title'];
    grade = json['grade'];
    createName = json['createName'];
    createTime = json['createTime'];
    approveStatus = json['approveStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['grade'] = this.grade;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['approveStatus'] = this.approveStatus;
    return data;
  }

}


