class SuperNoticeModel {
    int total;
    List<SuperNotice> list;

    SuperNoticeModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<SuperNotice>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(SuperNotice.fromJson(v));
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

class SuperNotice {
  String formId;
  String title;
  String content;
  int grade; // 重要程度（1普通、2重要、3紧急）
  String createName;
  String createTime;
  int approveStatus; // 被通知人状态（0：待回复、1待读、2已读、3：已回复）
  int notReplyCount; // 未确认数

  SuperNotice(
      {
        this.formId,
        this.title,
        this.content,
        this.grade,
        this.createName,
        this.createTime,
        this.approveStatus,
        this.notReplyCount,
      });

  SuperNotice.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    grade = json['grade'];
    createName = json['createName'];
    createTime = json['createTime'];
    approveStatus = json['approveStatus'];
    notReplyCount = json['notReplyCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['grade'] = this.grade;
    data['createName'] = this.createName;
    data['createTime'] = this.createTime;
    data['approveStatus'] = this.approveStatus;
    data['notReplyCount'] = this.notReplyCount;
    return data;
  }

  @override
  String toString() {
    return 'SuperNotice{formId: $formId, title: $title, content: $content, grade: $grade, createName: $createName, createTime: $createTime, approveStatus: $approveStatus, notReplyCount: $notReplyCount}';
  }
}


