import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
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

import '../../http/dao/fund_manager_dao.dart';
import '../../model/fund_manager_approve.dart';
import '../../model/fund_manager_detail.dart';
import '../../model/fund_manager_item_param.dart';
import '../../model/fund_manager_model.dart';
import '../../widget/oa_fund_manager_approve_dialog.dart';
import '../../widget/oa_one_text_wrap.dart';

class FundDetailPage extends StatefulWidget {
  final Map params;
  FundManager fund;
  String type; // 1=经费申请、2=经费审批、3=收到通知
  int reviewStatus = 0; // 审核需要用到
  bool isFromOA = false;
  String TAG = "FundDetailPage==";

  FundDetailPage({Key key, this.params}) : super(key: key) {
    fund = params['item'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    // isFromOA = params['isFromOA'];
  }

  @override
  _FundDetailPageState createState() => _FundDetailPageState();
}

class _FundDetailPageState extends HiState<FundDetailPage> {
  FundManagerDetail model;

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
                  line(context),
                  _buildDetail(),
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

  ///1=经费申请、2=经费审批、3=收到通知
  String _getTitle() {
    if (widget.type == "1") {
      return '经费申请详情';
    } else {
      return "经费审批详情";
    }
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
      var result = await FundManagerDao.read(params);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = widget.fund.formId;
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
      params['id'] = model?.id ?? "";
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await FundManagerDao.approve(params);
      var bus = EventNotice();
      bus.formId = widget.fund.formId;
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
      var result = await FundManagerDao.delete(widget.fund.id);
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
      var result = await FundManagerDao.revoke(widget.fund.id);
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
      var result = await FundManagerDao.detail(widget.fund.formId ?? "");
      setState(() {
        model = result;
      });
      if (isNotice) {
        read();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      LogUtil.d(widget.TAG, "fund_detail e=" + e.toString());
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildDetail() {
    return Container(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: const [
                Text(
                  '项目申请明细',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: HiColor.color_181717,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
        line(context),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model?.fundItemParamList?.length ?? 0,
            itemBuilder: (context, index) {
              return Column(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      OATwoText(
                          '项目名称：',
                          model?.fundItemParamList[index]?.expendName ??
                              "",
                          // "",
                          '单        位：',
                          model?.fundItemParamList[index]?.unit ?? "",
                          content1Color: HiColor.color_00B0F0,
                          content2Color: HiColor.color_181717),
                      OATwoText(
                          '购买数量：',
                          (model?.fundItemParamList[index]?.count ?? 0.0)
                              .toString(),
                          '物品单价：',
                          (model?.fundItemParamList[index]?.price ?? 0.0)
                              .toString(),
                          content1Color: HiColor.color_181717,
                          content2Color: HiColor.color_181717),
                      boxLine(context),
                      OAOneText(
                        "单项预计总额：",
                        (model?.fundItemParamList[index]?.amount ?? 0.0)
                            .toString(),
                        contentColor: HiColor.color_181717,
                      )
                    ])),
                line(context)
              ]);
            }),
      ],
    ));
  }

  _buildBottom() {
    List<FundManagerItemParam> schoolOaRepair = model?.fundItemParamList;
    if (schoolOaRepair == null) {
      return Container();
    }
    return Container(
        child: Column(
      children: [
        _buildAttach(),
        _buildTotal(),
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

  _buildTotal() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        decoration: const BoxDecoration(color: HiColor.color_F7F7F7),
        child: Text(
          "全部预计总额：${model?.budget ?? 0.0}",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: HiColor.color_00B0F0,
              fontSize: 14),
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
              dateYearMothAndDay(model.createTime),
              // isLong: true,
              content1Color: Colors.grey,
              content2Color: Colors.grey),
          OATwoText('发  起  人:', model.createName ?? "", '申请状态:',
              buildOAStatus(model.status)[1],
              content1Color: Colors.grey,
              // isLong: true,
              content2Color: buildOAStatus(model.status)[0]),
          boxLine(context),
          OAOneText('部        门:    ', model.orgName ?? ""),
          OAOneText(
            '需求时间:    ',
            model.needDate ?? "",
          ),
          OAOneText('用途', "",
              tipColor: HiColor.color_181717, tipFontWeight: FontWeight.bold),
          line(context),
          hiSpace(height: 8),
          OAOneTextWrap(
            '',
            model.content ?? "",
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
    // FundManagerDetail repair = model;
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

  _buildAttach() {
    if (model != null &&
        model.fundApplyAccessoryParamList != null &&
        model.fundApplyAccessoryParamList.isNotEmpty) {
      return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              OAOneText('附件', '', tipColor: Colors.black),
              boxLine(context),
              hiSpace(height: 10),
              OAAttachDetail(items: model.toAttachList())
            ],
          ));
    } else {
      return Container();
    }
  }

  _buildApply() {
    // List<SchoolOaRepairApproveList> datas =
    //     model.schoolOaRepairApproveList;
    List<FundManagerApprove> datas = model?.fundClaimApproveParamList;
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
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
            }));
  }

  _buildApproveTop(FundManagerApprove approve) {
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

  _buildApproveList(FundManagerApprove approve) {
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
