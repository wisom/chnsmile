import 'package:chnsmile_flutter/model/attach.dart';

class UploadAttach {
  String createTime;
  String createUser;
  String id;
  int fileLocation;
  String fileBucket;
  String fileOriginName;
  String fileSuffix;
  String fileSizeKb;
  String fileSizeInfo;
  String fileObjectName;
  String fileUrl;

  UploadAttach({this.createTime,
    this.createUser,
    this.id,
    this.fileLocation,
    this.fileBucket,
    this.fileOriginName,
    this.fileSuffix,
    this.fileSizeKb,
    this.fileSizeInfo,
    this.fileObjectName,
    this.fileUrl});

  UploadAttach.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    createUser = json['createUser'];
    id = json['id'];
    fileLocation = json['fileLocation'];
    fileBucket = json['fileBucket'];
    fileOriginName = json['fileOriginName'];
    fileSuffix = json['fileSuffix'];
    fileSizeKb = json['fileSizeKb'];
    fileSizeInfo = json['fileSizeInfo'];
    fileObjectName = json['fileObjectName'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['id'] = this.id;
    data['fileLocation'] = this.fileLocation;
    data['fileBucket'] = this.fileBucket;
    data['fileOriginName'] = this.fileOriginName;
    data['fileSuffix'] = this.fileSuffix;
    data['fileSizeKb'] = this.fileSizeKb;
    data['fileSizeInfo'] = this.fileSizeInfo;
    data['fileObjectName'] = this.fileObjectName;
    data['fileUrl'] = this.fileUrl;
    return data;
  }

  Attach toAttach(UploadAttach oldAttach) {
    return Attach(
        attachId: oldAttach.id ?? "",
        attachUrl: oldAttach.fileUrl ?? "",
        origionName: oldAttach.fileOriginName ?? "",
        attachSuffix: oldAttach.fileSuffix ?? "",
        attachSizeInfo: oldAttach.fileSizeInfo ?? ""
    );
  }

  @override
  String toString() {
    return id;
  }
}
