import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/repair_approve_request.dart';
import 'package:chnsmile_flutter/http/request/repair_delete_request.dart';
import 'package:chnsmile_flutter/http/request/repair_detail_request.dart';
import 'package:chnsmile_flutter/http/request/repair_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/repair_save_request.dart';
import 'package:chnsmile_flutter/http/request/repair_submit_request.dart';
import 'package:chnsmile_flutter/http/request/sysorg_request.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/student_leave_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';

import '../../model/fund_manager_detail.dart';
import '../../model/fund_manager_model.dart';
import '../../model/reimburse_model.dart';
import '../request/fund_manager/fund_manager_approve_request.dart';
import '../request/fund_manager/fund_manager_detail_request.dart';
import '../request/fund_manager/fund_manager_list_request.dart';
import '../request/fund_manager/fund_manager_read_request.dart';
import '../request/info_collection/info_collection_approval_request.dart';
import '../request/reimburese/reimburese_list_request.dart';
import '../request/student_leave/student_leave_approve_request.dart';
import '../request/student_leave/student_leave_delete_request.dart';
import '../request/student_leave/student_leave_detail_request.dart';
import '../request/student_leave/student_leave_list_request.dart';
import '../request/student_leave/student_leave_read_request.dart';
import '../request/student_leave/student_leave_revoke_request.dart';
import '../request/student_leave/student_leave_summary_request.dart';
import '../request/student_leave_early/student_leave_early_detail_request.dart';
import '../request/student_leave_save_request.dart';
import '../request/student_leave_submit_request.dart';

class StudentLeaveDao {
  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }

  static detail(String formId) async {
    StudentLeaveDetailRequest request = StudentLeaveDetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return FundManagerDetail.fromJson(result['data']);
  }

  ///获取学生请假列表
  static list(int page, int pageSize, String listType, String searchBeginTime,
      String searchEndTime) async {
    Map<String, dynamic> params = {};
    params['pageNo'] = page;
    params['pageSize'] = pageSize;
    params['listType'] = listType;
    StudentLeaveListRequest request = StudentLeaveListRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return StudentLeaveModel.fromJson(result['data']);
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  ///获取学生请假缺勤汇总列表
  static summarylist(int page, int pageSize, String queryType, String searchBeginTime,
      String searchEndTime) async {
    Map<String, dynamic> params = {};
    params['pageNo'] = page;
    params['pageSize'] = pageSize;
    params['queryType'] = queryType;//1:查询我班，2.查询全部
    StudentLeaveSummaryRequest request = StudentLeaveSummaryRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return StudentLeaveModel.fromJson(result['data']);
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  static read(Map<String, dynamic> params) async {
    StudentLeaveReadRequest request = StudentLeaveReadRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 审批，阅读
  static approve(Map<String, dynamic> params) async {
    StudentLeaveApproveRequest request = StudentLeaveApproveRequest();
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
    StudentLeaveDeleteRequest request = StudentLeaveDeleteRequest();
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
    StudentLeaveRevokeRequest request = StudentLeaveRevokeRequest();
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
      request = StudentLeaveSaveRequest();
    } else {
      request = StudentLeaveSubmitRequest();
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
