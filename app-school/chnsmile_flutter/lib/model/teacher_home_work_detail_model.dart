import 'package:chnsmile_flutter/model/attach.dart';

class TeacherHomeWorkDetailModel {
  String id;
  String formId;
  String title;
  String content;
  int type;
  String publicUserId;
  String publicUserName;
  String publicOrgId;
  String publicOrgName;
  String publicTime;
  int status;
  int userOperateType;
  int urgencyType;
  List<String> parentNoticeScope;
  List<ParentLabels> parentLabels;
  String attachIds;
  String noticeUserSum;
  String noticeUserUnReadNum;
  List<Attach> attachInfoList;
  List<StudentParentUnReadResultList> studentParentUnReadResultList;
  List<ClassInfoList> classInfoList;
  String noticeUserReadNum;
  String readRecent;
  int hasTeacherAll;
  int hasStudentAll;
  bool hasCancel;

  TeacherHomeWorkDetailModel(
      {this.id,
        this.formId,
        this.title,
        this.content,
        this.type,
        this.publicUserId,
        this.publicUserName,
        this.publicOrgId,
        this.publicOrgName,
        this.publicTime,
        this.status,
        this.userOperateType,
        this.urgencyType,
        this.parentNoticeScope,
        this.parentLabels,
        this.attachIds,
        this.noticeUserSum,
        this.noticeUserUnReadNum,
        this.attachInfoList,
        this.studentParentUnReadResultList,
        this.classInfoList,
        this.noticeUserReadNum,
        this.readRecent,
        this.hasTeacherAll,
        this.hasStudentAll,
        this.hasCancel});

  TeacherHomeWorkDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    publicUserId = json['publicUserId'];
    publicUserName = json['publicUserName'];
    publicOrgId = json['publicOrgId'];
    publicOrgName = json['publicOrgName'];
    publicTime = json['publicTime'];
    status = json['status'];
    userOperateType = json['userOperateType'];
    urgencyType = json['urgencyType'];
    parentNoticeScope = json['parentNoticeScope'].cast<String>();
    if (json['parentLabels'] != null) {
      parentLabels = new List<ParentLabels>();
      json['parentLabels'].forEach((v) {
        parentLabels.add(new ParentLabels.fromJson(v));
      });
    }
    attachIds = json['attachIds'];
    noticeUserSum = json['noticeUserSum'];
    noticeUserUnReadNum = json['noticeUserUnReadNum'];
    if (json['attachInfoList'] != null) {
      attachInfoList = new List<Attach>();
      json['attachInfoList'].forEach((v) {
        attachInfoList.add(new Attach.fromJson(v));
      });
    }
    if (json['studentParentUnReadResultList'] != null) {
      studentParentUnReadResultList = new List<StudentParentUnReadResultList>();
      json['studentParentUnReadResultList'].forEach((v) {
        studentParentUnReadResultList
            .add(new StudentParentUnReadResultList.fromJson(v));
      });
    }
    if (json['classInfoList'] != null) {
      classInfoList = new List<ClassInfoList>();
      json['classInfoList'].forEach((v) {
        classInfoList.add(new ClassInfoList.fromJson(v));
      });
    }
    noticeUserReadNum = json['noticeUserReadNum'];
    readRecent = json['readRecent'];
    hasTeacherAll = json['hasTeacherAll'];
    hasStudentAll = json['hasStudentAll'];
    hasCancel = json['hasCancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['type'] = this.type;
    data['publicUserId'] = this.publicUserId;
    data['publicUserName'] = this.publicUserName;
    data['publicOrgId'] = this.publicOrgId;
    data['publicOrgName'] = this.publicOrgName;
    data['publicTime'] = this.publicTime;
    data['status'] = this.status;
    data['userOperateType'] = this.userOperateType;
    data['urgencyType'] = this.urgencyType;
    data['parentNoticeScope'] = this.parentNoticeScope;
    if (this.parentLabels != null) {
      data['parentLabels'] = this.parentLabels.map((v) => v.toJson()).toList();
    }
    data['attachIds'] = this.attachIds;
    data['noticeUserSum'] = this.noticeUserSum;
    data['noticeUserUnReadNum'] = this.noticeUserUnReadNum;
    if (this.attachInfoList != null) {
      data['attachInfoList'] =
          this.attachInfoList.map((v) => v.toJson()).toList();
    }
    if (this.studentParentUnReadResultList != null) {
      data['studentParentUnReadResultList'] =
          this.studentParentUnReadResultList.map((v) => v.toJson()).toList();
    }
    if (this.classInfoList != null) {
      data['classInfoList'] =
          this.classInfoList.map((v) => v.toJson()).toList();
    }
    data['noticeUserReadNum'] = this.noticeUserReadNum;
    data['readRecent'] = this.readRecent;
    data['hasTeacherAll'] = this.hasTeacherAll;
    data['hasStudentAll'] = this.hasStudentAll;
    data['hasCancel'] = this.hasCancel;
    return data;
  }
}

class ParentLabels {
  String id;
  String name;
  int type;

  ParentLabels({this.id, this.name, this.type});

  ParentLabels.fromJson(Map<String, dynamic> json) {
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

class AttachInfoList {
  String attachId;
  String attachUrl;
  String origionName;
  String attachSuffix;
  String attachSizeInfo;

  AttachInfoList(
      {this.attachId,
        this.attachUrl,
        this.origionName,
        this.attachSuffix,
        this.attachSizeInfo});

  AttachInfoList.fromJson(Map<String, dynamic> json) {
    attachId = json['attachId'];
    attachUrl = json['attachUrl'];
    origionName = json['origionName'];
    attachSuffix = json['attachSuffix'];
    attachSizeInfo = json['attachSizeInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachId'] = this.attachId;
    data['attachUrl'] = this.attachUrl;
    data['origionName'] = this.origionName;
    data['attachSuffix'] = this.attachSuffix;
    data['attachSizeInfo'] = this.attachSizeInfo;
    return data;
  }
}

class StudentParentUnReadResultList {
  String studentId;
  String studentName;
  List<ParentInfoList> parentInfoList;

  StudentParentUnReadResultList(
      {this.studentId, this.studentName, this.parentInfoList});

  StudentParentUnReadResultList.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    if (json['parentInfoList'] != null) {
      parentInfoList = new List<ParentInfoList>();
      json['parentInfoList'].forEach((v) {
        parentInfoList.add(new ParentInfoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    if (this.parentInfoList != null) {
      data['parentInfoList'] =
          this.parentInfoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentInfoList {
  String userId;
  String parentId;
  String parentName;
  String relation;

  ParentInfoList({this.userId, this.parentId, this.parentName, this.relation});

  ParentInfoList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    parentId = json['parentId'];
    parentName = json['parentName'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['parentId'] = this.parentId;
    data['parentName'] = this.parentName;
    data['relation'] = this.relation;
    return data;
  }
}

class ClassInfoList {
  String classId;
  String className;
  int unReadSum;

  ClassInfoList({this.classId, this.className, this.unReadSum});

  ClassInfoList.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    className = json['className'];
    unReadSum = json['unReadSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['unReadSum'] = this.unReadSum;
    return data;
  }
}
