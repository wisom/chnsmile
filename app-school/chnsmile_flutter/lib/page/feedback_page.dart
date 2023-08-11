import 'package:chnsmile_flutter/http/dao/feedback_dao.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';

class FeedbackPage extends StatefulWidget {

  final Map params;
  bool isFromChat = false;

  FeedbackPage({Key key, this.params}) : super(key: key) {
    isFromChat = params.isNotEmpty ? params['isFromChat']: false;
  }

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fix键盘把下面顶起的问题
      resizeToAvoidBottomInset: false,
      appBar:
      appBar(widget.isFromChat ? "举报": "意见反馈", rightTitle: "提交", rightButtonClick: rightButtonClick),
      body: Container(
        color: Colors.white,
        height: 220,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: NormalMultiInput(
          margin: 0,
            hint: widget.isFromChat ? '请输入举报内容' : '请输入反馈内容',
            minLines: 15,
            maxLines: 15,
            onChanged: (text) {
              content = text;
            }),
      ),
    );
  }

  void rightButtonClick() async {
    if (isEmpty(content)) {
      showWarnToast("内容不能为空");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['content'] = content;

      var result = await FeedbackDao.submit(params);
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
