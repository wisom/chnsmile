class OAMarkModel {
  List<Mark> list;

  OAMarkModel.fromJson(List json) {
    if (json != null) {
      list = List<Mark>.empty(growable: true);
      json.forEach((v) {
        list.add(Mark.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v).toList();
    return data;
  }
}

class Mark {
  String module;
  String moduleName;
  int count;

  Mark(
      {this.module,
        this.moduleName,
        this.count});

  Mark.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    moduleName = json['moduleName'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['moduleName'] = this.moduleName;
    data['count'] = this.count;
    return data;
  }
}
