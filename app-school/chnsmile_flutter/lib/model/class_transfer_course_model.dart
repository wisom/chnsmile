class ClassTransferCourseModel {
  List<ClassInfoList> classInfoList;
  List<CourseInfoList> courseInfoList;
  List<CourseNumberList> courseNumberList;

  ClassTransferCourseModel(
      {this.classInfoList, this.courseInfoList, this.courseNumberList});

  ClassTransferCourseModel.fromJson(Map<String, dynamic> json) {
    if (json['classInfoList'] != null) {
      classInfoList = new List<ClassInfoList>();
      json['classInfoList'].forEach((v) {
        classInfoList.add(new ClassInfoList.fromJson(v));
      });
    }
    if (json['courseInfoList'] != null) {
      courseInfoList = new List<CourseInfoList>();
      json['courseInfoList'].forEach((v) {
        courseInfoList.add(new CourseInfoList.fromJson(v));
      });
    }
    if (json['courseNumberList'] != null) {
      courseNumberList = new List<CourseNumberList>();
      json['courseNumberList'].forEach((v) {
        courseNumberList.add(new CourseNumberList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classInfoList != null) {
      data['classInfoList'] =
          this.classInfoList.map((v) => v.toJson()).toList();
    }
    if (this.courseInfoList != null) {
      data['courseInfoList'] =
          this.courseInfoList.map((v) => v.toJson()).toList();
    }
    if (this.courseNumberList != null) {
      data['courseNumberList'] =
          this.courseNumberList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassInfoList {
  String classId;
  String clzz;
  String classYear;
  String classGradeName;
  ClassHead classHead;

  ClassInfoList(
      {this.classId,
        this.clzz,
        this.classYear,
        this.classGradeName,
        this.classHead});

  ClassInfoList.fromJson(Map<String, dynamic> json) {
    classId = json['classId'];
    clzz = json['clzz'];
    classYear = json['classYear'];
    classGradeName = json['classGradeName'];
    classHead = json['classHead'] != null
        ? new ClassHead.fromJson(json['classHead'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['clzz'] = this.clzz;
    data['classYear'] = this.classYear;
    data['classGradeName'] = this.classGradeName;
    if (this.classHead != null) {
      data['classHead'] = this.classHead.toJson();
    }
    return data;
  }
}

class ClassHead {
  String createTime;
  String createUser;
  String updateTime;
  String updateUser;
  String id;
  String account;
  String userId;
  String schoolId;
  String userName;
  String realName;
  String mobile;
  String avatarImg;
  int sex;
  String jobNo;
  String birth;
  String birthPlace;
  String idCard;
  String beginTime;
  String email;
  String address;
  String postCode;
  String marryState;
  String education;
  String subject;
  String officeTel;
  String homePhone;
  String officePlace;
  int status;
  String historyEmp;
  int adminType;
  String orgId;
  String orgName;
  int hasDocDispatch;
  String extOrgPos;
  String positions;

  ClassHead(
      {this.createTime,
        this.createUser,
        this.updateTime,
        this.updateUser,
        this.id,
        this.account,
        this.userId,
        this.schoolId,
        this.userName,
        this.realName,
        this.mobile,
        this.avatarImg,
        this.sex,
        this.jobNo,
        this.birth,
        this.birthPlace,
        this.idCard,
        this.beginTime,
        this.email,
        this.address,
        this.postCode,
        this.marryState,
        this.education,
        this.subject,
        this.officeTel,
        this.homePhone,
        this.officePlace,
        this.status,
        this.historyEmp,
        this.adminType,
        this.orgId,
        this.orgName,
        this.hasDocDispatch,
        this.extOrgPos,
        this.positions});

  ClassHead.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    id = json['id'];
    account = json['account'];
    userId = json['userId'];
    schoolId = json['schoolId'];
    userName = json['userName'];
    realName = json['realName'];
    mobile = json['mobile'];
    avatarImg = json['avatarImg'];
    sex = json['sex'];
    jobNo = json['jobNo'];
    birth = json['birth'];
    birthPlace = json['birthPlace'];
    idCard = json['idCard'];
    beginTime = json['beginTime'];
    email = json['email'];
    address = json['address'];
    postCode = json['postCode'];
    marryState = json['marryState'];
    education = json['education'];
    subject = json['subject'];
    officeTel = json['officeTel'];
    homePhone = json['homePhone'];
    officePlace = json['officePlace'];
    status = json['status'];
    historyEmp = json['historyEmp'];
    adminType = json['adminType'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    hasDocDispatch = json['hasDocDispatch'];
    extOrgPos = json['extOrgPos'];
    positions = json['positions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['id'] = this.id;
    data['account'] = this.account;
    data['userId'] = this.userId;
    data['schoolId'] = this.schoolId;
    data['userName'] = this.userName;
    data['realName'] = this.realName;
    data['mobile'] = this.mobile;
    data['avatarImg'] = this.avatarImg;
    data['sex'] = this.sex;
    data['jobNo'] = this.jobNo;
    data['birth'] = this.birth;
    data['birthPlace'] = this.birthPlace;
    data['idCard'] = this.idCard;
    data['beginTime'] = this.beginTime;
    data['email'] = this.email;
    data['address'] = this.address;
    data['postCode'] = this.postCode;
    data['marryState'] = this.marryState;
    data['education'] = this.education;
    data['subject'] = this.subject;
    data['officeTel'] = this.officeTel;
    data['homePhone'] = this.homePhone;
    data['officePlace'] = this.officePlace;
    data['status'] = this.status;
    data['historyEmp'] = this.historyEmp;
    data['adminType'] = this.adminType;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['hasDocDispatch'] = this.hasDocDispatch;
    data['extOrgPos'] = this.extOrgPos;
    data['positions'] = this.positions;
    return data;
  }
}

class CourseInfoList {
  String courseId;
  String course;
  String code;
  String ename;

  CourseInfoList({this.courseId, this.course, this.code, this.ename});

  CourseInfoList.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    course = json['course'];
    code = json['code'];
    ename = json['ename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['course'] = this.course;
    data['code'] = this.code;
    data['ename'] = this.ename;
    return data;
  }
}

class CourseNumberList {
  String code;
  String value;

  CourseNumberList({this.code, this.value});

  CourseNumberList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['value'] = this.value;
    return data;
  }
}
