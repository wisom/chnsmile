class ClassPhotoDynamicAccessory {
  String albumId;
  String fileId;
  String fileName;
  String fileDes;
  String fileType;
  String fileContentType;
  String fileSize;
  String fileUrl;
  String fileContent;

  ClassPhotoDynamicAccessory.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'];
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
    data['albumId'] = albumId;
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

  @override
  String toString() {
    return 'ClassPhotoDynamicAccessory{albumId: $albumId, fileId: $fileId, fileName: $fileName, fileDes: $fileDes, fileType: $fileType, fileContentType: $fileContentType, fileSize: $fileSize, fileUrl: $fileUrl, fileContent: $fileContent}';
  }
}
