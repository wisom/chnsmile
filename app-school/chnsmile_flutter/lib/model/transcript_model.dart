import 'package:chnsmile_flutter/model/student_info.dart';

class TranscriptModel {
  StudentInfo studentInfo;
  ScoreInfo scoreInfo;

  TranscriptModel({this.studentInfo, this.scoreInfo});

  TranscriptModel.fromJson(Map<String, dynamic> json) {
    studentInfo = json['studentInfo'] != null
        ? new StudentInfo.fromJson(json['studentInfo'])
        : null;
    scoreInfo = json['scoreInfo'] != null
        ? new ScoreInfo.fromJson(json['scoreInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentInfo != null) {
      data['studentInfo'] = this.studentInfo.toJson();
    }
    if (this.scoreInfo != null) {
      data['scoreInfo'] = this.scoreInfo.toJson();
    }
    return data;
  }
}

class ScoreInfo {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Score> rows;
  List<int> rainbow;

  ScoreInfo(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows,
        this.rainbow});

  ScoreInfo.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<Score>();
      json['rows'].forEach((v) {
        rows.add(new Score.fromJson(v));
      });
    }
    rainbow = json['rainbow'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['rainbow'] = this.rainbow;
    return data;
  }
}

class Score {
  String examId;
  String examName;
  String examStartDate;
  String examEndDate;
  List<ScoreList> scoreList;

  Score(
      {this.examId,
        this.examName,
        this.examStartDate,
        this.examEndDate,
        this.scoreList});

  Score.fromJson(Map<String, dynamic> json) {
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
  int type; // type 较上一次考试 成绩情况  1 上升  0 持平  -1 下降

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
