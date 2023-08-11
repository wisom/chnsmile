class WeeklyContestModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<WeeklyContest> rows;

  WeeklyContestModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  WeeklyContestModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<WeeklyContest>();
      json['rows'].forEach((v) {
        rows.add(new WeeklyContest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeeklyContest {
  String publicUserId;
  String publicUserName;
  String publicOrgId;
  String publicOrgName;
  String publicTime;
  String updateTime;
  String cancelTime;
  String readStatus;
  String readTime;
  String noticeUserSum;
  String voteTitle;
  String voteDesc;
  String voteId;
  int voteType;
  String startTime;
  String endTime;
  int hasSubmitAns;
  String submitAnsLabel;
  String statusLabel;
  int status;

  WeeklyContest(
      {this.publicUserId,
        this.publicUserName,
        this.publicOrgId,
        this.publicOrgName,
        this.publicTime,
        this.updateTime,
        this.cancelTime,
        this.readStatus,
        this.readTime,
        this.noticeUserSum,
        this.voteTitle,
        this.voteDesc,
        this.voteId,
        this.voteType,
        this.startTime,
        this.endTime,
        this.hasSubmitAns,
        this.submitAnsLabel,
        this.statusLabel,
        this.status});

  WeeklyContest.fromJson(Map<String, dynamic> json) {
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicOrgId = json['publicOrgId'];
    publicOrgName = json['publicOrgName'];
    publicTime = json['publicTime'];
    updateTime = json['updateTime'];
    cancelTime = json['cancelTime'];
    readStatus = json['readStatus'];
    readTime = json['readTime'];
    noticeUserSum = json['noticeUserSum'];
    voteTitle = json['voteTitle'];
    voteDesc = json['voteDesc'];
    voteId = json['voteId'];
    voteType = json['voteType'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    hasSubmitAns = json['hasSubmitAns'];
    submitAnsLabel = json['submitAnsLabel'];
    statusLabel = json['statusLabel'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['publicOrgId'] = this.publicOrgId;
    data['publicOrgName'] = this.publicOrgName;
    data['publicTime'] = this.publicTime;
    data['updateTime'] = this.updateTime;
    data['cancelTime'] = this.cancelTime;
    data['readStatus'] = this.readStatus;
    data['readTime'] = this.readTime;
    data['noticeUserSum'] = this.noticeUserSum;
    data['voteTitle'] = this.voteTitle;
    data['voteDesc'] = this.voteDesc;
    data['voteId'] = this.voteId;
    data['voteType'] = this.voteType;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['hasSubmitAns'] = this.hasSubmitAns;
    data['submitAnsLabel'] = this.submitAnsLabel;
    data['statusLabel'] = this.statusLabel;
    data['status'] = this.status;
    return data;
  }
}


