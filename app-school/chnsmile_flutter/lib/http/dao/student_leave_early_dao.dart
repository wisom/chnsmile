import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/repair_delete_request.dart';
import 'package:chnsmile_flutter/http/request/repair_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/repair_save_request.dart';
import 'package:chnsmile_flutter/http/request/repair_submit_request.dart';
import 'package:chnsmile_flutter/http/request/sysorg_request.dart';
import 'package:chnsmile_flutter/model/student_leave_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';

import '../../model/student_leave_early_detail.dart';
import '../../model/student_leave_early_model.dart';
import '../request/student_leave/student_leave_summary_request.dart';
import '../request/student_leave_early/student_leave_early_approve_request.dart';
import '../request/student_leave_early/student_leave_early_detail_request.dart';
import '../request/student_leave_early/student_leave_early_list_request.dart';
import '../request/student_leave_early/student_leave_early_read_request.dart';
import '../request/student_leave_early/student_leave_early_revoke_request.dart';

class StudentLeaveEarlyDao {
  static getSysOrg() async {
    SysOrgRequest request = SysOrgRequest();
    var result = await HiNet.getInstance().fire(request);
    return SysOrgModel.fromJson(result['data']);
  }

  static detail(String formId) async {
    StudentLeaveEarlyDetailRequest request = StudentLeaveEarlyDetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return StudentLeaveEarlyDetail.fromJson(result['data']);
  }

  ///获取学生早退列表
  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  static list(int page, int pageSize, String listType, String searchBeginTime,
      String searchEndTime) async {
    Map<String, dynamic> params = {};
    params['pageNo'] = page;
    params['pageSize'] = pageSize;
    params['listType'] = listType;
    StudentLeaveEarlyListRequest request = StudentLeaveEarlyListRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return StudentLeaveEarlyModel.fromJson(result['data']);
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
    StudentLeaveEarlyReadRequest request = StudentLeaveEarlyReadRequest();
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
    StudentLeaveEarlyApproveRequest request = StudentLeaveEarlyApproveRequest();
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
  static revoke(String id) async {
    StudentLeaveEarlyRevokeRequest request = StudentLeaveEarlyRevokeRequest();
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
