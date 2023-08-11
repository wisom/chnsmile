import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/attach_list.dart';
import 'package:chnsmile_flutter/widget/level2_text.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/login_button.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class NoticeDetailPage extends StatefulWidget {
  final Map params;
  Notice notice;

  NoticeDetailPage({Key key, this.params}) : super(key: key) {
    notice = params['notice'];
  }

  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends HiState<NoticeDetailPage> {
  @override
  void initState() {
    super.initState();
    // 无需操作 , 未读状态
    if (widget.notice.userOperateType == 0 && widget.notice.readStatus == 0) {
      _onChangeStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('通知详情'),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [_buildTop(), _buildContent(),
              isNeedReed ? _buildButton() : Container()],
          ),
        ));
  }

  // 需要家长点击确认
  bool get isNeedReed {
    return widget.notice.userOperateType == 1;
  }

  // 家长以及确认
  bool get isReed {
    return widget.notice.readStatus == 2;
  }

  _onChangeStatus({int status = 1}) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.noticeChangeStatus(widget.notice.id, status);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = widget.notice.id;
      eventBus.fire(bus);
      print(result);
      EasyLoading.dismiss(animation: false);
      if (isNeedReed) {
        BoostNavigator.instance.pop();
      }
    } on NeedAuth catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LevelText(level: widget.notice?.urgencyType),
          hiSpace(width: 10),
          Expanded(
              child: Text(
                widget.notice?.title ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),

        ],
      ),
    );
  }

  _buildAttach() {
    if (widget.notice != null &&
        widget.notice.attachInfoList != null &&
        widget.notice.attachInfoList.isNotEmpty) {
      return OAAttachDetail(items: widget.notice.attachInfoList);
    } else {
      return Container();
    }
  }

  _buildContent() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        children: [
          Html(data: widget.notice.content),
          _buildAttach(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('发布人:${widget.notice?.publicUserName ?? ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              Text('发布时间:${widget.notice?.publicTime ?? ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  bool get isRead {
    return widget.notice.readStatus == 2;
  }

  _buildButton() {
    return isReed ? Container() : Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: LoginButton("确认已阅读",
          enable: !isRead,
          height: 40, onPressed: _onChangeStatus),
    );
  }
}
