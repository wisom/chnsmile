class ClassPhotoModel {
  int total;
  List<ClassPhoto> list;

  ClassPhotoModel.fromJson(Map<String, dynamic> json) {
    total = json['totalRows'];
    if (json['rows'] != null) {
      list = List<ClassPhoto>.empty(growable: true);
      json['rows'].forEach((v) {
        list.add(ClassPhoto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ClassPhoto {
  String id;//班级相册主键id
  String albumName;//相册名称
  String albumCover;//相册封面
  String publishName;//发布人
  String publishTime;//发布时间
  String albumDescribe;//相册描述
  String createTime;//创建时间
  int status;//状态： 0:未发布 1:已发布 2:删除
  int count;//相片数量

  ClassPhoto({
    this.id,
    this.albumName,
    this.albumCover,
    this.publishName,
    this.publishTime,
    this.albumDescribe,
    this.createTime,
    this.status,
    this.count
  });

  ClassPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumName = json['albumName'];
    albumCover = json['albumCover'];
    publishName = json['publishName'];
    publishTime = json['publishTime'];
    albumDescribe = json['albumDescribe'];
    createTime = json['createTime'];
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['albumName'] = this.albumName;
    data['albumCover'] = this.albumCover;
    data['publishName'] = this.publishName;
    data['publishTime'] = this.publishTime;
    data['albumDescribe'] = this.albumDescribe;
    data['createTime'] = this.createTime;
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}


