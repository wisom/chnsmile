

class InfoCollectionDetailModel {
  String id;
  String statisticsName;
  String statisticsState;
  String startTime;
  String endTime;

  List<MessageQuestionResultList> messageQuestionResultList;

  InfoCollectionDetailModel({
    this.messageQuestionResultList,
    this.id,
    this.statisticsName,
    this.statisticsState,
    this.startTime,
    this.endTime,
  });

  InfoCollectionDetailModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("id")) {
      id = json['id'];
    }
    if (json.containsKey("statisticsName")) {
      statisticsName = json['statisticsName'];
    }
    if (json.containsKey("statisticsState")) {
      statisticsState = json['statisticsState'];
    }
    if (json.containsKey("startTime")) {
      startTime = json['startTime'];
    }
    if (json.containsKey("endTime")) {
      endTime = json['endTime'];
    }
    if (json['messageQuestionResultList'] != null) {
      messageQuestionResultList = [];
      json['messageQuestionResultList'].forEach((v) {
        messageQuestionResultList
            .add(MessageQuestionResultList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statisticsName'] = this.statisticsName;
    data['statisticsState'] = this.statisticsState;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    if (this.messageQuestionResultList != null) {
      data['messageQuestionResultList'] =
          this.messageQuestionResultList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'InfoCollectionDetailModel{id: $id, statisticsName: $statisticsName, statisticsState: $statisticsState, startTime: $startTime, endTime: $endTime, messageQuestionResultList: $messageQuestionResultList}';
  }
}

class MessageQuestionResultList {
  String questionId;
  int questionType;//问题类型（1 单选 2多选 3填空
  bool requiredFlag;//问题选项（0：必选， 1：非必选）
  int questionSort;//问题排序
  String questionName;//问题主题
  List<MessageOptionInfo> messageOptionInfoParams;
  List<String> answerInfos;//该问题填写的内容

  MessageQuestionResultList({
    this.questionId,
    this.questionType,
    this.requiredFlag,
    this.questionName,
    this.answerInfos,
  });

  MessageQuestionResultList.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    questionType = json['questionType'];
    requiredFlag = json['requiredFlag'];
    questionName = json['questionName'];
    if (json['messageOptionInfoParams'] != null) {
      messageOptionInfoParams = [];
      json['messageOptionInfoParams'].forEach((v) {
        messageOptionInfoParams.add(MessageOptionInfo.fromJson(v));
      });
    }
    if (json['answerInfos'] != null) {
      answerInfos = new List<String>();
      json['answerInfos'].forEach((v) {
        answerInfos.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['questionType'] = this.questionType;
    data['requiredFlag'] = this.requiredFlag;
    data['questionName'] = this.questionName;
    data['messageOptionInfoParams'] = this.messageOptionInfoParams;
    data['answerInfos'] = this.answerInfos;
    return data;
  }

  @override
  String toString() {
    return 'MessageQuestionResultList{questionId: $questionId, questionType: $questionType, requiredFlag: $requiredFlag, questionName: $questionName, messageOptionInfoParams: $messageOptionInfoParams, answerInfos: $answerInfos}';
  }
}

class MessageOptionInfo {
  String optionId;
  String optionName;
  int optionSort;

  MessageOptionInfo({
    this.optionId,
    this.optionName,
    this.optionSort,
  });

  MessageOptionInfo.fromJson(Map<String, dynamic> json) {
    optionId = json['optionId'];
    optionName = json['optionName'];
    optionSort = json['optionSort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionId'] = this.optionId;
    data['optionName'] = this.optionName;
    data['optionSort'] = this.optionSort;
    return data;
  }

  @override
  String toString() {
    return 'MessageOptionInfo{optionId: $optionId, optionName: $optionName, optionSort: $optionSort}';
  }
}
