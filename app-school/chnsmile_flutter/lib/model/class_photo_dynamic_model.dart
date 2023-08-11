import 'package:chnsmile_flutter/model/class_photo_dynamic_accessory.dart';

class ClassPhotoDynamicModel {
  ClassPhotoDynamic data;

  ClassPhotoDynamicModel.fromJson(Map<String, dynamic> json) {
    data = ClassPhotoDynamic.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class ClassPhotoDynamic {
  String id; //班级相册主键id
  String albumName; //相册名称
  String albumCover; //相册封面
  String publishName; //发布人
  String publishTime; //发布时间
  String albumDescribe; //相册描述
  String createTime; //创建时间
  int status; //状态： 0:未发布 1:已发布 2:删除
  int count; //相片数量
  List<ClassPhotoDynamicAccessory> classAlbumAccessoryList; //附件集合

  ClassPhotoDynamic(
      {this.id,
      this.albumName,
      this.albumCover,
      this.publishName,
      this.publishTime,
      this.albumDescribe,
      this.createTime,
      this.status,
      this.count});

  ClassPhotoDynamic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumName = json['albumName'];
    albumCover = json['albumCover'];
    publishName = json['publishName'];
    publishTime = json['publishTime'];
    albumDescribe = json['albumDescribe'];
    createTime = json['createTime'];
    status = json['status'];
    count = json['count'];
    if (json['classAlbumAccessoryList'] != null) {
      classAlbumAccessoryList =
          List<ClassPhotoDynamicAccessory>.empty(growable: true);
      json['classAlbumAccessoryList'].forEach((v) {
        classAlbumAccessoryList.add(ClassPhotoDynamicAccessory.fromJson(v));
      });
    }
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
    data['classAlbumAccessoryList'] = this.classAlbumAccessoryList;
    return data;
  }

  @override
  String toString() {
    return 'ClassPhotoDynamic{id: $id, albumName: $albumName, albumCover: $albumCover, publishName: $publishName, publishTime: $publishTime, albumDescribe: $albumDescribe, createTime: $createTime, status: $status, count: $count, classAlbumAccessoryList: $classAlbumAccessoryList}';
  }
}
