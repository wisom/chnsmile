import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/platform_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/copyrigh.dart';
import 'package:chnsmile_flutter/widget/login_button.dart';
import 'package:chnsmile_flutter/widget/login_input.dart';
import 'package:chnsmile_flutter/widget/round_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  bool loginEnable = false;
  String userName;
  String verifyCode;
  String passWord;
  String rePassWord;
  String baseUrl;
  String schoolId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fix键盘把下面顶起的问题
      resizeToAvoidBottomInset: false,
      appBar: appBar('忘记密码'),
      body: Stack(
        children: [
          ListView(
            children: [
              hiSpace(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildType(1, '家长身份', Colors.black),
                  hiSpace(width: 20),
                  _buildType(2, '老师身份', Colors.black),
                ],
              ),
              hiSpace(height: 16),
              LoginInput(
                '请输入手机号码',
                icon: Icons.phone_iphone_rounded,
                iconSize: 22,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  userName = text;
                },
              ),
              LoginInput(
                '验证码',
                iconSize: 22,
                maxLength: 6,
                icon: Icons.verified_rounded,
                rightButtonText: '获取',
                onChanged: (text) {
                  verifyCode = text;
                },
                onRightButtonPressed: onVerifyPressed,
              ),
              LoginInput(
                '重置密码',
                iconSize: 22,
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (text) {
                  passWord = text;
                },
              ),
              LoginInput(
                '再次输入密码',
                iconSize: 22,
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (text) {
                  rePassWord = text;
                },
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Text('密码必须是8-16位英文字母、数字、字符组合（不能是纯数字）',
                    style: TextStyle(fontSize: 13, color: Colors.orange)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: LoginButton("提交", enable: true, onPressed: checkParams),
              )
            ],
          ),
          const Copyrigh(),
        ],
      ),
    );
  }

  var check1 = true;
  var check2 = false;

  _buildType(int type, String typeName, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundCheckBox(
            size: 22,
            checkedWidget: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
            checkedColor: primary,
            uncheckedColor: Colors.grey[400],
            border: Border.all(color: Colors.grey[200], width: 1),
            isChecked: type == 1 ? check1 : check2,
            onTap: (selected) {
              setState(() {
                if (type == 1) {
                  check1 = true;
                  check2 = false;
                } else {
                  check1 = false;
                  check2 = true;
                }
              });
            }),
        hiSpace(width: 6),
        InkWell(
            onTap: () {
              setState(() {
                if (type == 1) {
                  check1 = true;
                  check2 = false;
                } else {
                  check1 = false;
                  check2 = true;
                }
              });
            },
            child: Text(typeName, style: TextStyle(fontSize: 16, color: color)))
      ],
    );
  }

  Future<bool> onVerifyPressed() async {
    Utils.hideKeyShowfocus();
    if (isEmpty(userName)) {
      showWarnToast("手机号不能为空");
      return false;
    }
    try {
      EasyLoading.show(status: '加载中...');
      PlatformModel platform =
          await ProfileDao.getPlatform(userName, check1 ? 1 : 2);
      var url = HiConstant.sendMsg;
      if (platform != null && platform.list.isNotEmpty) {
        Platform p = platform.list[0];
        baseUrl = p.hostUrl;
        if (baseUrl != null || baseUrl != '') {
          url = baseUrl + HiConstant.sendMsg;
        }
        if (p.schoolId != null) {
          schoolId = p.schoolId;
        }
      }

      var result = await ProfileDao.sendMsg(url: url, phoneNumbers: userName);
      showToast('发送成功');
      EasyLoading.dismiss(animation: false);
      return true;
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
      return false;
    }
  }

  void checkParams() async {
    Utils.hideKeyShowfocus();
    if (isEmpty(userName)) {
      showWarnToast("手机号不能为空");
      return;
    }
    if (isEmpty(verifyCode)) {
      showWarnToast("验证码不能为空");
      return;
    }
    if (isEmpty(passWord)) {
      showWarnToast("请输入新密码");
      return;
    }
    var exp = RegExp(r"^(?=.*[a-z])(?=.*\d)[^]{8,16}$");
    var isMatch = exp.hasMatch(passWord);
    if (!isMatch) {
      showWarnToast("密码必须是8-16位英文字母、数字、字符组合（不能是纯数字）");
      return;
    }

    if (passWord != rePassWord) {
      showWarnToast("确认密码必须一致");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      String url = HiConstant.validateMsg2;
      if (baseUrl != null || baseUrl != '') {
        url = baseUrl + HiConstant.validateMsg2;
      }
      var result = await ProfileDao.validateMsg(
          url: url,
          phoneNumbers: userName,
          validateCode: verifyCode,
          newPassword: rePassWord,
          schoolId: schoolId);
      showToast('提交成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop({"success": true});
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }
}
