import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_course_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_detail2_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_detail_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_head_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_plan_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_request1.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_request2.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_request3.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_request4.dart';
import 'package:chnsmile_flutter/http/request/class_transfer/class_transfer_request5.dart';
import 'package:chnsmile_flutter/http/request/class_transfer_approve_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer_delete_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer_save_request.dart';
import 'package:chnsmile_flutter/http/request/class_transfer_submit_request.dart';
import 'package:chnsmile_flutter/model/class_transfer_course_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_detail_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_head_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_model1.dart';
import 'package:chnsmile_flutter/model/class_transfer_model2.dart';
import 'package:chnsmile_flutter/model/class_transfer_model3.dart';
import 'package:chnsmile_flutter/model/class_transfer_model4.dart';
import 'package:chnsmile_flutter/model/class_transfer_model5.dart';
import 'package:chnsmile_flutter/model/class_transfer_plan_model.dart';

class ClassTransferDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    ClassTransferRequest1 request = ClassTransferRequest1();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferModel1.fromJson(result['data']);
  }

  static get2({int pageIndex = 1, int pageSize = 10}) async {
    ClassTransferRequest2 request = ClassTransferRequest2();
    request.add("kinds", "1").add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferModel2.fromJson(result['data']);
  }

  static get3({int pageIndex = 1, int pageSize = 10}) async {
    ClassTransferRequest3 request = ClassTransferRequest3();
    request.add("kinds", "2").add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferModel3.fromJson(result['data']);
  }

  static get4({int pageIndex = 1, int pageSize = 10}) async {
    ClassTransferRequest4 request = ClassTransferRequest4();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferModel4.fromJson(result['data']);
  }

  static get5({int pageIndex = 1, int pageSize = 10}) async {
    ClassTransferRequest5 request = ClassTransferRequest5();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferModel5.fromJson(result['data']);
  }

  static detail(String id, {int type = 0, int kinds = 0}) async {
    BaseRequest request;
    // if (type == 2 || type == 3) {
    //   request = ClassTransferDetail2Request();
    // } else {
      request = ClassTransferDetailRequest();
    // }
    request.add("id", id);
    request.add("kinds", kinds);
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferDetailModel.fromJson(result['data']);
  }

  static getClassAndCourse() async {
    ClassTransferCourseRequest request = ClassTransferCourseRequest();
    var result = await HiNet.getInstance().fire(request);
    return ClassTransferCourseModel.fromJson(result['data']);
  }

  static classPlan(String classId, String courseId, String classDate) async {
    ClassTransferPlanRequest request = ClassTransferPlanRequest();
    request.add("classId", classId).add("courseId", courseId).add("classDate", classDate);
    var result = await HiNet.getInstance().fire(request);
    return ClassPlanModel.fromJson(result['data']);
  }

  static classHead(String classId) async {
    ClassTransferHeadRequest request = ClassTransferHeadRequest();
    request.add("classId", classId);
    var result = await HiNet.getInstance().fire(request);
    return ClassHeadModel.fromJson(result['data']);
  }

  /// 审批，阅读
  static approve(Map<String, dynamic> params) async {
    ClassTransferApproveRequest request = ClassTransferApproveRequest();
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
    ClassTransferDeleteRequest request = ClassTransferDeleteRequest();
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
    ClassTransferRevokeRequest request = ClassTransferRevokeRequest();
    request.add("id", repairId);
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
      request = ClassTransferSaveRequest();
    } else {
      request = ClassTransferSubmitRequest();
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
