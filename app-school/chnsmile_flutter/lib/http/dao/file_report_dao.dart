import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/document_add_approve_request.dart';
import 'package:chnsmile_flutter/http/request/document_approve_request.dart';
import 'package:chnsmile_flutter/http/request/document_approvepc_request.dart';
import 'package:chnsmile_flutter/http/request/document_delete_request.dart';
import 'package:chnsmile_flutter/http/request/document_detail_request.dart';
import 'package:chnsmile_flutter/http/request/document_read_request.dart';
import 'package:chnsmile_flutter/http/request/document_remove_approve_request.dart';
import 'package:chnsmile_flutter/http/request/document_request.dart';
import 'package:chnsmile_flutter/http/request/document_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/document_save_request.dart';
import 'package:chnsmile_flutter/http/request/document_submit_request.dart';
import 'package:chnsmile_flutter/http/request/file_report/file_report_read_request.dart';
import 'package:chnsmile_flutter/model/document_detail_model.dart';
import 'package:chnsmile_flutter/model/document_model.dart';
import 'package:chnsmile_flutter/model/document_pc_model.dart';

import '../../model/file_report_detail_model.dart';
import '../../model/file_report_model.dart';
import '../request/file_report/file_report_approve_request.dart';
import '../request/file_report/file_report_delete_request.dart';
import '../request/file_report/file_report_list_request.dart';
import '../request/file_report/file_report_revoke_request.dart';
import '../request/file_report/file_report_detail_request.dart';
import '../request/file_report/file_report_save_request.dart';
import '../request/file_report/file_report_submit_request.dart';

class FileReportDao {
  static get({String type = "1", int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = FileReportListRequest();
    request
        .add("listType", type)
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return FileReportModel.fromJson(result['data']);
  }

  static detail(String id) async {
    FileReportDetailRequest request = FileReportDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return FileReportDetailModel.fromJson(result['data']);
  }

  /// 审批，阅读
  static approve(Map<String, dynamic> params) async {
    FileReportApproveRequest request = FileReportApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 获取审批人
  static approvePc(String formId) async {
    BaseRequest request = DocumentApprovePcRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return DocumentPcModel.fromJson(result['data']);
  }

  /// 阅读
  static read(String id) async {
    FileReportReadRequest request = FileReportReadRequest();
    request.add("id", id);
    request.add("status", 2);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 添加审批人
  static addApprove(Map<String, dynamic> params) async {
    DocumentAddApproveRequest request = DocumentAddApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 删除审批人
  static removeApprove(String id) async {
    DocumentRemoveApproveRequest request = DocumentRemoveApproveRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 删除
  static delete(String id) async {
    FileReportDeleteRequest request = FileReportDeleteRequest();
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
    FileReportRevokeRequest request = FileReportRevokeRequest();
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
    DocumentSaveRequest request = DocumentSaveRequest();
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
      request = FileReportSaveRequest();
    } else {
      request = FileReportSubmitRequest();
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
