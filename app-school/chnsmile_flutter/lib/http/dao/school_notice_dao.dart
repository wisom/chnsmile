import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_delete_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_detail_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_edit_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_save_request.dart';
import 'package:chnsmile_flutter/model/school_notice_model.dart';
import 'package:chnsmile_flutter/model/teacher_notice_detail_model.dart';
import 'package:chnsmile_flutter/model/teacher_notice_model.dart';

class SchoolNoticeDao {
  static get(String type, {int pageIndex = 1, int pageSize = 10}) async {
    SchoolNoticeRequest request = SchoolNoticeRequest(type);
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return SchoolNoticeModel.fromJson(result['data']);
  }

  static getTeacherList({int pageIndex = 1, int pageSize = 10}) async {
    TeacherNoticeRequest request = TeacherNoticeRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherNoticeModel.fromJson(result['data']);
  }

  static detail(String id) async {
    TeacherNoticeDetailRequest request = TeacherNoticeDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return TeacherNoticeDetailModel.fromJson(result['data']);
  }

  /// 删除
  static delete(Map<String, dynamic> params) async {
    TeacherNoticeDeleteRequest request = TeacherNoticeDeleteRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String noticeId, int status) async {
    TeacherNoticeRevokeRequest request = TeacherNoticeRevokeRequest();
    request.add("id", noticeId);
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
      request = TeacherNoticeEditRequest();
    } else {
      request = TeacherNoticeSaveRequest();
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
