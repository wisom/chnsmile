class DocumentModel {
  int pageNo;
  int pageSize;
  int totalPage;
  int totalRows;
  List<Document> list;

  DocumentModel(
      {this.pageNo, this.pageSize, this.totalPage, this.totalRows, this.list});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalRows = json['totalRows'];
    if (json['rows'] != null) {
      list = new List<Document>();
      json['rows'].forEach((v) {
        list.add(new Document.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalRows'] = this.totalRows;
    if (this.list != null) {
      data['rows'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Document {
  String id;
  String formId;
  String docId;
  String title;
  String content;
  String orgName;
  String dDate;
  String remark;
  int reviewStatus; //（1待批/待读、2已批/已读、3拒批）
  int status;
  String cname;
  String ddate;

  Document(
      {this.id,
      this.formId,
      this.docId,
      this.title,
      this.content,
      this.orgName = "",
      this.dDate,
      this.remark,
      this.status,
      this.reviewStatus,
      this.cname,
      this.ddate});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    docId = json['docId'];
    title = json['title'];
    content = json['content'];
    orgName = json['orgName'];
    dDate = json['dDate'];
    remark = json['remark'];
    status = json['status'];
    reviewStatus = json['reviewStatus'];
    cname = json['cname'];
    ddate = json['ddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['docId'] = this.docId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['orgName'] = this.orgName;
    data['dDate'] = this.dDate;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['reviewStatus'] = this.reviewStatus;
    data['cname'] = this.cname;
    data['ddate'] = this.ddate;
    return data;
  }
}
