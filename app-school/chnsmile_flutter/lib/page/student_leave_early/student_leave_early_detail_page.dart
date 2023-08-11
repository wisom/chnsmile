import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/oa_two_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/student_leave_early_dao.dart';
import '../../model/student_leave_early_approve.dart';
import '../../model/student_leave_early_detail.dart';
import '../../model/student_leave_early_model.dart';
import '../../widget/oa_fund_manager_approve_dialog.dart';
import '../../widget/oa_one_text_wrap.dart';

class StudentLeaveEarlyDetailPage extends StatefulWidget {
  final Map params;
  StudentLeaveEarly leave;
  String type; //列表类型 1.早退申报；2.早退审批；3.收到通知；
  int reviewStatus = 0; // 审核需要用到
  bool isFromOA = false;
  String TAG = "StudentLeaveEarlyDetailPage==";

  StudentLeaveEarlyDetailPage({Key key, this.params}) : super(key: key) {
    leave = params['item'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    // isFromOA = params['isFromOA'];
  }

  @override
  _StudentLeaveEarlyDetailPageState createState() => _StudentLeaveEarlyDetailPageState();
}

class _StudentLeaveEarlyDetailPageState extends HiState<StudentLeaveEarlyDetailPage> {
  StudentLeaveEarlyDetail model;

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
                  _buildBottom()
                ],
              ),
            ),
            onRefresh: loadData));
  }

  _buildAppBar() {
    var title = "";
    if (isEmpty(widget.type)) {
      // 从申请进来
      if (isUnSend) {
        title = '删除';
      } else if (isApply0) {
        title = '撤销';
      }
    } else {
      if (widget.type == "2") {
        // 从审批进来
        if (isApply) {
          title = '审批';
        }
      } else {
        // 通知
      }
    }

    return appBar(_getTitle(), rightTitle: _getTitleRightText(),
        rightButtonClick: () {
      LogUtil.d(widget.TAG, "fund_detail title=" + title);
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      } else if (title == '审批') {
        LogUtil.d(widget.TAG, "fund_detail showApproveDialog=");
        showApproveDialog();
      } else if (title == '打印') {}
    });
  }

  String _getTitle() {
      return "早退审批";
  }

  String _getTitleRightText() {
    if (widget.type == "1") {
      if (isUnSend) {
        return '删除';
      } else if (isApply0) {
        return '撤销';
      }
    } else if (widget.type == "2") {
      if (isApply) {
        return '审批';
      }
    } else if (widget.type == "3") {
      return "";
    }
    return "";
  }

  bool get isNotice {
    return widget.type == "3";
  }

  showApproveDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return OAFundManagerApproveDialog(
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
      Map<String, dynamic> params = {};
      params['id'] = model?.id ?? "";
      // params['approveRemark'] = model?.id ?? "";
      // params['formId'] = model?.id ?? "";
      // params['status'] = model?.id ?? "";
      var result = await StudentLeaveEarlyDao.read(params);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = widget.leave.formId;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  ///status 2已批/已读、3拒
  approve(
      String content, String repairResult, String report, int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = model?.formId ?? "";
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await StudentLeaveEarlyDao.approve(params);
      var bus = EventNotice();
      bus.formId = widget.leave.formId;
      eventBus.fire(bus);
      PlatformMethod.sentTriggerUnreadToNative();
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
      var result = await StudentLeaveEarlyDao.delete(widget.leave.id);
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
      var result = await StudentLeaveEarlyDao.revoke(widget.leave.id);
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
      var result = await StudentLeaveEarlyDao.detail(widget.leave.formId ?? "");
      setState(() {
        model = result;
      });
      if (isNotice) {
        read();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      LogUtil.d(widget.TAG, "StudentLeaveEarly e=" + e.toString());
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildBottom() {
    // List<FundManagerItemParam> schoolOaRepair = model?.fundItemParamList;
    // if (schoolOaRepair == null) {
    //   return Container();
    // }
    return Container(
        child: Column(
      children: [
        // _buildAttach(),
        line(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: OAOneText('批阅信息', '',
              tipColor: Colors.black, tipFontWeight: FontWeight.bold),
        ),
        hiSpace(height: 10),
        _buildApply(),
        isUnSend && !isNotice
            ? OASubmitButton(
                onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
            : Container(),
        hiSpace(height: 30)
      ],
    ));
  }

  _buildTop() {
    if (model == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          OATwoText('表单编号:', model.formId ?? "", '申请日期:',
              dateYearMothAndDay(widget.leave.createTime),
              // isLong: true,
              content1Color: Colors.grey,
              content2Color: Colors.grey),
          OATwoText('申  请  人:', model.earlyStudentName ?? "", '状态:',
              buildOAStatus(model.status)[1],
              content1Color: Colors.grey,
              // isLong: true,
              content2Color: buildOAStatus(model.status)[0]),
          boxLine(context),
          OAOneText('早退类型:    ', model.earlyType==1 ? "代理":"代理"),
          OAOneText(
            '早退者:    ',
            model.earlyStudentName ?? "",
          ),
          OAOneText(
            '早退时间:    ',
            model.dateStart ?? "",
          ),
          OAOneText('早退事由', "",
              tipColor: HiColor.color_181717, tipFontWeight: FontWeight.bold),
          line(context),
          hiSpace(height: 8),
          OAOneTextWrap(
            '',
            model.reason ?? "",
            contentColor: HiColor.color_181717_A50,
          ),
          OAOneText('备注', "",
              tipColor: HiColor.color_181717, tipFontWeight: FontWeight.bold),
          line(context),
          OAOneText('', model.remark ?? ""),
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

  /// 审批中状态 （0未发送、1批阅中、2已备案、3已拒绝）
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
    // StudentLeaveDetail repair = model;
    // if (repair == null) {
    //   showWarnToast("获取数据异常，请关闭当前页面重进");
    //   return;
    // }
    // Map<String, dynamic> params = {};
    // params['id'] = repair.id;
    // params['cname'] = repair.cname;
    // params['dDate'] = repair.ddate;
    // params['repairStatus'] = repair.status;
    // params['deptName'] = repair.deptName;
    // params['repairKinds'] = repair.repairKinds;
    // params['repairMer'] = repair.repairMer;
    // params['tel'] = repair.tel;
    // params['email'] = repair.email;
    // params['repairAddress'] = repair.repairAddress;
    // params['content'] = repair.content;
    // params['schoolOaRepairApproveList'] = model.fundClaimApproveParamList;
    // params['type'] = repair.type;
    //
    // try {
    //   EasyLoading.show(status: '加载中...');
    //   var result = await RepairDao.submit(params, isSave: isSave);
    //   print(result);
    //   if (result['code'] == 200) {
    //     showWarnToast(isSave ? '保存成功' : '发布成功');
    //     EasyLoading.dismiss(animation: false);
    //     BoostNavigator.instance.pop();
    //   } else {
    //     print(result['message']);
    //     showWarnToast(result['message']);
    //     EasyLoading.dismiss(animation: false);
    //   }
    // } catch (e) {
    //   print(e);
    //   showWarnToast(e.message);
    //   EasyLoading.dismiss(animation: false);
    // }
  }

  // _buildAttach() {
  //   if (model != null &&
  //       model.fundApplyAccessoryParamList != null &&
  //       model.fundApplyAccessoryParamList.isNotEmpty) {
  //     return Container(
  //         padding: const EdgeInsets.all(10),
  //         child: Column(
  //           children: [
  //             OAOneText('附件', '', tipColor: Colors.black),
  //             boxLine(context),
  //             hiSpace(height: 10),
  //             OAAttachDetail(items: model.toAttachList())
  //           ],
  //         ));
  //   } else {
  //     return Container();
  //   }
  // }

  _buildApply() {
    // List<SchoolOaRepairApproveList> datas =
    //     model.schoolOaRepairApproveList;
    List<StudentLeaveEarlyApprove> datas = model?.studentEarlyApproveList;
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: datas?.length??0,
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
            }));
  }

  _buildApproveTop(StudentLeaveEarlyApprove approve) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text(approve.kinds == "1" ? '审批人' : '通知人',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            hiSpace(width: 3),
            Text((approve.orgName ?? '') + ' ' + approve.approveName,
                style: const TextStyle(fontSize: 12, color: Colors.black))
          ],
        )),
        Text(
            dateYearMothAndDayAndSecend(
                approve.approveDate?.replaceAll(".000", "") ?? ""),
            style: const TextStyle(fontSize: 12, color: Colors.black)),
        hiSpace(width: 3),
        oaStatusText(approve.status, kinds: approve.kinds)
      ],
    );
  }

  _buildApproveList(StudentLeaveEarlyApprove approve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hiSpace(
            height: approve.approveRemark != null &&
                    approve.approveRemark.isNotEmpty
                ? 6
                : 0),
        approve.approveRemark != null && approve.approveRemark.isNotEmpty
            ? buildRemark(approve.approveRemark ?? '')
            : Container(),
        // hiSpace(height: 6),
        // approve.repairResult != null && approve.repairResult.isNotEmpty
        //     ? OAOneText('维修结果: ', approve.repairResult)
        //     : Container(),
        // approve.repairReport != null && approve.repairReport.isNotEmpty
        //     ? OAOneText('维修报告: ', approve.repairReport)
        //     : Container(),
      ],
    );
  }
}
