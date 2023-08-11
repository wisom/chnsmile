import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance1_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance2_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance_count_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance_detail_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance_dict_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance_edit_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_performance_save_request.dart';
import 'package:chnsmile_flutter/model/teacher_performance1_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance2_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_detail2_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_detail_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_dict_model.dart';

class PerformanceDao {
  /// 班级
  static getTab1({int pageIndex = 1, int pageSize = 10}) async {
    TeacherPerformance1Request request = TeacherPerformance1Request();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherPerformance1Model.fromJson(result['data']);
  }

  /// 个人
  static getTab2({int pageIndex = 1, int pageSize = 10}) async {
    TeacherPerformance2Request request = TeacherPerformance2Request();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherPerformance2Model.fromJson(result['data']);
  }

  static detail(String classId, String operateDate) async {
    TeacherPerformanceCountRequest request = TeacherPerformanceCountRequest();
    request.add("classId", classId);
    request.add("operateDate", operateDate);
    var result = await HiNet.getInstance().fire(request);
    return TeacherPerformanceDetailModel.fromJson(result['data']);
  }

  static detail2(String id) async {
    TeacherPerformanceDetailRequest request = TeacherPerformanceDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return TeacherPerformanceDetail2Model.fromJson(result['data']);
  }

  static dict() async {
    TeacherPerformanceDictRequest request = TeacherPerformanceDictRequest();
    var result = await HiNet.getInstance().fire(request);
    return TeacherPerformanceDictModel.fromJson(result['data']);
  }

  /// 提交
  static submit(Map<String, dynamic> params, {bool isSave}) async {
    TeacherPerformanceSaveRequest request = TeacherPerformanceSaveRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 编辑
  static edit(Map<String, dynamic> params, {bool isSave}) async {
    TeacherPerformanceEditRequest request = TeacherPerformanceEditRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
