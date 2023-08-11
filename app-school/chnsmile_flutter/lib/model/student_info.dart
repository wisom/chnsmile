class StudentInfo {
  String studentName;
  String gender;
  String avatarImg;
  String classId;
  String className;
  int classGrade;
  String gradeName;
  String headTeacherId;
  String headTeacherName;
  String birth;
  String email;
  String schoolName;
  String register;

  StudentInfo(
      {this.studentName,
        this.gender,
        this.avatarImg,
        this.classId,
        this.className,
        this.classGrade,
        this.gradeName,
        this.headTeacherId,
        this.headTeacherName,
        this.birth,
        this.email,
        this.schoolName,
        this.register});

  StudentInfo.fromJson(Map<String, dynamic> json) {
    studentName = json['studentName'];
    gender = json['gender'];
    avatarImg = json['avatarImg'];
    classId = json['classId'];
    className = json['className'];
    classGrade = json['classGrade'];
    gradeName = json['gradeName'];
    headTeacherId = json['headTeacherId'];
    headTeacherName = json['headTeacherName'];
    birth = json['birth'];
    email = json['email'];
    schoolName = json['schoolName'];
    register = json['register'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentName'] = this.studentName;
    data['gender'] = this.gender;
    data['avatarImg'] = this.avatarImg;
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classGrade'] = this.classGrade;
    data['gradeName'] = this.gradeName;
    data['headTeacherId'] = this.headTeacherId;
    data['headTeacherName'] = this.headTeacherName;
    data['birth'] = this.birth;
    data['email'] = this.email;
    data['schoolName'] = this.schoolName;
    data['register'] = this.register;
    return data;
  }
}
