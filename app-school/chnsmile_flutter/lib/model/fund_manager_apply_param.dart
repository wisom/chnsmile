class FundManagerApplyParam {
  String schoolId;
  String formId;
  String fundId;
  String fileId;
  String fileName;
  String fileDes;
  String fileType;
  String fileContentType;
  String fileSize;
  String fileUrl;
  String fileContent;

  FundManagerApplyParam.fromJson(Map<String, dynamic> json) {
    schoolId = json['schoolId'];
    formId = json['formId'];
    fundId = json['fundId'];
    fileId = json['fileId'];
    fileName = json['fileName'];
    fileDes = json['fileDes'];
    fileType = json['fileType'];
    fileContentType = json['fileContentType'];
    fileSize = json['fileSize'];
    fileUrl = json['fileUrl'];
    fileContent = json['fileContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schoolId'] = schoolId;
    data['formId'] = formId;
    data['fundId'] = fundId;
    data['fileId'] = fileId;
    data['fileName'] = fileName;
    data['fileDes'] = fileDes;
    data['fileType'] = fileType;
    data['fileContentType'] = fileContentType;
    data['fileSize'] = fileSize;
    data['fileUrl'] = fileUrl;
    data['fileContent'] = fileContent;
    return data;
  }
}
