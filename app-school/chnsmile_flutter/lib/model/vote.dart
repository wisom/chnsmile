class Vote {
  String publicUserId;
  String publicUserName;
  String publicOrgId;
  String publicOrgName;
  String publicTime;
  String updateTime;
  String cancelTime;
  int readStatus;
  String readTime;
  String noticeUserSum;
  String voteTitle;
  String voteDesc;
  String voteId;
  int voteType;
  String startTime;
  String endTime;
  String typeBizId;
  int hasSumbitAns;
  int voteStatus;
  String submitAnsLabel;
  String voteStatusLabel;

  Vote(
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
        this.typeBizId,
        this.hasSumbitAns,
        this.voteStatus,
        this.submitAnsLabel,
        this.voteStatusLabel});

  Vote.fromJson(Map<String, dynamic> json) {
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
    typeBizId = json['typeBizId'];
    hasSumbitAns = json['hasSumbitAns'];
    voteStatus = json['voteStatus'];
    submitAnsLabel = json['submitAnsLabel'];
    voteStatusLabel = json['voteStatusLabel'];
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
    data['typeBizId'] = this.typeBizId;
    data['hasSumbitAns'] = this.hasSumbitAns;
    data['voteStatus'] = this.voteStatus;
    data['submitAnsLabel'] = this.submitAnsLabel;
    data['voteStatusLabel'] = this.voteStatusLabel;
    return data;
  }
}

