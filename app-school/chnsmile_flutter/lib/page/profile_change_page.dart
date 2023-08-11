import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/profile_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/login_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class ProfileChangePage extends StatefulWidget {
  final Map params;
  ProfileModel profileModel;
  String type;

  ProfileChangePage({Key key, this.params}) : super(key: key) {
    profileModel = params['profile'];
    type = params['type'];
  }

  @override
  _ProfileChangePageState createState() => _ProfileChangePageState();
}

class _ProfileChangePageState extends HiState<ProfileChangePage> {
  String changeText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // fix键盘把下面顶起的问题
        resizeToAvoidBottomInset: false,
        appBar: appBar('修改${buildTitle()}',
            rightTitle: "提交", rightButtonClick: onButtonClick),
        body: buildContent());
  }

  onButtonClick() async {
    if (isEmpty(changeText)) {
      showToast("${buildTitle()}不能为空");
      return;
    }

    if (buildText() == changeText) {
      showToast("修改的值不能跟目前的一样");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      var result = await ProfileDao.submit(
          id: widget.profileModel.parentInfo.userId,
          type: 1,
          changeName: widget.type,
          changeText: changeText);
      print(result);
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  buildTitle() {
    if (widget.type == "email") {
      return "邮箱";
    } else if (widget.type == "remark") {
      return "个性签名";
    } else if (widget.type == "idCard") {
      return "身份证号码";
    }
  }

  buildText() {
    if (widget.type == "email") {
      return widget.profileModel.parentInfo.email;
    } else if (widget.type == "remark") {
      return widget.profileModel.parentInfo.remark;
    }  else if (widget.type == "idCard") {
      return widget.profileModel.parentInfo.idCard;
    }
  }

  buildContent() {
    return Column(
      children: [
        hiSpace(height: 20),
        LoginInput(
          '请输入${buildTitle()}',
          onChanged: (text) {
            changeText = text;
            checkInput();
          },
        ),
      ],
    );
  }

  checkInput() {}
}
