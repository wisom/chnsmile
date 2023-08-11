class FamilyInfo {
  String name;
  String avatarImg;
  String phone;
  String remark;
  String childRelation;
  String email;
  String userId;
  String register;
  String idCard;

  FamilyInfo(
      {this.name,
        this.avatarImg,
        this.phone,
        this.remark,
        this.childRelation,
        this.email,
        this.userId,
        this.idCard,
        this.register});

  FamilyInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatarImg = json['avatarImg'];
    phone = json['phone'];
    remark = json['remark'];
    childRelation = json['childRelation'];
    email = json['email'];
    userId = json['userId'];
    idCard = json['idCard'];
    register = json['register'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatarImg'] = this.avatarImg;
    data['phone'] = this.phone;
    data['remark'] = this.remark;
    data['childRelation'] = this.childRelation;
    data['email'] = this.email;
    data['userId'] = this.userId;
    data['idCard'] = this.idCard;
    data['register'] = this.register;
    return data;
  }
}