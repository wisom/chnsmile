import 'dart:convert';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/fund_manager/fund_manager_read_request.dart';
import 'package:chnsmile_flutter/http/request/repair_approve_request.dart';
import 'package:chnsmile_flutter/http/request/repair_delete_request.dart';
import 'package:chnsmile_flutter/http/request/repair_detail_request.dart';
import 'package:chnsmile_flutter/http/request/repair_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/repair_save_request.dart';
import 'package:chnsmile_flutter/http/request/repair_submit_request.dart';
import 'package:chnsmile_flutter/http/request/sysorg_request.dart';
import 'package:chnsmile_flutter/model/class_photo_dynamic_model.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';
import 'package:chnsmile_flutter/model/wxunbind_list_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';

import '../../model/class_photo_model.dart';
import '../../model/fund_manager_detail.dart';
import '../../model/fund_manager_model.dart';
import '../request/class_photo/class_photo_delete_request.dart';
import '../request/class_photo/class_photo_detail_request.dart';
import '../request/fund_manager/class_photo_list_request.dart';
import '../request/fund_manager/fund_manager_approve_request.dart';
import '../request/fund_manager/fund_manager_detail_request.dart';
import '../request/fund_manager/fund_manager_list_request.dart';
import '../request/fund_manager/fund_manager_save_request.dart';
import '../request/fund_manager/fund_manager_submit_request.dart';
import '../request/info_collection/info_collection_approval_request.dart';
import '../request/wx_login/wx_bind_list_request.dart';

class WxLoginDao {
  static var TAG="WxLoginDao==";

  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }

  static detail(String id) async {
    ClassPhotoDetailRequest request = ClassPhotoDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return ClassPhotoDynamicModel.fromJson(result['data']);
  }

  static list(String account) async {
    Map<String, dynamic> params = {};
    params['account'] = account;
    WxBindListRequest request = WxBindListRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return WxInfoModel.fromJson(jsonDecode(result['data']));
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 审批，阅读
  static approve(Map<String, dynamic> params) async {
    FundManagerApproveRequest request = FundManagerApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  static read(Map<String, dynamic> params) async {
    FundManagerReadRequest request = FundManagerReadRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 删除
  static delete(String id) async {
    ClassPhotoDeleteRequest request = ClassPhotoDeleteRequest();
    request.add("ids", "[$id]");
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
    FundManagerSaveRequest request = FundManagerSaveRequest();
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
    LogUtil.d(TAG, "submit params="+params.toString());
    BaseRequest request;
    if (isSave) {
      request = FundManagerSaveRequest();
    } else {
      request = FundManagerSubmitRequest();
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
