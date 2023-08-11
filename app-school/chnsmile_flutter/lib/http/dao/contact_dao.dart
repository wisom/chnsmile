import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/contact_family_request.dart';
import 'package:chnsmile_flutter/http/request/contact_request.dart';
import 'package:chnsmile_flutter/http/request/contact_teacher_request.dart';
import 'package:chnsmile_flutter/http/request/im_contact_request.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/model/contact_im_model.dart';
import 'package:chnsmile_flutter/model/contact_model.dart';

class ContactDao {
  static get() async {
    ContactRequest request = ContactRequest();
    var result = await HiNet.getInstance().fire(request);
    return ContactModel.fromJson(result['data']);
  }

  static getFamily() async {
    ContactFamilyRequest request = ContactFamilyRequest();
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return ContactFamilyModel.fromJson(result['data']);
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 获取选择的组织人员
  static getTU({String pid}) async {
    BaseRequest request  = ContactTeacherRequest();
    request.add("pid", pid);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return ContactDepartModel.fromJson(result['data']);
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  static getTeacher({String type}) async {
    BaseRequest request;
    if (type == 'message') {
      request = IMContactRequest();
    } else {
      request = ContactTeacherRequest();
    }
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      if (type == 'message') {
        return ContactIMModel.fromJson(result['data']);
      } else {
        return ContactDepartModel.fromJson(result['data']);
      }
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
