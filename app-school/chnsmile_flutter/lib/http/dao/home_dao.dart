import 'package:chnsmile_flutter/http/request/button_permission_request.dart';
import 'package:chnsmile_flutter/http/request/home_request.dart';
import 'package:chnsmile_flutter/http/request/oa_all_mark_request.dart';
import 'package:chnsmile_flutter/http/request/oa_mark_request.dart';
import 'package:chnsmile_flutter/http/request/oa_permission_request.dart';
import 'package:chnsmile_flutter/model/home_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/model/oa_mark_model.dart';
import 'package:chnsmile_flutter/model/oa_permission_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeDao {
  static const String schoolHomeNoticeAdd = 'schoolHomeNotice:add';
  static const String schoolHomeworkNoticeAdd = 'schoolHomeworkNotice:add';
  static const String schoolBehaviorAdd = 'schoolBehavior:add';
  static const String schoolGrowtharchiveAdd = 'schoolGrowtharchive:add';
  static const String schoolOaInfoAddInfo = 'school-oa:info:addInfo';
  static const String schoolOaLeaveSubmitLeave = 'school-oa:leave:submitLeave';
  static const String schoolOaRepairRepairSubmit = 'school-oa:repair:repairSubmit';
  static const String schoolHomeVoteAdd = 'schoolHomeVote:add';
  static const String schoolOaDocumentSubmitDocument = 'school-oa:document:submitDocument';
  static const String schoolOaChangeSendChange = 'school-oa:change:sendChange';

  static getP(String code) async {
    // EasyLoading.show(status: '加载中...');
    try {
      bool result = await HomeDao.getButtonPermission(code);
      // EasyLoading.dismiss(animation: false);
      // if (!result) {
      //   showWarnToast("您无此操作权限");
      // }
      return result;
    } catch (e) {
      // EasyLoading.dismiss(animation: false);
      return true;
    }
  }

  static get() async {
    HomeRequest request = HomeRequest();
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return HomeModel.fromJson(result['data']);
  }

  static getAllMark() async {
    OAAllMarkRequest request = OAAllMarkRequest();
    var result = await HiNet.getInstance().fire(request);
    return OAMarkModel.fromJson(result['data']);
  }

  static getMark(String tag) async {
    OAMarkRequest request = OAMarkRequest();
    request.add("param", tag);
    var result = await HiNet.getInstance().fire(request);
    return OAMarkModel.fromJson(result['data']);
  }

  static getOAPermission() async {
    OAPermissionRequest request = OAPermissionRequest();
    var result = await HiNet.getInstance().fire(request);
    return OAPermissionModel.fromJson(result['data']);
  }

  static getButtonPermission(String code, {int type = 2}) async {
    ButtonPermissionRequest request = ButtonPermissionRequest();
    request.add("code", code);
    request.add("type", type);
    var result = await HiNet.getInstance().fire(request);
    return result['data'];
  }
}
