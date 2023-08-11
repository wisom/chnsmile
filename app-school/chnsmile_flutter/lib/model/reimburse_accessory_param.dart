class ReimburseAccessoryParam {
  String formId;
  String reimbursementId;
  String fileId;
  String fileName;
  String fileDes;
  String fileType;
  String fileContentType;
  String fileSize;
  String fileUrl;
  String fileContent;

  ReimburseAccessoryParam.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    reimbursementId = json['reimbursementId'];
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
    data['formId'] = formId;
    data['reimbursementId'] = reimbursementId;
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
