import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/profile_default_set_request.dart';
import 'package:chnsmile_flutter/http/request/profile_platform_request.dart';
import 'package:chnsmile_flutter/http/request/profile_request.dart';
import 'package:chnsmile_flutter/http/request/profile_send_msg_request.dart';
import 'package:chnsmile_flutter/http/request/profile_student_request.dart';
import 'package:chnsmile_flutter/http/request/profile_submit_request.dart';
import 'package:chnsmile_flutter/http/request/profile_update_password_request.dart';
import 'package:chnsmile_flutter/http/request/profile_validate_msg_request.dart';
import 'package:chnsmile_flutter/http/request/upload_avator_request.dart';
import 'package:chnsmile_flutter/model/platform_model.dart';
import 'package:chnsmile_flutter/model/profile_model.dart';
import 'package:chnsmile_flutter/model/student_model.dart';
import 'package:dio/dio.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileModel.fromJson(result['data']);
  }

  static getPlatform(String account, int isStaff) async {
    ProfilePlatformRequest request = ProfilePlatformRequest();
    request.add("account", account).add("isStaff", isStaff);
    var result = await HiNet.getInstance().fire(request);
    return PlatformModel.fromJson(result['data']);
  }

  static getStudent(String account) async {
    ProfileStudentRequest request = ProfileStudentRequest();
    request.add("account", account);
    var result = await HiNet.getInstance().fire(request);
    return StudentModel.fromJson(result['data']);
  }

  static submit(
      {String id, int type, String changeName, String changeText}) async {
    ProfileSubmitRequest request = ProfileSubmitRequest();
    request.add("id", id).add("type", type).add(changeName, changeText);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static defaultSet({String account, String stduentId}) async {
    ProfileDefaultSetRequest request = ProfileDefaultSetRequest();
    request.add("account", account).add("stduentId", stduentId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }


  static sendMsg({String url, String phoneNumbers}) async {
    ProfileSendMsgRequest request = ProfileSendMsgRequest(url);
    request.add("phoneNumbers", phoneNumbers);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static validateMsg({String url, String phoneNumbers, String validateCode, String newPassword, String schoolId}) async {
    ProfileValidateMsgRequest request = ProfileValidateMsgRequest(url);
    request.add("phoneNumbers", phoneNumbers)
        .add("validateCode", validateCode)
        .add("newPassword", newPassword)
        .add("schoolId", schoolId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static updatePassword({String password, String newPassword}) async {
    ProfileUpdatePasswordRequest request = ProfileUpdatePasswordRequest();
    request.add("password", password).add("newPassword", newPassword);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static uploadAvator({int type, String path}) async {
    UploadAvatorRequest request = UploadAvatorRequest("?type=$type");
    FormData formdata =
        FormData.fromMap({"file": await MultipartFile.fromFile(path)});
    request.addFormData(formdata);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
