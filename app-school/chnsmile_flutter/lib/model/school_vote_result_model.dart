class SchoolVoteResultModel {
  Vote vote;
  List<VoteOptions> voteOptions;

  SchoolVoteResultModel({this.vote, this.voteOptions});

  SchoolVoteResultModel.fromJson(Map<String, dynamic> json) {
    vote = json['vote'] != null ? new Vote.fromJson(json['vote']) : null;
    if (json['voteOptions'] != null) {
      voteOptions = new List<VoteOptions>();
      json['voteOptions'].forEach((v) {
        voteOptions.add(new VoteOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vote != null) {
      data['vote'] = this.vote.toJson();
    }
    if (this.voteOptions != null) {
      data['voteOptions'] = this.voteOptions.map((v) => v.toJson()).toList();
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
  String noticeUserSum;
  int voteType;
  String startTime;
  String endTime;
  String noticeId;
  int status;
  String publicTime;
  String teacherName;
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
        this.noticeUserSum,
        this.noticeId,
        this.status,
        this.publicTime,
        this.teacherName,
        this.voteStatusLabel});

  Vote.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    noticeUserSum = json['noticeUserSum'];
    id = json['id'];
    voteTitle = json['voteTitle'];
    voteDesc = json['voteDesc'];
    schoolId = json['schoolId'];
    teacherId = json['teacherId'];
    voteType = json['voteType'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    noticeId = json['noticeId'];
    status = json['status'];
    publicTime = json['publicTime'];
    teacherName = json['teacherName'];
    voteStatusLabel = json['voteStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['noticeUserSum'] = this.noticeUserSum;
    data['id'] = this.id;
    data['voteTitle'] = this.voteTitle;
    data['voteDesc'] = this.voteDesc;
    data['schoolId'] = this.schoolId;
    data['teacherId'] = this.teacherId;
    data['voteType'] = this.voteType;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['noticeId'] = this.noticeId;
    data['status'] = this.status;
    data['publicTime'] = this.publicTime;
    data['teacherName'] = this.teacherName;
    data['voteStatusLabel'] = this.voteStatusLabel;
    return data;
  }
}

class VoteOptions {
  String createTime;
  String createUser;
  String id;
  String voteId;
  String voteLabel;
  String voteName;
  String schoolId;
  OptionSumDetailResult optionSumDetailResult;

  VoteOptions(
      {this.createTime,
        this.createUser,
        this.id,
        this.voteId,
        this.voteLabel,
        this.voteName,
        this.schoolId,
        this.optionSumDetailResult});

  VoteOptions.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    id = json['id'];
    voteId = json['voteId'];
    voteLabel = json['voteLabel'];
    voteName = json['voteName'];
    schoolId = json['schoolId'];
    optionSumDetailResult = json['optionSumDetailResult'] != null
        ? new OptionSumDetailResult.fromJson(json['optionSumDetailResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['id'] = this.id;
    data['voteId'] = this.voteId;
    data['voteLabel'] = this.voteLabel;
    data['voteName'] = this.voteName;
    data['schoolId'] = this.schoolId;
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


