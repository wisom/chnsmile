import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/core/platform_response.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/student_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/confirm_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_cache/hi_cache.dart';


class ChildCard extends StatefulWidget {
  final Student item;
  final bool isOneChild;

  const ChildCard({Key key, this.item, this.isOneChild = true}) : super(key: key);

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          switchChild();
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  bool get isSelected {
    return widget.item.studentId == HiCache.getInstance().get(HiConstant.spStudentId);
  }

  _buildContent() {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: 60,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.item.studentName,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          isSelected || widget.isOneChild ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            width: 60,
            height: 24,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: const Text('当前登录',
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ) : Container()
        ],
      ),
    );
  }

  void switchChild() {
    if (isSelected) {
      showWarnToast("当前已经是所选孩子");
      return;
    }
    confirmAlert(
      context,
      (bool) {
        if (bool) {
          logout();
        }
      },
      tips: '确认要切换到${widget.item.studentName}？',
      okBtn: '确认',
      warmStr: '切换提示',
      isWarm: true,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  logout() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ProfileDao.defaultSet(account:widget.item.account, stduentId: widget.item.studentId);
      PlatformResponse response = await PlatformMethod.logout();
      print("data: ${response.data}");
      EasyLoading.dismiss(animation: false);
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }
}
