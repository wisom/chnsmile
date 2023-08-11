import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/model/attach.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/reimbursement_dao.dart';
import '../../model/reimbursement_detail_model.dart';
import '../../model/reimbursement_model.dart';
import 'Reimbursement_detail_card.dart';

///报销详情
class ReimbursementDetailPage extends StatefulWidget {
  final Map params;
  Reimbursement reimbursement;
  String type;

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  int reviewStatus; // 审核需要用到
  bool isFromOA = false;

  ReimbursementDetailPage({Key key, this.params}) : super(key: key) {
    reimbursement = params['item'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    isFromOA = params['isFromOA'];
  }

  @override
  _ReimbursementDetailPageState createState() =>
      _ReimbursementDetailPageState();
}

class _ReimbursementDetailPageState extends HiState<ReimbursementDetailPage> {
  ReimbursementDetailModel model;
  String formId = "";

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
                  _buildContent(),
                ],
              ),
            ),
            onRefresh: loadData));
  }

  _buildContent() {
    return Column(
      children: [
        _buildTopInfo(model),
        _buildDepartment(model),
        _buildRemark(model),
        hiSpace(height: 6),
        line(context),
        _buildApplyDetail(model),
        _buildAttachment(model),
        _buildReadInfo(model)
      ],
    );
  }

  _buildReadInfo(ReimbursementDetailModel model) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "批阅信息",
              style: TextStyle(
                  fontSize: 12,
                  color: HiColor.color_181717,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        hiSpace(height: 10),
        _buildApply(),
        isUnSend && !isNotice
            ? OASubmitButton(
                onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
            : Container(),
        hiSpace(height: 30)
      ],
    );
  }

  _buildAttachment(ReimbursementDetailModel model) {
    var list = model?.toAttachList() ?? <Attach>[];
    if (list.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "附件",
                style: TextStyle(
                    fontSize: 12,
                    color: HiColor.color_181717,
                    fontWeight: FontWeight.bold),
              ),
            )),
        line(context, margin: const EdgeInsets.symmetric(horizontal: 14)),
        Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 12, 0),
          child: OAAttachDetail(items: list),
        ),
        line(context, margin: const EdgeInsets.symmetric(horizontal: 14)),
      ],
    );
  }

  _buildApplyList(List<ItemList> list) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list?.length ?? 0,
        itemBuilder: (BuildContext context, int index) =>
            ReimbursementDetailCard(item: list[index], subItems: list));
  }

  _buildTotal(List<ItemList> list) {
    var moneyList = list.map((e) => double.parse(e.amount) * e.count);
    var totalMoney = 0.0;
    moneyList.forEach((element) {
      totalMoney = element + totalMoney;
    });
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        decoration: const BoxDecoration(color: HiColor.color_F7F7F7),
        child: Text(
          "全部预计总额：${totalMoney ?? 0.0}",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: HiColor.color_00B0F0,
              fontSize: 14),
        ));
  }

  _buildApplyTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 7, 0, 7),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "报销明细",
            style: TextStyle(
                fontSize: 12,
                color: HiColor.color_181717,
                fontWeight: FontWeight.bold),
          )),
    );
  }

  _buildApplyDetail(ReimbursementDetailModel model) {
    if (model?.itemList == null || model?.itemList.isEmpty) {
      return Container();
    }
    print("_buildApplyDetail==" + (model?.itemList ?? 0).toString());
    return Column(
      children: [
        _buildApplyTitle(),
        line(context),
        _buildApplyList(model?.itemList),
        _buildTotal(model?.itemList)
      ],
    );
  }

  _buildRemark(ReimbursementDetailModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 9, 17, 20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                model?.reimbursementCause ?? "",
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 12, color: HiColor.color_787777),
              )),
        ],
      ),
    );
  }

  _buildDepartment(ReimbursementDetailModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 15, 13, 0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "报销事由",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12,
                    color: HiColor.color_181717,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          line(context)
        ],
      ),
    );
  }

  _buildTopInfo(ReimbursementDetailModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "表单编号：",
                style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
              ),
              Text(
                model?.formId ?? "",
                style:
                    const TextStyle(fontSize: 12, color: HiColor.color_878B99),
              ),
              const Text(
                "申请日期：",
                style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
              ),
              Text(
                dateYearMothAndDay(
                    (model?.createTime ?? "").replaceAll(".000", "")),
                style:
                    const TextStyle(fontSize: 12, color: HiColor.color_878B99),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
            child: Row(
              children: [
                const Text(
                  "发 起 人：",
                  style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
                ),
                Text(
                  model?.createName ?? "",
                  style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
                ),
                const Text(
                  "申请状态：",
                  style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
                ),
                Text(
                  _buildStates(model?.status ?? 0),
                  style: TextStyle(fontSize: 12, color: buildOAStatus(model?.status?? 0)[0]),
                ),
              ],
            ),
          ),
          line(context)
        ],
      ),
    );
  }

  ///状态（0未发送、1批阅中、2已备案、3已拒绝）
  _buildStates(int status) {
    if (status == 1) {
      return "批阅中";
    } else if (status == 2) {
      return "已备案";
    } else if (status == 3) {
      return "已拒绝";
    } else {
      return "未发送";
    }
  }

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  _buildAppBar() {
    var title = "";
    if (widget.type == "1") {
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

    var theme = "";
    if (widget.type == "2") {
      theme = '报销审批详情';
    } else {
      theme = '报销申请详情';
    }

    return appBar(theme, rightTitle: title, rightButtonClick: () {
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      } else if (title == '审批') {
        showApproveDialog();
      }
    });
  }

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  bool get isNotice {
    return widget.type == "3";
  }

  showApproveDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return OAApproveDialog(
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
      params['id'] = model?.id;
      var result = await ReimbursementDao.read(params);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = widget.reimbursement.formId;
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
      params['id'] = model?.id;
      params['reimbursementCause'] = repairResult;
      params['reimbursementDate'] = status;
      params['remark'] = report;
      params['status'] = status;
      var result = await ReimbursementDao.approve(params);
      var bus = EventNotice();
      bus.formId = widget.reimbursement.formId;
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
      var result = await ReimbursementDao.delete(widget.reimbursement.id);
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
      var result = await ReimbursementDao.revoke(widget.reimbursement.id);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  Future<void> loadData() async {
    try {
      print("reimbursement detail==start");
      EasyLoading.show(status: '加载中...');
      var result = await ReimbursementDao.detail(widget.reimbursement.formId);
      setState(() {
        model = result;
      });
      if (isNotice) {
        read();
      }
      EasyLoading.dismiss(animation: false);
      print("reimbursement detail==end");
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print("reimbursement detail== e" + e);
      showWarnToast(e.message);
    }
  }

  ///状态（0未发送、1批阅中、2已备案、3已拒绝）
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
    if (!isSave) {
      params['formId'] = formId;
    }
    params['id'] = model.id;
    params['reimbursementCause'] = model.reimbursementCause;
    params['reimbursementDate'] = model.reimbursementDate;
    params['reimbursementPersonId'] = model.reimbursementPersonId;
    params['reimbursementPersonName'] = model.reimbursementPersonName;
    params['remark'] = model.remark;
    params['status'] = model.status;
    params['claimApproveList'] = model.claimApproveList;
    params['itemList'] = model.itemList;
    params['accessoryList'] = model.accessoryList;

    try {
      EasyLoading.show(status: '加载中...');
      var result = await ReimbursementDao.submit(params, isSave: isSave);
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
    List<ClaimApproveList> datas = model?.claimApproveList;
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(border: BorderTimeLine(index)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
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

  _buildApproveTop(ClaimApproveList approve) {
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
                approve.approveTime?.replaceAll(".000", "") ??
                    approve.createTime?.replaceAll(".000", "")),
            style: const TextStyle(fontSize: 12, color: Colors.black)),
        hiSpace(width: 3),
        oaStatusText(approve.status, kinds: (approve.kinds).toString())
      ],
    );
  }

_buildApproveList(ClaimApproveList approve) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      hiSpace(height: approve.approveRemark != null && approve.approveRemark.isNotEmpty ? 6 : 0),
      approve.approveRemark != null && approve.approveRemark.isNotEmpty ? buildRemark(approve.approveRemark ?? '') : Container(),
      hiSpace(height: 6),
    ],
  );
}
}
