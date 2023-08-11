import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/vacation_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vacation_detail_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/oa_two_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/view_util.dart';

class VacationDetailPage extends StatefulWidget {
  final Map params;
  String id;
  int type; // 从哪个tab进来, 1, 2, 3
  int reviewStatus; // 审核需要用到
  bool isFromOA = false;

  VacationDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    isFromOA = params['isFromOA'];
  }

  @override
  _VacationDetailPageState createState() => _VacationDetailPageState();
}

class _VacationDetailPageState extends HiState<VacationDetailPage> {
  VacationDetailModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: RefreshIndicator(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  _buildTop(),
                ],
              ),
            ),
            onRefresh: loadData));
  }

  _buildAppBar() {
    var title = "";
    if (widget.type == 1) {
      // 从申请进来
      if (isUnSend) {
        title = '删除';
      } else if (isApply0) {
        title = '撤销';
      }
    } else {
      if (widget.type == 2) {
        // 从审批进来
        if (isApply) {
          title = '审批';
        }
      } else {
        // 通知

      }
    }

    return appBar('请假审批详情', rightTitle: title, rightButtonClick: () {
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      } else if (title == '审批') {
        showApproveDialog();
      }
    });
  }

  showApproveDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return OAApproveDialog(
              isShowBottomContent: false,
              onLeftPress: (String content, String result, String report) {
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
      var result = await VacationDao.read(model.formId);
      var bus = EventNotice();
      bus.formId = model?.formId;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  approve(
      String content, String repairResult, String report, int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = model?.formId;
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await VacationDao.approve(params);
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
      var result = await VacationDao.delete(model.formId);
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
      var result = await VacationDao.revoke(widget.id);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await VacationDao.detail(widget.id);
      PlatformMethod.sentTriggerUnreadToNative();
      setState(() {
        model = result;
      });
      if (widget.type == 3) {
        read();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildTop() {
    if (model == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          OATwoText('表单编号:', model.formId, '申请日期:',
              dateYearMothAndDay(model.ddate.replaceAll(".000", "")),
              isLong: true,
              content1Color: Colors.grey, content2Color: Colors.grey),
          OATwoText('申请人:', model.applyName, '状态:',
              buildOAStatus(model.status)[1],
              content1Color: Colors.grey,
              isLong: true,
              content2Color: buildOAStatus(model.status)[0]),
          boxLine(context),
          hiSpace(height: 10),
          OATwoText('申请种类:', model.applyKinds, '请假类型:', model.kinds, isLong: true,),
          OATwoText('请假人:', model.leaveName, '请假时间:', model.hours.toString(), isLong: true,),
          OAOneText('请假事由', '', tipColor: Colors.black),
          boxLine(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 20),
            child: Text(model.reason ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          OAOneText('备注', '', tipColor: Colors.black),
          boxLine(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 20),
            child: Text(model.remark ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          boxLine(context),
          OAOneText('批阅信息', '', tipColor: Colors.black),
          boxLine(context),
          hiSpace(height: 10),
          _buildApply(),
          isUnSend
              ? OASubmitButton(
                  onSavePressed: onSavePressed,
                  onSubmitPressed: onSubmitPressed)
              : Container(),
          hiSpace(height: 30)
        ],
      ),
    );
  }

  /// 审批中状态
  bool get isApply0 {
    if (model == null) {
      return false;
    }
    return model?.status == 1 || model?.status == 3;
  }

  /// 审批中状态
  bool get isApply {
    if (widget.reviewStatus == null) {
      return false;
    }
    return widget.reviewStatus == 1;
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    Map<String, dynamic> params = {};
    params['formId'] = model.formId;
    params['dateEnd'] = model.dateEnd;
    params['dateStart'] = model.dateStart;
    params['hours'] = model.hours;
    params['kinds'] = model.kinds;
    params['applyId'] = model.applyId;
    params['leaveId'] = model.leaveId;
    params['reason'] = model.reason;
    params['remark'] = model.remark;
    params['status'] = model.status;
    params['applyKinds'] = model.applyKinds;
    params['approveInfoList'] = model.approveInfoList;

    try {
      EasyLoading.show(status: '加载中...');
      var result = await VacationDao.submit(params, isSave: isSave);
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

  _buildApply() {
    List<ApproveInfoList> datas = model.approveInfoList;
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

  _buildApproveTop(ApproveInfoList approve) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text(approve.kinds == "1" ? '审批人' : '通知人',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            hiSpace(width: 2),
            Text((approve.orgName ?? '') + ' ' + (approve.approveName ?? ''),
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          ],
        )),
        Text(dateYearMothAndDayAndSecend(approve.approveDate?.replaceAll(".000", "")), style: const TextStyle(fontSize: 12, color: Colors.black)),
        hiSpace(width: 3),
        oaStatusText(approve.status, kinds: approve.kinds)
      ],
    );
  }

  _buildApproveList(ApproveInfoList approve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        approve.approveRemark.isNotEmpty ? buildRemark(approve.approveRemark ?? '') : Container(),
      ],
    );
  }
}
