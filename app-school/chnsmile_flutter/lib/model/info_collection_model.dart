class InfoCollectionModel {
    int total;
    List<InfoCollection> list;

    InfoCollectionModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<InfoCollection>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(InfoCollection.fromJson(v));
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

class InfoCollection {
  String id;///统计单主键id
  String statisticsName;///统计单名称
  String statisticsState;///统计单描述
  String startTime;
  String endTime;
  int releaseStatus;///发布状态（0：未发布，1：已发布，3：已撤回）
  String publicTime;
  String publicUserName;///发布人
  String noticeId;///通知id
  List<String> gradClass;///参与班级:""初中一年级（1）班""
  String messageStatusLabel;///统计状态:"采集中"

  InfoCollection(
      {this.id,
        this.statisticsName,
        this.statisticsState,
        this.startTime,
        this.endTime,
        this.releaseStatus,
        this.publicTime,
        this.publicUserName,
        this.noticeId,
        this.gradClass,
        this.messageStatusLabel});

  InfoCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statisticsName = json['statisticsName'];
    statisticsState = json['statisticsState'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    releaseStatus = json['releaseStatus'];
    publicTime = json['publicTime'];
    publicUserName = json['publicUserName'];
    noticeId = json['noticeId'];
    gradClass = json['gradClass'] != null ? json['gradClass'].cast<String>() : [];
    messageStatusLabel = json['messageStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statisticsName'] = this.statisticsName;
    data['statisticsState'] = this.statisticsState;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['releaseStatus'] = this.releaseStatus;
    data['publicTime'] = this.publicTime;
    data['publicUserName'] = this.publicUserName;
    data['noticeId'] = this.noticeId;
    data['gradClass'] = this.gradClass;
    data['messageStatusLabel'] = this.messageStatusLabel;
    return data;
  }

  @override
  String toString() {
    return 'InfoCollection{id: $id, statisticsName: $statisticsName, statisticsState: $statisticsState, startTime: $startTime, endTime: $endTime, releaseStatus: $releaseStatus, publicTime: $publicTime, publicUserName: $publicUserName, noticeId: $noticeId, messageStatusLabel: $messageStatusLabel}';
  }
}


