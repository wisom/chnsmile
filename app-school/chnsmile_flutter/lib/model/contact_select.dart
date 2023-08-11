class ContactSelect {
  String name; // 名称
  String id; // 用户id,或者组织id
  String parentId; // 如果是用户id,需要传入组织id
  bool isDep;
  String avatorUrl; // url
  String teacherId; // teacherId
  String floor; // floor
  String orgName; // orgName

  ContactSelect(this.id, this.name, this.isDep, this.parentId, {this.teacherId, this.avatorUrl, this.floor, this.orgName}); // 是否是组织

  @override
  bool operator == (Object other) {
    ContactSelect o = other;
    return this.id ==  o.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return '$name - $id - $isDep - $parentId - $teacherId - $floor - $orgName';
  }

}