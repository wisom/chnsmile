class TeacherTranscriptDetail1Model {
  List<TeacherTranscriptDetail1> list;

  TeacherTranscriptDetail1Model.fromJson(List json) {
    if (json != null) {
      list = List<TeacherTranscriptDetail1>.empty(growable: true);
      json.forEach((v) {
        list.add(TeacherTranscriptDetail1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class TeacherTranscriptDetail1 {
  String courseId;
  String courseName;
  List<StudentScoreList> studentScoreList;

  TeacherTranscriptDetail1({this.courseId, this.courseName, this.studentScoreList});

  TeacherTranscriptDetail1.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseName = json['courseName'];
    if (json['studentScoreList'] != null) {
      studentScoreList = new List<StudentScoreList>();
      json['studentScoreList'].forEach((v) {
        studentScoreList.add(new StudentScoreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['courseName'] = this.courseName;
    if (this.studentScoreList != null) {
      data['studentScoreList'] =
          this.studentScoreList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentScoreList {
  Null studentId;
  String studentName;
  String studentNo;
  Null studentAvatar;
  int totalScore;
  int rating;

  StudentScoreList(
      {this.studentId,
        this.studentName,
        this.studentNo,
        this.studentAvatar,
        this.totalScore,
        this.rating});

  StudentScoreList.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentNo = json['studentNo'];
    studentAvatar = json['studentAvatar'];
    totalScore = json['totalScore'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    data['studentNo'] = this.studentNo;
    data['studentAvatar'] = this.studentAvatar;
    data['totalScore'] = this.totalScore;
    data['rating'] = this.rating;
    return data;
  }
}


