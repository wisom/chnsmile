import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/growth_file_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth1_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth2_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth_count_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth_detail_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth_dict_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth_edit_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_growth_save_request.dart';
import 'package:chnsmile_flutter/model/growth_file_model.dart';
import 'package:chnsmile_flutter/model/teacher_growth1_model.dart';
import 'package:chnsmile_flutter/model/teacher_growth2_model.dart';
import 'package:chnsmile_flutter/model/teacher_growth_detail2_model.dart';
import 'package:chnsmile_flutter/model/teacher_growth_detail_model.dart';
import 'package:chnsmile_flutter/model/teacher_growth_dict_model.dart';

class GrowthFileDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    GrowthFileRequest request = GrowthFileRequest();
    request
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return GrowthFileModel.fromJson(result['data']);
  }

  /// 班级
  static getTab1({int pageIndex = 1, int pageSize = 10}) async {
    TeacherGrowth1Request request = TeacherGrowth1Request();
    var result = await HiNet.getInstance().fire(request);
    return TeacherGrowth1Model.fromJson(result['data']);
  }

  /// 个人
  static getTab2({int pageIndex = 1, int pageSize = 10}) async {
    TeacherGrowth2Request request = TeacherGrowth2Request();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherGrowth2Model.fromJson(result['data']);
  }

  static detail(String classId, String operateDate) async {
    TeacherGrowthCountRequest request = TeacherGrowthCountRequest();
    request.add("classId", classId);
    request.add("operateDate", operateDate);
    var result = await HiNet.getInstance().fire(request);
    return TeacherGrowthDetailModel.fromJson(result['data']);
  }

  static detail2(String id) async {
    TeacherGrowthDetailRequest request = TeacherGrowthDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return TeacherGrowthDetail2Model.fromJson(result['data']);
  }

  static dict() async {
    TeacherGrowthDictRequest request = TeacherGrowthDictRequest();
    var result = await HiNet.getInstance().fire(request);
    return TeacherGrowthDictModel.fromJson(result['data']);
  }

  /// 提交
  static submit(Map<String, dynamic> params, {bool isSave}) async {
    TeacherGrowthSaveRequest request = TeacherGrowthSaveRequest();
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
    TeacherGrowthEditRequest request = TeacherGrowthEditRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
