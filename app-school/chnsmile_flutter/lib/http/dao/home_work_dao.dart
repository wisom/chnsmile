import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/home_work/home_work_detail_request.dart';
import 'package:chnsmile_flutter/http/request/home_work/home_work_request.dart';
import 'package:chnsmile_flutter/http/request/home_work/teacher_home_work_detail_request.dart';
import 'package:chnsmile_flutter/http/request/home_work/teacher_home_work_request.dart';
import 'package:chnsmile_flutter/http/request/home_work_read2_request.dart';
import 'package:chnsmile_flutter/http/request/home_work_read_request.dart';
import 'package:chnsmile_flutter/http/request/home_work_remind_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_home_work_delete_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_home_work_edit_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_home_work_remind_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_home_work_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_home_work_save_request.dart';
import 'package:chnsmile_flutter/model/home_work_detail_model.dart';
import 'package:chnsmile_flutter/model/home_work_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/model/notice_read_model.dart';
import 'package:chnsmile_flutter/model/teacher_home_work_detail_model.dart';
import 'package:chnsmile_flutter/model/teacher_home_work_model.dart';

class HomeWorkDao {
  static readList(String id, String classId) async {
    HomeWorkRead2Request request = HomeWorkRead2Request();
    request.add("id", id).add("classId", classId);
    var result = await HiNet.getInstance().fire(request);
    return NoticeReadModel.fromJson(result['data']);
  }

  static getList({int pageIndex = 1, int pageSize = 10}) async {
    HomeWorkRequest request = HomeWorkRequest();
    request
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return HomeWorkModel.fromJson(result['data']);
  }

  /// 提醒家长回复
  static teacherRemind(Map<String, dynamic> params) async {
    TeacherHomeWorkRemindRequest request = TeacherHomeWorkRemindRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 提醒回复
  static remind(Map<String, dynamic> params) async {
    HomeWorkRemindRequest request = HomeWorkRemindRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  static getTeacherList({int pageIndex = 1, int pageSize = 10}) async {
    TeacherHomeWorkRequest request = TeacherHomeWorkRequest();
    request
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherHomeWorkModel.fromJson(result['data']);
  }

  static teacherDetail(String homeWorkId) async {
    TeacherHomeWorkDetailRequest request = TeacherHomeWorkDetailRequest();
    request.add("id", homeWorkId);
    var result = await HiNet.getInstance().fire(request);
    return TeacherHomeWorkDetailModel.fromJson(result['data']);
  }

  static detail(String homeWorkId) async {
    HomeWorkDetailRequest request = HomeWorkDetailRequest();
    request.add("id", homeWorkId);
    var result = await HiNet.getInstance().fire(request);
    return HomeWorkDetailModel.fromJson(result['data']);
  }

  /// 删除
  static delete(Map<String, dynamic> params) async {
    TeacherHomeWorkDeleteRequest request = TeacherHomeWorkDeleteRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String id, int status) async {
    TeacherHomeWorkRevokeRequest request = TeacherHomeWorkRevokeRequest();
    request.add("id", id);
    request.add("status", status);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 已读 status  阅读状态  1 已读  2 确认已读   3 签字已读
  static read(String id, int status) async {
    HomeWorkReadRequest request = HomeWorkReadRequest();
    request.add("id", id);
    request.add("status", status);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 提交
  static submit(Map<String, dynamic> params, {bool isEdit}) async {
    BaseRequest request;
    if (isEdit) {
      request = TeacherHomeWorkEditRequest();
    } else {
      request = TeacherHomeWorkSaveRequest();
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
