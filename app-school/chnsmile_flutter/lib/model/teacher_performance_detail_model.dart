class TeacherPerformanceDetailModel {
  List<Comments> comments;
  List<Comments> attend;

  TeacherPerformanceDetailModel({this.comments, this.attend});

  TeacherPerformanceDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['attend'] != null) {
      attend = new List<Comments>();
      json['attend'].forEach((v) {
        attend.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.attend != null) {
      data['attend'] = this.attend.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int behaviorTypeGroup;
  String behaviorType;
  String behaviorContent;
  int count;

  Comments(
      {this.behaviorTypeGroup,
        this.behaviorType,
        this.behaviorContent,
        this.count});

  Comments.fromJson(Map<String, dynamic> json) {
    behaviorTypeGroup = json['behaviorTypeGroup'];
    behaviorType = json['behaviorType'];
    behaviorContent = json['behaviorContent'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['behaviorTypeGroup'] = this.behaviorTypeGroup;
    data['behaviorType'] = this.behaviorType;
    data['behaviorContent'] = this.behaviorContent;
    data['count'] = this.count;
    return data;
  }
}
