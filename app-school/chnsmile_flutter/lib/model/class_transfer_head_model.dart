class ClassHeadModel {
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

  ClassHeadModel(
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

  ClassHeadModel.fromJson(Map<String, dynamic> json) {
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
