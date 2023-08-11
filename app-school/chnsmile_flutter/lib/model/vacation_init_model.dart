import 'package:chnsmile_flutter/model/default_apply_model.dart';

class VacationInitModel {
  DefaultApplyModel defaultApproveInfo;
  List<KindsInfo> leaveKindsInfo;
  List<KindsInfo> applyKindsInfo;

  VacationInitModel(
      {this.defaultApproveInfo, this.leaveKindsInfo, this.applyKindsInfo});

  VacationInitModel.fromJson(Map<String, dynamic> json) {
    defaultApproveInfo = json['defaultApproveInfo'] != null
        ? new DefaultApplyModel.fromJson(json['defaultApproveInfo'])
        : null;
    if (json['leaveKindsInfo'] != null) {
      leaveKindsInfo = new List<KindsInfo>();
      json['leaveKindsInfo'].forEach((v) {
        leaveKindsInfo.add(new KindsInfo.fromJson(v));
      });
    }
    if (json['applyKindsInfo'] != null) {
      applyKindsInfo = new List<KindsInfo>();
      json['applyKindsInfo'].forEach((v) {
        applyKindsInfo.add(new KindsInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.defaultApproveInfo != null) {
      data['defaultApproveInfo'] = this.defaultApproveInfo.toJson();
    }
    if (this.leaveKindsInfo != null) {
      data['leaveKindsInfo'] =
          this.leaveKindsInfo.map((v) => v.toJson()).toList();
    }
    if (this.applyKindsInfo != null) {
      data['applyKindsInfo'] =
          this.applyKindsInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KindsInfo {
  String value;
  String code;

  KindsInfo({this.value, this.code});

  KindsInfo.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['code'] = this.code;
    return data;
  }
}
