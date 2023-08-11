import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_detail_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_item.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/class_transfer_widget.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/oa_two_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class ClassTransferDetailPage extends StatefulWidget {
  final Map params;
  String id;
  int type;

  ClassTransferDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    type = params['type'];
  }

  @override
  _ClassTransferDetailPageState createState() =>
      _ClassTransferDetailPageState();
}

class _ClassTransferDetailPageState extends HiState<ClassTransferDetailPage> {
  ClassTransferDetailModel model = ClassTransferDetailModel();
  String remark = ""; // 审核意见

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// 审批中状态
  bool get isApply {
    if (model == null) {
      return false;
    }
    return model?.status == 1 || model?.status == 3;
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  bool get isApprove {
    return widget.type == 2;
  }

  bool get isNotice {
    return widget.type == 3;
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var kinds = 1;
      if (isApprove) {
        kinds = 1;
      } else if (isNotice) {
        kinds = 2;
      }
      var result = await ClassTransferDao.detail(widget.id, type: widget.type,  kinds: kinds);
      PlatformMethod.sentTriggerUnreadToNative();
      setState(() {
        model = result;
      });
      if (isNotice) {
        read();
      }
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
                hiSpace(height: 14),
                _buildContent(),
                // boxLine(context),
                // _buildDefaultBottom()
              ],
            ),
          ),
        ));
  }

  _buildAppBar() {
    var title = "";
    if (model == null) {
      return;
    }
    if (widget.type == 1) {
      if (isUnSend) {
        title = '删除';
      } else if (isApply) {
        title = '撤销';
      }
    } else if (widget.type == 2) {
      title = "";
      if (model != null && getStatus() == 1) {
        title = "确认";
      }
    }
    return appBar('调课详情', rightTitle: title, rightButtonClick: () {
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      } else if (title == '确认') {
        showApproveDialog();
      }
    });
  }

  getStatus() {
    if (model.approveInfo != null) {
      return model.approveInfo.status;
    }
    return 0;
  }

  showApproveDialog() {
    showCupertinoDialog(context: context, builder: (context) {
      return OAApproveDialog(
          titleTip: '确认',
          tipContent: '请输入确认意见',
          maxLength: 12,
          isShowBottomContent: false, onLeftPress: (String content, String result, String report) {
        approve(content, result, report, 2);
        Navigator.of(context).pop();
      }, onRightPress: (String content, String result, String report) {
        approve(content, result, report, 3);
        Navigator.of(context).pop();
      }, onClosePress: () {
        Navigator.of(context).pop();
      });
    });
  }

  read() async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = model.formId;
      params['status'] = 2;
      params['kinds'] = "2";
      var result = await ClassTransferDao.approve(params);
      EasyLoading.dismiss(animation: false);
      var bus = EventNotice();
      bus.formId = model?.formId;
      eventBus.fire(bus);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  approve(String content, String repairResult, String report, int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['approveRemark'] = content;
      params['formId'] = model.formId;
      params['kinds'] = "1";
      params['status'] = status;
      var result = await ClassTransferDao.approve(params);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = model?.formId;
      eventBus.fire(bus);
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
      var result = await ClassTransferDao.delete(model?.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  revoke() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ClassTransferDao.revoke(model?.id);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Column(
        children: [
          OATwoText('表单编号:', model?.formId, '建立日期:',
              model != null ? dateYearMothAndDay(model?.ddate) : "", isLong: true,),
          OAOneText('计划状态:', buildClassTransferStatus(model?.status)[1],
              contentColor: buildClassTransferStatus(model?.status)[0]),
          boxLine(context),
          hiSpace(height: 12),
          OAOneText('调课原因', '', tipColor: Colors.black, height: 20),
          boxLine(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Text(model.reason ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          boxLine(context),
          hiSpace(height: 12),
          OAOneText(
            '备注',
            '',
            tipColor: Colors.black,
            height: 20,
          ),
          boxLine(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Text(model.remark ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          boxLine(context),
          hiSpace(height: 12),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text('调课通知单', style: TextStyle(fontSize: 13, color: Colors.black)),
          )
        ],
      ),
    );
  }

  _buildContent() {
    if (model == null || model.detailChangeApproveInfoList == null)
      return Container();
    return Column(
        children: model.detailChangeApproveInfoList.map((e) {
      ClassTransferItem item = ClassTransferItem(
        approveId:e.approveId,
        // noticeId: e.kinds == "2" ? e.approveId : "0",
        clazz: e.clazz,
        clazzName: e.clazzName,
        course: e.course,
        courseName: e.courseName,
        approveName: e.approveName,
        type: e.status>=1 ? 2 : 1,
        newDate: e.newDate,
        newNo: e.newNo,
        kinds: e.kinds,
        status: e.status,
        approveDate: e.approveDate,
        newNoName: e.newNo,
        oldDate: e.oldDate,
        oldNo: e.oldNo,
        oldNoName: e.oldNo,
        tealId: e.tealId,
        tealName: e.tealName,
        approveRemark: e.approveRemark,
      );
      return ClassTransferWidget(item: item);
    }).toList());
  }

  _buildDefaultBottom() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('批阅信息:',
              style: TextStyle(fontSize: 13, color: Colors.black)),
          boxLine(context),
          hiSpace(height: 10),
          _buildApply(),
          isUnSend ? OASubmitButton(
              leftText: '保存',
              rightText: '提交',
              onSavePressed: onSavePressed,
              onSubmitPressed: onSubmitPressed) : Container()
        ],
      ),
    );
  }

  _buildApply() {
    List<ChangeInfo> datas = model.detailChangeApproveInfoList;
    if (datas == null || datas.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: datas.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(border: BorderTimeLine(index)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildApproveTop(datas[index]),
                  hiSpace(height: 10),
                  _buildApproveList(datas[index]),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildApproveTop(ChangeInfo approve) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text(approve.kinds == "1" ? '审批人' : '通知人',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            hiSpace(width: 3),
            Text('${approve.deptName}-${approve.approveName}',
                style: const TextStyle(fontSize: 13, color: Colors.black)),
          ],
        )),
        Text(dateYearMothAndDayAndSecend(approve.approveDate?.replaceAll(".000", "")), style: const TextStyle(fontSize: 13, color: Colors.black)),
        hiSpace(width: 3),
        oaClassStatusText(approve.status, kinds: approve.kinds)
      ],
    );
  }

  _buildApproveList(ChangeInfo approve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hiSpace(height: approve.approveRemark.isNotEmpty ? 6 : 0),
        approve.approveRemark.isNotEmpty ? buildRemark(approve.approveRemark ?? '') : Container(),
      ],
    );
  }

  _buildBottom() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('审核意见:',
              style: TextStyle(fontSize: 13, color: Colors.black)),
          hiSpace(height: 8),
          NormalMultiInput(
              hint: '请输入审核意见',
              minLines: 5,
              maxLines: 5,
              margin: 0,
              onChanged: (text) {
                remark = text;
              }),
          OASubmitButton(
              leftText: '同意',
              rightText: '拒绝',
              onSavePressed: onSavePressed,
              onSubmitPressed: onSubmitPressed)
        ],
      ),
    );
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    Map<String, dynamic> params = {};
    params['id'] = model.id;
    params['dDate'] = model.dDate;
    params['reason'] = model.reason;
    params['remark'] = model.remark;
    params['status'] = 0;
    params['changeApproveInfoList'] = [];
    params['appChangeApproveInfoList'] = model.detailChangeApproveInfoList;

    try {
      EasyLoading.show(status: '加载中...');
      var result = await ClassTransferDao.submit(params, isSave: isSave);
      print(result);
      if (result['code'] == 200) {
        showWarnToast(isSave ? '保存成功' : '发布成功');
        EasyLoading.dismiss(animation: false);
        BoostNavigator.instance.pop();
      } else {
        print(result['message']);
        showWarnToast(result['message']);
        EasyLoading.dismiss(animation: false);
      }
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }
}
