import 'dart:convert';

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
import 'package:chnsmile_flutter/model/super_file_detail_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';

import '../../model/contact_select.dart';
import '../../model/select_person_model.dart';
import '../../model/super_file_model.dart';
import '../../model/super_notice_detail_model.dart';
import '../../model/super_notice_model.dart';
import '../../utils/hi_toast.dart';
import '../request/super_file/super_file_detail_request.dart';
import '../request/super_file/super_file_list_request.dart';
import '../request/super_file/super_file_transfer_request.dart';
import '../request/super_notice/super_notice_detail_request.dart';
import '../request/super_notice/super_notice_list_request.dart';
import '../request/super_notice/super_notice_revoke_request.dart';
import '../request/super_notice_delete_request.dart';

class SuperNoticeDao {
  static list({int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = SuperNoticeListRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return SuperNoticeModel.fromJson(result['data']);
  }

  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }

  /// 转发
  static transfer(String formId, List<ContactSelect> list) async {
    SuperFileTransferRequest request = SuperFileTransferRequest();
    if (list != null) {
      List approves = [];
      for (var v in list) {
        approves.add({
          "approveId": v.id ?? "",
          "id": v.teacherId,
          "orgId": v.parentId,
          "orgName": v.orgName,
          "realName": v.name
        });
      }
      Map<String, dynamic> params = {};
      params['formId'] = formId;
      params['infoApproveList'] = approves;
      request.params = params;

      var result = await HiNet.getInstance().fire(request);
      if (result['code'] == HiConstant.successCode) {
        showToast("转发成功");
        return result;
      } else {
        throw HiNetError(HiConstant.errorBusCode, result['message']);
      }
    }
  }

  static detail(String formId) async {
    SuperNoticeDetailRequest request = SuperNoticeDetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return SuperNoticeDetailModel.fromJson(result['data']);
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
  static delete(String formId) async {
    SuperNoticeDeleteRequest request = SuperNoticeDeleteRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String id) async {
    SuperNoticeRevokeRequest request = SuperNoticeRevokeRequest();
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
