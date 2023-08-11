class VoteSchoolDetailModel {
  String id;
  String voteTitle;
  String voteDesc;
  int voteType;
  String startTime;
  String endTime;
  int voteStatus;
  int hasTeacherAll;
  int hasStudentAll;
  List<String> teacherVoteScope;
  List<String> parentVoteScope;
  List<VoteOptions> voteOptions;
  List<ContactLabels> teacherLabels;
  List<ContactLabels> parentLabels;
  List<String> names;

  VoteSchoolDetailModel(
      {this.id,
        this.voteTitle,
        this.voteDesc,
        this.voteType,
        this.startTime,
        this.endTime,
        this.voteStatus,
        this.teacherVoteScope,
        this.parentVoteScope,
        this.voteOptions,
        this.hasTeacherAll,
        this.hasStudentAll,
        this.teacherLabels,
        this.parentLabels,
        this.names});

  VoteSchoolDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voteTitle = json['voteTitle'];
    voteDesc = json['voteDesc'];
    voteType = json['voteType'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    hasTeacherAll = json['hasTeacherAll'];
    hasStudentAll = json['hasStudentAll'];
    voteStatus = json['voteStatus'];
    teacherVoteScope = json['teacherVoteScope'].cast<String>();
    parentVoteScope = json['parentVoteScope'].cast<String>();
    if (json['voteOptions'] != null) {
      voteOptions = new List<VoteOptions>();
      json['voteOptions'].forEach((v) {
        voteOptions.add(new VoteOptions.fromJson(v));
      });
    }
    if (json['teacherLabels'] != null) {
      teacherLabels = new List<ContactLabels>();
      json['teacherLabels'].forEach((v) {
        teacherLabels.add(new ContactLabels.fromJson(v));
      });
    }
    if (json['parentLabels'] != null) {
      parentLabels = new List<ContactLabels>();
      json['parentLabels'].forEach((v) {
        parentLabels.add(new ContactLabels.fromJson(v));
      });
    }
    names = json['names'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voteTitle'] = this.voteTitle;
    data['voteDesc'] = this.voteDesc;
    data['voteType'] = this.voteType;
    data['startTime'] = this.startTime;
    data['hasTeacherAll'] = this.hasTeacherAll;
    data['hasStudentAll'] = this.hasStudentAll;
    data['endTime'] = this.endTime;
    data['voteStatus'] = this.voteStatus;
    data['teacherVoteScope'] = this.teacherVoteScope;
    data['parentVoteScope'] = this.parentVoteScope;
    if (this.voteOptions != null) {
      data['voteOptions'] = this.voteOptions.map((v) => v.toJson()).toList();
    }
    if (this.teacherLabels != null) {
      data['teacherLabels'] =
          this.teacherLabels.map((v) => v.toJson()).toList();
    }
    if (this.parentLabels != null) {
      data['parentLabels'] = this.parentLabels.map((v) => v.toJson()).toList();
    }
    data['names'] = this.names;
    return data;
  }
}

class VoteOptions {
  String id;
  String voteName;
  String voteId;

  VoteOptions({this.id, this.voteName, this.voteId});

  VoteOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voteName = json['voteName'];
    voteId = json['voteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voteName'] = this.voteName;
    data['voteId'] = this.voteId;
    return data;
  }
}

class ContactLabels {
  String id;
  String name;
  int type;

  ContactLabels({this.id, this.name, this.type});

  ContactLabels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

