class TeacherTranscriptModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<TeacherTranscript> rows;

  TeacherTranscriptModel(
      {this.pageNo,
        this.pageSize,
        this.totalPage,
        this.totalRows,
        this.rows});

  TeacherTranscriptModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      rows = new List<TeacherTranscript>();
      json['rows'].forEach((v) {
        rows.add(new TeacherTranscript.fromJson(v));
      });
    }
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
    return data;
  }
}

class TeacherTranscript {
  String examId;
  String examName;
  String publishTime;

  TeacherTranscript({this.examId, this.examName, this.publishTime});

  TeacherTranscript.fromJson(Map<String, dynamic> json) {
    examId = json['examId'];
    examName = json['examName'];
    publishTime = json['publishTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['examId'] = this.examId;
    data['examName'] = this.examName;
    data['publishTime'] = this.publishTime;
    return data;
  }
}

