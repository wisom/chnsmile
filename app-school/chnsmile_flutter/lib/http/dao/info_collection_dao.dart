import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/repair_approval_request.dart';
import 'package:chnsmile_flutter/http/request/repair_approve_request.dart';
import 'package:chnsmile_flutter/http/request/repair_delete_request.dart';
import 'package:chnsmile_flutter/http/request/repair_detail_request.dart';
import 'package:chnsmile_flutter/http/request/repair_request.dart';
import 'package:chnsmile_flutter/http/request/repair_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/repair_save_request.dart';
import 'package:chnsmile_flutter/http/request/repair_submit_request.dart';
import 'package:chnsmile_flutter/http/request/sysorg_request.dart';
import 'package:chnsmile_flutter/model/info_collection_detail_model.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/repair_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';

import '../../model/info_collection_model.dart';
import '../request/info_collection/info_collection_approval_request.dart';
import '../request/info_collection/info_collection_detail_request.dart';

class InfoCollectionDao {
  static get({String type = "", int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request;
    if (type.isEmpty) {
      request = InfoCollectionApprovalRequest();
    } else {
      request = InfoCollectionApprovalRequest();
      request.add("listType", type);//(0:查询教师发起的列表，2：查询学生需要打卡列表)
    }
    request.add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return InfoCollectionModel.fromJson(result['data']);
  }

  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }


  static detail(String id) async {
    InfoCollectionDetailRequest request = InfoCollectionDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return InfoCollectionDetailModel.fromJson(result['data']);
  }

  /// 审批，阅读
  static approve(Map<String, dynamic> params) async {
    RepairApproveRequest request = RepairApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 删除
  static delete(String repairId) async {
    RepairDeleteRequest request = RepairDeleteRequest();
    request.add("id", repairId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String repairId) async {
    RepairRevokeRequest request = RepairRevokeRequest();
    request.add("id", repairId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 保存
  static save(Map<String, dynamic> params) async {
    RepairSaveRequest request = RepairSaveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 提交
  static submit(Map<String, dynamic> params, {bool isSave}) async {
    BaseRequest request;
    if (isSave) {
      request = RepairSaveRequest();
    } else {
      request = RepairSubmitRequest();
    }
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
