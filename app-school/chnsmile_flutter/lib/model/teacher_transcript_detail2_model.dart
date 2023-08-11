class TeacherTranscriptDetail2Model {
  String examId;
  String examName;
  String examStartDate;
  String examEndDate;
  List<ScoreList> scoreList;

  TeacherTranscriptDetail2Model(
      {this.examId,
        this.examName,
        this.examStartDate,
        this.examEndDate,
        this.scoreList});

  TeacherTranscriptDetail2Model.fromJson(Map<String, dynamic> json) {
    examId = json['examId'];
    examName = json['examName'];
    examStartDate = json['examStartDate'];
    examEndDate = json['examEndDate'];
    if (json['scoreList'] != null) {
      scoreList = new List<ScoreList>();
      json['scoreList'].forEach((v) {
        scoreList.add(new ScoreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['examId'] = this.examId;
    data['examName'] = this.examName;
    data['examStartDate'] = this.examStartDate;
    data['examEndDate'] = this.examEndDate;
    if (this.scoreList != null) {
      data['scoreList'] = this.scoreList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScoreList {
  String examId;
  String classId;
  String courseId;
  String courseName;
  int courseScore;
  int type;

  ScoreList(
      {this.examId,
        this.classId,
        this.courseId,
        this.courseName,
        this.courseScore,
        this.type});

  ScoreList.fromJson(Map<String, dynamic> json) {
    examId = json['examId'];
    classId = json['classId'];
    courseId = json['courseId'];
    courseName = json['courseName'];
    courseScore = json['courseScore'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['examId'] = this.examId;
    data['classId'] = this.classId;
    data['courseId'] = this.courseId;
    data['courseName'] = this.courseName;
    data['courseScore'] = this.courseScore;
    data['type'] = this.type;
    return data;
  }
}

