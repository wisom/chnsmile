import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/notice_read_request.dart';
import 'package:chnsmile_flutter/http/request/notice_request.dart';
import 'package:chnsmile_flutter/http/request/notice_save_request.dart';
import 'package:chnsmile_flutter/http/request/notice_status_request.dart';
import 'package:chnsmile_flutter/http/request/notice_submit_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_delete_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_detail_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_odetail_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_remind_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_reply_request.dart';
import 'package:chnsmile_flutter/http/request/school_notice_revoke_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_notice_remind_request.dart';
import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/model/notice_read_model.dart';
import 'package:chnsmile_flutter/model/school_notice_detail2_model.dart';
import 'package:chnsmile_flutter/model/school_notice_detail_model.dart';

class NoticeDao {
  static readList(String id, String classId) async {
    NoticeReadRequest request = NoticeReadRequest();
    request.add("id", id).add("classId", classId);
    var result = await HiNet.getInstance().fire(request);
    return NoticeReadModel.fromJson(result['data']);
  }

  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return NoticeModel.fromJson(result['data']);
  }

  static detail(String formId) async {
    SchoolNoticeODetailRequest request = SchoolNoticeODetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return SchoolNoticeDetailModel.fromJson(result['data']);
  }

  static schoolNoticeDetail(String formId) async {
    SchoolNoticeDetailRequest request = SchoolNoticeDetailRequest();
    request.add("formId", formId);
    var result = await HiNet.getInstance().fire(request);
    return SchoolNoticeDetail2Model.fromJson(result['data']);
  }

  /// 删除
  static delete(String noticeId) async {
    SchoolNoticeDeleteRequest request = SchoolNoticeDeleteRequest();
    request.add("formId", noticeId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String noticeId) async {
    SchoolNoticeRevokeRequest request = SchoolNoticeRevokeRequest();
    request.add("formId", noticeId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 提醒教师回复
  static remind(Map<String, dynamic> params) async {
    SchoolNoticeRemindRequest request = SchoolNoticeRemindRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 提醒家长回复
  static teacherRemind(Map<String, dynamic> params) async {
    TeacherNoticeRemindRequest request = TeacherNoticeRemindRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 消息已读
  static read(String noticeId) async {
    SchoolNoticeReplyRequest request = SchoolNoticeReplyRequest();
    request.add("formId", noticeId);
    request.add("status", 2);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 回复
  static replay(String noticeId, {String remark = ""}) async {
    SchoolNoticeReplyRequest request = SchoolNoticeReplyRequest();
    request.add("formId", noticeId);
    request.add("approveRemark", remark);
    request.add("status", 2);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  static noticeChangeStatus(String id, int status) async {
    NoticeStatusRequest request = NoticeStatusRequest();
    request.add("id", id).add("status", status);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }

  /// 提交
  static submit(Map<String, dynamic> params, {bool isSave}) async {
    BaseRequest request;
    if (isSave) {
      request = NoticeSubmitRequest();
    } else {
      request = NoticeSaveRequest();
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
