import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/school_notice_detail_model.dart';
import 'package:chnsmile_flutter/model/school_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:chnsmile_flutter/widget/level2_text.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class SchoolNoticeDetailPage extends StatefulWidget {
  final Map params;
  SchoolNotice notice;

  SchoolNoticeDetailPage({Key key, this.params}) : super(key: key) {
    notice = params['item'];
  }

  @override
  _SchoolNoticeDetailPageState createState() => _SchoolNoticeDetailPageState();
}

class _SchoolNoticeDetailPageState extends HiState<SchoolNoticeDetailPage> {
  SchoolNoticeDetailModel model;
  String content;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.detail(widget.notice.formId);
      setState(() {
        model = result;
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
                _buildTop0(),
                hiSpace(height: 10),
                _buildTop(),
                hiSpace(height: 10),
                _buildContent(),
                boxLine(context),
                hiSpace(height: 10),
                isUnSend
                    ? OASubmitButton(
                    onSavePressed: onSavePressed,
                    onSubmitPressed: onSubmitPressed)
                    : _buildBottom(),
              ],
            ),
          ),
        ));
  }

  getTop0String() {
    if (model.infoApproveList != null && model.infoApproveList.isNotEmpty) {
      var first = model.infoApproveList[0].approveName;
      return "$first等，共${model.total}名老师";
    }
    return "共${model.total}名老师";
  }

  _buildTop0() {
    if (model == null) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('发送给: ',
            style: TextStyle(
                fontSize: 13, color: Colors.grey)),
        Text(getTop0String(),
            style: const TextStyle(
                fontSize: 13, color: primary))
      ],
    );
  }

  String getApproveRemark() {
    if (model.infoApproveList != null && model.infoApproveList.isNotEmpty) {
      for (var item in model.infoApproveList) {
        if (item.approveId == getUserId()) {
          return item.approveRemark;
        }
      }
    }
    return null;
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (model == null) {
      showWarnToast("获取数据异常，请关闭当前页面重进");
      return;
    }

    Map<String, dynamic> params = {};
    params['formId'] = model.formId;
    params['title'] = model.title;
    params['content'] = model.content;
    params['grade'] = model.grade;
    params['process'] = model.process;
    params['infoApproveList'] = model.infoApproveList;
    params['infoEnclosureList'] = model.infoEnclosureList;

    var result = await NoticeDao.submit(params, isSave: isSave);
    showWarnToast(isSave ? '保存成功' : '发布成功');
    EasyLoading.dismiss(animation: false);
    BoostNavigator.instance.pop();
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  bool get isOnlyRead {
    return model?.process == 1;
  }

  /// 未发出状态
  bool get isSave {
    return model?.status == 0;
  }

  _buildAppBar() {
    var title = isSave ? '删除' : '撤销';

    return appBar('通知详情', rightTitle: title, rightButtonClick: () {
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      }
    });
  }

  onSend({bool isRead = false}) async {
    if (!isRead && isEmpty(content)) {
      showWarnToast("请输入回复的内容");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.replay(model?.formId, remark: content);
      if (!isRead) {
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

  remind() async {
    try {
      EasyLoading.show(status: '加载中...');
      List approveIdList = [];
      for (var item in model.notReplyList) {
        approveIdList.add(item.approveId);
      }

      Map<String, dynamic> params = {};
      params['formId'] = model?.formId;
      params['approveIdList'] = approveIdList;

      var result = await NoticeDao.remind(params);
      showWarnToast("提醒成功");
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
    if (model == null) return Container();
    return !isOnlyRead && model.notReplyCount != null && model.notReplyCount > 0
        ? Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${model?.notReplyCount}名教师尚无${isOnlyRead?'阅读':'回复'}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              InkWell(
                  onTap: remind,
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 24,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('提醒教师回复',
                        style: TextStyle(
                            fontSize: 12, color: Colors.white)),
                  ))
            ],
          ),
          Column(
            children: model?.notReplyList?.map((item) {
              return Container(
                height: 42,
                alignment: Alignment.centerLeft,
                decoration:
                BoxDecoration(border: borderLine(context)),
                child: Text(item.approveName,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black)),
              );
            })?.toList() ??
                [],
          )
        ],
      ),
    ) : Container();
  }

}