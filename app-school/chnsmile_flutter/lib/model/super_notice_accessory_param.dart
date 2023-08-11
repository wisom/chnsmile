import 'attach.dart';

class SuperNoticeAccessoryParam {
  String id;
  String infoId;
  String fileOriginName;
  String fileSuffix;
  String fileUrl;

  SuperNoticeAccessoryParam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    infoId = json['infoId'];
    fileOriginName = json['fileOriginName'];
    fileSuffix = json['fileSuffix'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['infoId'] = infoId;
    data['fileOriginName'] = fileOriginName;
    data['fileSuffix'] = fileSuffix;
    data['fileUrl'] = fileUrl;
    return data;
  }

}
