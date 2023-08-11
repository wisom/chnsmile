class Attach {
  String attachId;
  String formId;
  String attachUrl;
  String origionName;
  String attachSuffix;
  String attachSizeInfo;

  Attach(
      {this.attachId,
        this.formId,
        this.attachUrl,
        this.origionName,
        this.attachSuffix,
        this.attachSizeInfo});

  Attach.fromJson(Map<String, dynamic> json) {
    attachId = json['attachId'];
    formId = json['formId'];
    attachUrl = json['attachUrl'];
    origionName = json['origionName'];
    attachSuffix = json['attachSuffix'];
    attachSizeInfo = json['attachSizeInfo'];
  }

  Attach.fromJson2(Map<String, dynamic> json) {
    attachId = json['id'];
    formId = json['formId'];
    attachUrl = json['fileUrl'];
    origionName = json['fileOriginName'];
    attachSuffix = json['fileSuffix'];
    attachSizeInfo = json['fileSizeInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['attachId'] = this.attachId;
    data['formId'] = this.formId;
    data['attachUrl'] = this.attachUrl;
    data['origionName'] = this.origionName;
    data['attachSuffix'] = this.attachSuffix;
    data['attachSizeInfo'] = this.attachSizeInfo;
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.attachId;
    data['formId'] = this.formId;
    data['fileUrl'] = this.attachUrl;
    data['fileOriginName'] = this.origionName;
    data['fileSuffix'] = this.attachSuffix;
    data['fileSizeInfo'] = this.attachSizeInfo;
    return data;
  }

  @override
  String toString() {
    return attachUrl;
  }
}