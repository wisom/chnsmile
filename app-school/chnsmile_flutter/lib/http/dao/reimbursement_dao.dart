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
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/repair_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';

import '../../model/reimbursement_detail_model.dart';
import '../../model/reimbursement_model.dart';
import '../request/reimbursement/reimbursement_approve_request.dart';
import '../request/reimbursement/reimbursement_delete_request.dart';
import '../request/reimbursement/reimbursement_detail_request.dart';
import '../request/reimbursement/reimbursement_read_request.dart';
import '../request/reimbursement/reimbursement_request.dart';
import '../request/reimbursement/reimbursement_revoke_request.dart';
import '../request/reimbursement/reimbursement_save_request.dart';
import '../request/reimbursement/reimbursement_submit_request.dart';

class ReimbursementDao {
  static get({String type = "", int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request;
    request = ReimbursementRequest();
    request.add("listType", type);
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ReimbursementModel.fromJson(result['data']);
  }

  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }

  static detail(String formId) async {
    ReimbursementDetailRequest request = ReimbursementDetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return ReimbursementDetailModel.fromJson(result['data']);
  }

  /// 审批
  static approve(Map<String, dynamic> params) async {
    ReimbursementApproveRequest request = ReimbursementApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 查看
  static read(Map<String, dynamic> params) async {
    ReimbursementReadRequest request = ReimbursementReadRequest();
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
    ReimburseDeleteRequest request = ReimburseDeleteRequest();
    Map<String, dynamic> params = {};
    params['ids'] = [id];
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String id) async {
    ReimbursementRevokeRequest request = ReimbursementRevokeRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 保存
  static save(Map<String, dynamic> params) async {
    ReimbursementSaveRequest request = ReimbursementSaveRequest();
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
      request = ReimbursementSaveRequest();
    } else {
      request = ReimbursementSubmitRequest();
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
