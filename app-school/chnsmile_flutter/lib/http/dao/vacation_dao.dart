import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_approve_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_calculation_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_delete_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_detail_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_init_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_read_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_save_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_submit_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_type_request.dart';
import 'package:chnsmile_flutter/model/vacation_calculation_model.dart';
import 'package:chnsmile_flutter/model/vacation_detail_model.dart';
import 'package:chnsmile_flutter/model/vacation_init_model.dart';
import 'package:chnsmile_flutter/model/vacation_model1.dart';

class VacationDao {

  static get({int type = 1, int pageIndex = 1, int pageSize = 10}) async {
    VacationRequest request = VacationRequest();
    request.add("listType", type).add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    if (type == 1) {
      return VacationModel1.fromJson(result['data']);
    } else {
      return VacationModel1.fromJson(result['data']);
    }
  }

  static detail(String id) async {
    VacationDetailRequest request = VacationDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return VacationDetailModel.fromJson(result['data']);
  }

  /// 获取初始化数据
  static init() async {
    VacationInitRequest request = VacationInitRequest();
    var result = await HiNet.getInstance().fire(request);
    return VacationInitModel.fromJson(result['data']);
  }

  /// 获取初始化数据
  static getType() async {
    VacationTypeRequest request = VacationTypeRequest();
    var result = await HiNet.getInstance().fire(request);
    return result['data'];
  }

  /// 计算假期时间
  static calculation(String dateStart, String dateEnd) async {
    VacationCalculationRequest request = VacationCalculationRequest();
    request.add("dateStart", dateStart).add("dateEnd", dateEnd);
    var result = await HiNet.getInstance().fire(request);
    return VacationCalculationModel.fromJson(result['data']);
  }

  /// 审批
  static approve(Map<String, dynamic> params) async {
    VacationApproveRequest request = VacationApproveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 阅读
  static read(String id) async {
    VacationReadRequest request = VacationReadRequest();
    request.add("formId", id);
    request.add("status", 2);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 删除
  static delete(String repairId) async {
    VacationDeleteRequest request = VacationDeleteRequest();
    request.add("formId", repairId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String formId) async {
    VacationRevokeRequest request = VacationRevokeRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 保存
  static save(Map<String, dynamic> params) async {
    VacationSaveRequest request = VacationSaveRequest();
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
      request = VacationSaveRequest();
    } else {
      request = VacationSubmitRequest();
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
