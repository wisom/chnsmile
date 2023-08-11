class Behavior {
  String className;
  String classYear;
  int behaviorTypeGroup;
  String behaviorType;
  String behaviorContent;
  String behaviorIcon;
  String createTime;

  Behavior(
      {this.className,
        this.classYear,
        this.behaviorTypeGroup,
        this.behaviorType,
        this.behaviorContent,
        this.behaviorIcon,
        this.createTime});

  Behavior.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    classYear = json['classYear'];
    behaviorTypeGroup = json['behaviorTypeGroup'];
    behaviorType = json['behaviorType'];
    behaviorContent = json['behaviorContent'];
    behaviorIcon = json['behaviorIcon'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    data['classYear'] = this.classYear;
    data['behaviorTypeGroup'] = this.behaviorTypeGroup;
    data['behaviorType'] = this.behaviorType;
    data['behaviorContent'] = this.behaviorContent;
    data['behaviorIcon'] = this.behaviorIcon;
    data['createTime'] = this.createTime;
    return data;
  }
}

