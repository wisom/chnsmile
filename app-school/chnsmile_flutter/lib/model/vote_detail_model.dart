
import 'package:chnsmile_flutter/model/vote.dart';

class VoteDetailModel {
  Vote vote;
  List<VoteUserOptions> voteUserOptions;
  List<VoteOptions> voteOptions;

  VoteDetailModel({this.vote, this.voteUserOptions, this.voteOptions});

  VoteDetailModel.fromJson(Map<String, dynamic> json) {
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
        this.userType});

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
  double ratio;
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
    ratio = json['ratio'];
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

