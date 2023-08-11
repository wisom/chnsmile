class WeeklyContestDetailModel {
  Vote vote;
  List<VoteUserOptions> voteUserOptions;
  List<VoteOptions> voteOptions;
  LastAwardInfo lastAwardInfo;

  WeeklyContestDetailModel(
      {this.vote, this.voteUserOptions, this.voteOptions, this.lastAwardInfo});

  WeeklyContestDetailModel.fromJson(Map<String, dynamic> json) {
    vote = json['vote'] != null ? new Vote.fromJson(json['vote']) : null;
    if (json['voteUserOptions'] != null) {
      voteUserOptions = new List<VoteUserOptions>();
      json['voteUserOptions'].forEach((v) {
        voteUserOptions.add(new VoteUserOptions.fromJson(v));
      });
    }
    if (json['voteOptions'] != null) {
      voteOptions = new List<VoteOptions>();
      json['voteOptions'].forEach((v) {
        voteOptions.add(new VoteOptions.fromJson(v));
      });
    }
    lastAwardInfo = json['lastAwardInfo'] != null
        ? new LastAwardInfo.fromJson(json['lastAwardInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vote != null) {
      data['vote'] = this.vote.toJson();
    }
    if (this.voteUserOptions != null) {
      data['voteUserOptions'] =
          this.voteUserOptions.map((v) => v.toJson()).toList();
    }
    if (this.voteOptions != null) {
      data['voteOptions'] = this.voteOptions.map((v) => v.toJson()).toList();
    }
    if (this.lastAwardInfo != null) {
      data['lastAwardInfo'] = this.lastAwardInfo.toJson();
    }
    return data;
  }
}

class Vote {
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
  String formId;
  String lastId;
  String publicTime;
  String publicUserId;
  String publicUserName;
  String author;
  String voteStatus;
  String teacherName;
  String noticeUserSum;
  int hasSubmitAns;
  String submitAnsLabel;
  String voteStatusLabel;

  Vote(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.voteTitle,
        this.voteDesc,
        this.schoolId,
        this.teacherId,
        this.voteType,
        this.startTime,
        this.endTime,
        this.voteScope,
        this.noticeId,
        this.status,
        this.formId,
        this.lastId,
        this.publicTime,
        this.publicUserId,
        this.publicUserName,
        this.author,
        this.voteStatus,
        this.teacherName,
        this.noticeUserSum,
        this.hasSubmitAns,
        this.submitAnsLabel,
        this.voteStatusLabel});

  Vote.fromJson(Map<String, dynamic> json) {
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
    formId = json['formId'];
    lastId = json['lastId'];
    publicTime = json['publicTime'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    author = json['author'];
    voteStatus = json['voteStatus'];
    teacherName = json['teacherName'];
    noticeUserSum = json['noticeUserSum'];
    hasSubmitAns = json['hasSubmitAns'];
    submitAnsLabel = json['submitAnsLabel'];
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
    data['formId'] = this.formId;
    data['lastId'] = this.lastId;
    data['publicTime'] = this.publicTime;
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['author'] = this.author;
    data['voteStatus'] = this.voteStatus;
    data['teacherName'] = this.teacherName;
    data['noticeUserSum'] = this.noticeUserSum;
    data['hasSubmitAns'] = this.hasSubmitAns;
    data['submitAnsLabel'] = this.submitAnsLabel;
    data['voteStatusLabel'] = this.voteStatusLabel;
    return data;
  }
}

class VoteUserOptions {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String userId;
  String voteId;
  String voteOptionId;
  String voteLabel;
  String voteTime;
  String voteIp;
  String schoolId;
  int userType;
  String userName;

  VoteUserOptions(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.userId,
        this.voteId,
        this.voteOptionId,
        this.voteLabel,
        this.voteTime,
        this.voteIp,
        this.schoolId,
        this.userType,
        this.userName});

  VoteUserOptions.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    userId = json['userId'];
    voteId = json['voteId'];
    voteOptionId = json['voteOptionId'];
    voteLabel = json['voteLabel'];
    voteTime = json['voteTime'];
    voteIp = json['voteIp'];
    schoolId = json['schoolId'];
    userType = json['userType'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['voteId'] = this.voteId;
    data['voteOptionId'] = this.voteOptionId;
    data['voteLabel'] = this.voteLabel;
    data['voteTime'] = this.voteTime;
    data['voteIp'] = this.voteIp;
    data['schoolId'] = this.schoolId;
    data['userType'] = this.userType;
    data['userName'] = this.userName;
    return data;
  }
}

class VoteOptions {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String voteId;
  String voteLabel;
  String voteName;
  String schoolId;
  int hasAns;
  OptionSumDetailResult optionSumDetailResult;

  VoteOptions(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.voteId,
        this.voteLabel,
        this.voteName,
        this.schoolId,
        this.hasAns,
        this.optionSumDetailResult});

  VoteOptions.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    voteId = json['voteId'];
    voteLabel = json['voteLabel'];
    voteName = json['voteName'];
    schoolId = json['schoolId'];
    hasAns = json['hasAns'];
    optionSumDetailResult = json['optionSumDetailResult'] != null
        ? new OptionSumDetailResult.fromJson(json['optionSumDetailResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['voteId'] = this.voteId;
    data['voteLabel'] = this.voteLabel;
    data['voteName'] = this.voteName;
    data['schoolId'] = this.schoolId;
    data['hasAns'] = this.hasAns;
    if (this.optionSumDetailResult != null) {
      data['optionSumDetailResult'] = this.optionSumDetailResult.toJson();
    }
    return data;
  }
}

class OptionSumDetailResult {
  String voteOptionId;
  String voteCount;
  String userSum;
  String ratio;
  String ratioLabel;

  OptionSumDetailResult(
      {this.voteOptionId,
        this.voteCount,
        this.userSum,
        this.ratio,
        this.ratioLabel});

  OptionSumDetailResult.fromJson(Map<String, dynamic> json) {
    voteOptionId = json['voteOptionId'];
    voteCount = json['voteCount'];
    userSum = json['userSum'];
    ratio = json['ratio'].toString();
    ratioLabel = json['ratioLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voteOptionId'] = this.voteOptionId;
    data['voteCount'] = this.voteCount;
    data['userSum'] = this.userSum;
    data['ratio'] = this.ratio;
    data['ratioLabel'] = this.ratioLabel;
    return data;
  }
}

class LastAwardInfo {
  String voteId;
  String voteTitle;
  List<String> ansOptions;

  LastAwardInfo(
      {this.voteId, this.voteTitle, this.ansOptions});

  LastAwardInfo.fromJson(Map<String, dynamic> json) {
    voteId = json['voteId'];
    voteTitle = json['voteTitle'];
    ansOptions = json['ansOptions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voteId'] = this.voteId;
    data['voteTitle'] = this.voteTitle;
    data['ansOptions'] = this.ansOptions;
    return data;
  }
}
