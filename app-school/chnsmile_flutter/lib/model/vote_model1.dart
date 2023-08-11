class VoteModel1 {
    int total;
    List<Vote> list;

    VoteModel1.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<Vote>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(Vote.fromJson(v));
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

class Vote {
  String id;
  String voteTitle;
  String voteDesc;
  String teacherId;
  int voteType;
  String startTime;
  String endTime;
  int status;
  String publicTime;
  String cancelTime;
  String updateTime;
  int voteStatus;
  String teacherName;
  String noticeUserSum;
  String voteStatusLabel;

  Vote(
      {this.id,
        this.voteTitle,
        this.voteDesc,
        this.teacherId,
        this.voteType,
        this.startTime,
        this.endTime,
        this.status,
        this.publicTime,
        this.cancelTime,
        this.updateTime,
        this.voteStatus,
        this.teacherName,
        this.noticeUserSum,
        this.voteStatusLabel});

  Vote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voteTitle = json['voteTitle'];
    voteDesc = json['voteDesc'];
    teacherId = json['teacherId'];
    voteType = json['voteType'];
    startTime = json['startTime'];
    updateTime = json['updateTime'];
    endTime = json['endTime'];
    status = json['status'];
    publicTime = json['publicTime'];
    cancelTime = json['cancelTime'];
    voteStatus = json['voteStatus'];
    teacherName = json['teacherName'];
    noticeUserSum = json['noticeUserSum'];
    voteStatusLabel = json['voteStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voteTitle'] = this.voteTitle;
    data['voteDesc'] = this.voteDesc;
    data['teacherId'] = this.teacherId;
    data['voteType'] = this.voteType;
    data['startTime'] = this.startTime;
    data['updateTime'] = this.updateTime;
    data['endTime'] = this.endTime;
    data['status'] = this.status;
    data['publicTime'] = this.publicTime;
    data['cancelTime'] = this.cancelTime;
    data['voteStatus'] = this.voteStatus;
    data['teacherName'] = this.teacherName;
    data['noticeUserSum'] = this.noticeUserSum;
    data['voteStatusLabel'] = this.voteStatusLabel;
    return data;
  }
}


