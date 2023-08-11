import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/school_notice_detail2_model.dart';
import 'package:chnsmile_flutter/model/school_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:chnsmile_flutter/widget/level2_text.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class SchoolNoticeDetail2Page extends StatefulWidget {
  final Map params;
  SchoolNotice notice;

  SchoolNoticeDetail2Page({Key key, this.params}) : super(key: key) {
    notice = params['item'];
  }

  @override
  _SchoolNoticeDetail2PageState createState() =>
      _SchoolNoticeDetail2PageState();
}

class _SchoolNoticeDetail2PageState extends HiState<SchoolNoticeDetail2Page> {
  SchoolNoticeDetail2Model model;
  String content;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.schoolNoticeDetail(widget.notice.formId);
      PlatformMethod.sentTriggerUnreadToNative();
      setState(() {
        model = result;
        if (!isReplay) {
          var bus = EventNotice();
          bus.formId = widget.notice.formId;
          eventBus.fire(bus);
        }
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: loadData,
            child: ListView(
              children: [
                _buildTop(),
                hiSpace(height: 10),
                _buildContent(),
                boxLine(context),
                hiSpace(height: 10),
                _buildBottom()
              ],
            ),
          ),
        ));
  }

  String getApproveRemark() {
    if (model != null) {
      return model.approveRemark ?? "";
    }
    return "";
  }

  bool get isOnlyRead {
    return model?.process == 1;
  }

  bool get isReplay {
    return model?.process == 2;
  }

  ///是否已读，已回复
  bool get isReadOrReply {
    if (model == null) {
      return false;
    }
    return model.status == 2;
  }

  _buildAppBar() {
    return appBar('通知详情');
  }

  onSend({bool isRead = false}) async {
    if (!isRead && isEmpty(content)) {
      showWarnToast("请输入回复的内容");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.replay(model?.formId, remark: content);
      PlatformMethod.sentTriggerUnreadToNative();
      if (!isRead) {
        var bus = EventNotice();
        bus.formId = widget.notice.formId;
        eventBus.fire(bus);
        BoostNavigator.instance.pop();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  revoke() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.revoke(model?.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.delete(model?.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  _buildTop() {
    if (model == null) return Container();
    return Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Level2Text(level: model?.grade),
            hiSpace(width: 10),
            Expanded(
                child: Text(
                  model?.title ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ));
  }

  _buildContent() {
    if (model == null) {
      return Container();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hiSpace(height: 6),
          Text(
            model?.content ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          hiSpace(height: 52),
          _buildAttach(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('发布人:${model?.cname ?? ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              Text('发布时间:${model?.releaseDate}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  _buildAttach() {
    if (model != null &&
        model.infoEnclosureList != null &&
        model.infoEnclosureList.isNotEmpty) {
      return OAAttachDetail(items: model.infoEnclosureList);
    } else {
      return Container();
    }
  }

  _buildBottom() {
    print("getApproveRemark(): $getApproveRemark()");
    if (model == null) return Container();
    if (isOnlyRead) {
      return Container();
    } else {
      if (getApproveRemark() != "") {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OAOneText(
                '回复内容：',
                '',
                tipColor: Colors.black,
                height: 26,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 6, right: 10, bottom: 10),
                child: Text(getApproveRemark(),
                    style:
                    const TextStyle(fontSize: 13, color: Colors.black87)),
              ),
              boxLine(context),
            ],
          ),
        );
      } else {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isReadOrReply
                  ? NormalMultiInput(
                  hint: '请输入回复的内容',
                  minLines: 5,
                  maxLines: 5,
                  margin: 0,
                  onChanged: (text) {
                    content = text;
                  })
                  : Container(
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.grey[200], width: 1)),
                child: Text(model?.remark,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black)),
              ),
              hiSpace(height: 20),
              !isReadOrReply
                  ? Row(
                children: [
                  HiButton("回复", bgColor: primary, onPressed: onSend),
                ],
              )
                  : Container()
            ],
          ),
        );
      }
    }
  }
}
