import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/http/dao/school_notice_dao.dart';
import 'package:chnsmile_flutter/model/teacher_notice_detail_model.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/confirm_alert.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class TeacherNoticeDetailPage extends StatefulWidget {
  final Map params;
  String id = "";

  TeacherNoticeDetailPage({Key key, this.params}) : super(key: key) {
    id = params != null ? params['id'] : '';
  }

  @override
  _TeacherNoticeDetailPageState createState() =>
      _TeacherNoticeDetailPageState();
}

class _TeacherNoticeDetailPageState extends HiState<TeacherNoticeDetailPage> {
  TeacherNoticeDetailModel model;
  String content;
  bool isShowRevoke = false;
  bool isShowAll = false;

  bool get isReceive => true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await SchoolNoticeDao.detail(widget.id);
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
          padding: const EdgeInsets.only(top: 0),
          child: RefreshIndicator(
            onRefresh: loadData,
            child: model != null
                ? Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          isRevoke ? _buildRevoke() : Container(),
                          _buildTop(),
                          hiSpace(height: 10),
                          _buildContent(),
                          Container(color: HiColor.common_bg, height: 12),
                          hiSpace(height: 10),
                          _buildBottom()
                        ],
                      )),
                      !isRevoke && haveUnReadNum ? _buildUnRead() : Container()
                    ],
                  )
                : Container(),
          ),
        ));
  }

  /// 未发出状态
  bool get isSave {
    if (model == null) {
      return false;
    }
    return model.status == 0;
  }

  bool get isRevoke {
    if (model == null) {
      return false;
    }
    return model.status == 3;
  }

  ///是否已读，已回复
  bool get isReadOrReply {
    return false;
  }

  _buildRevoke() {
    return Container(
      color: Colors.blue[100],
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.refresh_outlined, size: 22, color: primary),
          hiSpace(width: 10),
          const Text('通知已撤回', style: TextStyle(fontSize: 13, color: primary))
        ],
      ),
    );
  }

  _buildAppBar() {
    var title = '通知详情';
    if (isRevoke) {
      title = '通知撤回';
    }

    return appBar3(title, isShow: !isRevoke, rightButtonClick: () {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text("修改通知内容",
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: (() {
                    BoostNavigator.instance.push('teacher_notice_add_page',
                        arguments: {"id": model.id});
                    Navigator.pop(context, 'Edit');
                    BoostNavigator.instance.pop();
                  }),
                ),
                model!= null && model.hasCancel
                    ? CupertinoActionSheetAction(
                        child: const Text("撤回通知",
                            style: TextStyle(color: Colors.red, fontSize: 15)),
                        onPressed: (() {
                          Navigator.pop(context, 'Cancel');
                          showRevokeDialog();
                        }),
                      )
                    : Container(),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text("取消",
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                isDefaultAction: true,
                onPressed: (() {
                  Navigator.pop(context, 'Cancel');
                }),
              ),
            );
          });
    });
  }

  showRevokeDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text('您可以撤回24小时内发送的通知，确定撤回此通知？',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text("撤回通知",
                    style: TextStyle(color: Colors.red, fontSize: 13)),
                onPressed: (() {
                  revoke(3);
                  Navigator.pop(context, 'Cancel');
                }),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("取消",
                  style: TextStyle(color: Colors.black, fontSize: 13)),
              isDefaultAction: true,
              onPressed: (() {
                Navigator.pop(context, 'Cancel');
              }),
            ),
          );
        });
  }

  onSend() async {
    if (isEmpty(content)) {
      showWarnToast("请输入回复的内容");
      return;
    }
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.replay(model?.formId, remark: content);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  revoke(int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await SchoolNoticeDao.revoke(model?.id, status);
      loadData();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['ids'] = [model?.id];
      var result = await SchoolNoticeDao.delete(params);
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
      Map<String, dynamic> params = {};
      params['formId'] = model?.formId;

      var result = await NoticeDao.teacherRemind(params);
      showWarnToast('已提醒');
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  _buildClassNameWidget() {
    String text = "共${model.noticeUserSum}名家长";
    String text1 = "共${model.noticeUserSum}名家长";
    String allText = '';
    bool isMore = false;
    if (model.classInfoList != null && model.classInfoList.isNotEmpty) {
      if (model.classInfoList.length == 1) {
        allText = text = model.classInfoList[0].className + "," + text;
      } else {
        isMore = true;
        text =
            '${model.classInfoList[0].className}等,共${model.noticeUserSum}名学生家长';
        int index = 0;
        for (var item in model.classInfoList) {
          if (index == model.classInfoList.length - 1) {
            allText += item.className + "," + text1;
          } else {
            allText += item.className + ",";
          }
          index++;
        }
      }
    }
    return Container(
      child: isMore
          ? Expanded(
              child: InkWell(
              onTap: () {
                setState(() {
                  isShowAll = !isShowAll;
                });
              },
              child: isShowAll
                  ? Text('发送给: $allText',
                      textAlign: TextAlign.left,
                      maxLines: 100,
                      style: const TextStyle(fontSize: 13, color: Colors.grey))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          !isShowAll
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('发送给: $text',
                                        textAlign: TextAlign.left,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey)),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 13, color: Colors.grey)
                                  ],
                                )
                              : Container()
                        ]),
            ))
          : Expanded(
              child: Text('发送给: $text',
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ),
    );
  }

  _buildTop() {
    return Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  model?.publicUserName ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '发布时间: ${dateYearMothAndDay(model?.publicTime ?? '')}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    hiSpace(width: 10),
                    LevelText(level: model?.urgencyType)
                  ],
                ))
              ],
            ),
            hiSpace(height: 10),
            Row(
              children: [
                _buildClassNameWidget(),
              ],
            )
          ],
        ));
  }

  _buildContent() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model?.title ?? '',
            style: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          hiSpace(height: 12),
          Html(data: model?.content ?? ''),
          hiSpace(height: 12),
          _buildAttach(),
        ],
      ),
    );
  }

  _buildAttach() {
    if (model != null &&
        model.attachInfoList != null &&
        model.attachInfoList.isNotEmpty) {
      return OAAttachDetail(items: model.attachInfoList);
    } else {
      return Container();
    }
  }

  bool get haveUnReadNum {
    return model.noticeUserUnReadNum != null &&
        int.parse(model.noticeUserUnReadNum) > 0;
  }

  bool get isRead {
    return model.userOperateType == 0;
  }

  getOperateType() {
    return isRead ? '阅读' : '确认';
  }

  _buildUnRead() {
    return InkWell(
        onTap: showRemindDialog,
        child: Container(
          alignment: Alignment.center,
          height: 46,
          color: Colors.grey[200],
          child: Text('提醒家长${getOperateType()}',
              style: const TextStyle(fontSize: 13, color: primary)),
        ));
  }

  _buildBottom() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  haveUnReadNum
                      ? '${model?.noticeUserUnReadNum}名学生家长尚无${getOperateType()}'
                      : '所有学生家长均已${getOperateType()}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Container(
                width: 60,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isRead ? Colors.blue[200] : Colors.orange[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${isRead ? '查看' : '确认'}率',
                        style: TextStyle(
                            fontSize: 11,
                            color: isRead
                                ? Colors.blue[700]
                                : Colors.orange[700])),
                    Text(model?.readRecent ?? '%0',
                        style: TextStyle(
                            fontSize: 11,
                            color: isRead
                                ? Colors.blue[700]
                                : Colors.orange[700])),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: model?.classInfoList?.map((item) {
                  return InkWell(
                    onTap: () {
                      BoostNavigator.instance
                          .push('teacher_notice_read_page', arguments: {
                        "id": model.id,
                        "userOperateType": model.userOperateType,
                        "status": model.status,
                        "classId": item.classId,
                        "className": item.className,
                        "unReadSum": item.unReadSum
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(border: borderLine(context)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.className,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black)),
                              hiSpace(height: 3),
                              Row(
                                children: [
                                  Text(item.unReadSum.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isRead
                                              ? Colors.blue
                                              : Colors.orange)),
                                  Text('人未${getOperateType()}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey))
                                ],
                              )
                            ],
                          )),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.black54)
                        ],
                      ),
                    ),
                  );
                })?.toList() ??
                [],
          )
        ],
      ),
    );
  }

  void showRemindDialog() {
    confirmAlert(
      context,
      (bool) {
        if (bool) {
          remind();
        }
      },
      tips: '将再次发送此通知，提醒未查看家长？',
      okBtn: '发送',
      isWarm: false,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
