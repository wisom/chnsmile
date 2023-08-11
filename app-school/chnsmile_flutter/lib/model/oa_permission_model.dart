class OAPermissionModel {
  List<String> list;

  OAPermissionModel.fromJson(List json) {
    if (json != null) {
      list = List<String>.empty(growable: true);
      json.forEach((v) {
        list.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list.map((v) => v).toList();
    return data;
  }
}
