class SchoolVoteModel {
    int total;
    List<SchoolVote> list;

    SchoolVoteModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<SchoolVote>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(SchoolVote.fromJson(v));
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

class SchoolVote {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String voteTitle;
  String voteDesc;
  String schoolId;
  String teacherId;
  int voteType;
  String startTime;
  String endTime;
  String voteScope;
  String noticeId;
  int status;
  String publicTime;
  int voteStatus;
  String teacherName;
  String voteStatusLabel;

  SchoolVote(
      {this.createTime = "",
        this.createUser = "",
        this.updateTime = "",
        this.updateUser = "",
        this.id,
        this.voteTitle,
        this.voteDesc,
        this.schoolId = "",
        this.teacherId,
        this.voteType,
        this.startTime,
        this.endTime,
        this.voteScope,
        this.noticeId = "",
        this.status = 0,
        this.publicTime,
        this.voteStatus,
        this.teacherName,
        this.voteStatusLabel});

  SchoolVote.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    voteTitle = json['voteTitle'];
    voteDesc = json['voteDesc'];
    schoolId = json['schoolId'];
    teacherId = json['teacherId'];
    voteType = json['voteType'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    voteScope = json['voteScope'];
    noticeId = json['noticeId'];
    status = json['status'];
    publicTime = json['publicTime'];
    voteStatus = json['voteStatus'];
    teacherName = json['teacherName'];
    voteStatusLabel = json['voteStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['voteTitle'] = this.voteTitle;
    data['voteDesc'] = this.voteDesc;
    data['schoolId'] = this.schoolId;
    data['teacherId'] = this.teacherId;
    data['voteType'] = this.voteType;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['voteScope'] = this.voteScope;
    data['noticeId'] = this.noticeId;
    data['status'] = this.status;
    data['publicTime'] = this.publicTime;
    data['voteStatus'] = this.voteStatus;
    data['teacherName'] = this.teacherName;
    data['voteStatusLabel'] = this.voteStatusLabel;
    return data;
  }
}
