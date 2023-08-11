class ClockInTimesModel {
  String content;//每天、周一、周二、周三
  bool isSelect;//是否选中

  ClockInTimesModel({
    this.content,
    this.isSelect,
  });

  ClockInTimesModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['isSelect'] = this.isSelect;
    return data;
  }

  @override
  String toString() {
    return 'ClockInTimesModel{content: $content, isSelect: $isSelect}';
  }
}
