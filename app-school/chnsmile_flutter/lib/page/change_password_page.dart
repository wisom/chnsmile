import 'package:chnsmile_flutter/http/dao/feedback_dao.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String oldPassword;
  String newPassword;
  String newRetryPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fix键盘把下面顶起的问题
      resizeToAvoidBottomInset: false,
      appBar:
          appBar("设置密码", rightTitle: "完成", rightButtonClick: rightButtonClick),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    return Column(
      children: [
        Row(
          children: [
            const Text('    旧密码:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            Expanded(
              child: NormalInput(
                hint: "请输入旧密码",
                obscureText: true,
                onChanged: (text) {
                  oldPassword = text;
                },
              ),
            )
          ],
        ),
        hiSpace(height: 15),
        Row(
          children: [
            const Text('    新密码:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            Expanded(
              child: NormalInput(
                hint: "请输入新密码",
                obscureText: true,
                onChanged: (text) {
                  newPassword = text;
                },
              ),
            )
          ],
        ),
        hiSpace(height: 15),
        Row(
          children: [
            const Text('确认密码:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            Expanded(
              child: NormalInput(
                hint: "请输入确认密码",
                obscureText: true,
                onChanged: (text) {
                  newRetryPassword = text;
                },
              ),
            )
          ],
        ),
        hiSpace(height: 20),
        Container(
          child: const Text('密码必须是8-16位英文字母、数字、字符组合（不能是纯数字）',style: TextStyle(fontSize: 13, color: Colors.grey)),
        )
      ],
    );
  }

  void rightButtonClick() async {
    if (isEmpty(oldPassword)) {
      showWarnToast("旧密码不能为空");
      return;
    }
    if (isEmpty(newPassword)) {
      showWarnToast("新密码不能为空");
      return;
    }
    var exp=RegExp(r"^(?=.*[a-z])(?=.*\d)[^]{8,16}$");
    var isMatch = exp.hasMatch(newPassword);
    if (!isMatch) {
      showWarnToast("密码必须是8-16位英文字母、数字、字符组合（不能是纯数字）");
      return;
    }
    if (isEmpty(newRetryPassword)) {
      showWarnToast("确认密码不能为空");
      return;
    }
    if (newRetryPassword != newPassword) {
      showWarnToast("确认密码必须与新密码一致");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ProfileDao.updatePassword(password: oldPassword, newPassword: newRetryPassword);
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
