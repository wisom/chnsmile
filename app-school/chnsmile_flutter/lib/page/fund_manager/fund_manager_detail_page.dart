import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/fund_manager_detail.dart';
import 'package:chnsmile_flutter/model/fund_manager_model.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
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
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/fund_manager_dao.dart';
import '../../model/fund_manager_item_param.dart';
import 'fund_manager_detail_card.dart';

class FundManagerDetailPage extends StatefulWidget {
  final Map params;
  FundManager item;
  String type; // 从哪个tab进来, "", "1", "2"
  int reviewStatus; // 审核需要用到
  bool isFromOA = false;
  List<FundManager> classInfo = new List<FundManager>();

  FundManagerDetailPage({Key key, this.params}) : super(key: key) {
    item = params['item'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    isFromOA = params['isFromOA'];
  }

  @override
  _FundManagerDetailPageState createState() => _FundManagerDetailPageState();
}

class _FundManagerDetailPageState extends HiState<FundManagerDetailPage> {
  FundManagerDetail model = FundManagerDetail();

  @override
  void initState() {
    super.initState();
    LogUtil.d("费用申请", "initState");
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
                  _buildContent(model),
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
      if (widget.type == "1") {
        // 从审批进来
        if (isApply) {
          title = '审批';
        }
      } else {
        // 通知

      }
    }

    return appBar('经费申请详情', rightTitle: title, rightButtonClick: () {
      delete();
    });
  }

  bool get isNotice {
    return widget.type == "2";
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
      // params['formId'] = repairModel?.schoolOaRepair?.formId;
      params['status'] = 2;
      params['kinds'] = "2";
      var result = await RepairDao.approve(params);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = widget.item.formId;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  approve(String content, String repairResult, String report,
      int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      // params['formId'] = repairModel?.schoolOaRepair?.formId;
      params['kinds'] = 1;
      params['repairResult'] = repairResult;
      params['repairReport'] = report;
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await RepairDao.approve(params);
      var bus = EventNotice();
      bus.formId = widget.item.formId;
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
      var result = await RepairDao.delete(widget.item.id);
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
      var result = await RepairDao.revoke(widget.item.id);
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
      LogUtil.d("费用申请", " loadData formId=" + widget.item.formId);
      var result = await FundManagerDao.detail(widget.item.formId);
      setState(() {
        model = result;
      });
      // if (isNotice) {
      //   read();
      // }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildTop() {
    SchoolOaRepair schoolOaRepair;
    // SchoolOaRepair schoolOaRepair = repairModel?.schoolOaRepair;
    if (schoolOaRepair == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          OATwoText('表单编号:', schoolOaRepair.formId, '报修日期:',
              dateYearMothAndDay(schoolOaRepair.ddate),
              // isLong: true,
              content1Color: Colors.grey,
              content2Color: Colors.grey),
          OATwoText('报修人:', schoolOaRepair.cname, '报修状态:',
              buildOAStatus(schoolOaRepair.status)[1],
              content1Color: Colors.grey,
              // isLong: true,
              content2Color: buildOAStatus(schoolOaRepair.status)[0]),
          OAOneText('报修部门:', schoolOaRepair.deptName),
          boxLine(context),
          hiSpace(height: 10),
          OATwoText(
            '报修种类:',
            schoolOaRepair.repairKinds,
            '报修物品:',
            schoolOaRepair.repairMer,
            isLong: false,
          ),
          OAOneText('联系方式:', schoolOaRepair.tel),
          OAOneText('E-MAIL:', schoolOaRepair.email),
          OAOneText('报修地址:', schoolOaRepair.repairAddress),
          OAOneText('故障描述', '', tipColor: Colors.black),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Text(schoolOaRepair.content ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          schoolOaRepair.repairResult.isNotEmpty
              ? Column(
            children: [
              OAOneText('维修结果', '', tipColor: Colors.black),
              Container(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: Text(schoolOaRepair.repairResult ?? '',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.grey)),
              ),
            ],
          )
              : Container(),
          schoolOaRepair.repairReport.isNotEmpty
              ? Column(
            children: [
              OAOneText('维修报告', '', tipColor: Colors.black),
              Container(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: Text(schoolOaRepair.repairReport ?? '',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.grey)),
              ),
            ],
          )
              : Container(),
          _buildAttach(),
          boxLine(context),
          OAOneText('批阅信息', '', tipColor: Colors.black),
          hiSpace(height: 10),
          _buildApply(),
          isUnSend && !isNotice
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
    // return repairModel?.schoolOaRepair?.status == 1 ||
    //     repairModel?.schoolOaRepair?.status == 3;
    return false;
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
    // return repairModel?.schoolOaRepair?.status == 0;
    return false;
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    SchoolOaRepair repair;
    // SchoolOaRepair repair = repairModel?.schoolOaRepair;
    if (repair == null) {
      showWarnToast("获取数据异常，请关闭当前页面重进");
      return;
    }
    Map<String, dynamic> params = {};
    params['id'] = repair.id;
    params['cname'] = repair.cname;
    params['dDate'] = repair.ddate;
    params['repairStatus'] = repair.status;
    params['deptName'] = repair.deptName;
    params['repairKinds'] = repair.repairKinds;
    params['repairMer'] = repair.repairMer;
    params['tel'] = repair.tel;
    params['email'] = repair.email;
    params['repairAddress'] = repair.repairAddress;
    params['content'] = repair.content;
    // params['schoolOaRepairApproveList'] = repairModel.schoolOaRepairApproveList;
    params['type'] = repair.type;

    try {
      EasyLoading.show(status: '加载中...');
      var result = await RepairDao.submit(params, isSave: isSave);
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

  _buildAttach() {
    // if (repairModel != null &&
    //     repairModel.schoolOaRepairEnclosureList != null &&
    //     repairModel.schoolOaRepairEnclosureList.isNotEmpty) {
    //   return Column(
    //     children: [
    //       OAOneText('附件', '', tipColor: Colors.black),
    //       boxLine(context),
    //       OAAttachDetail(items: repairModel.schoolOaRepairEnclosureList)
    //     ],
    //   );
    // } else {
    return Container();
    // }
  }

  _buildApply() {
    List<SchoolOaRepairApproveList> datas = new List();
    //     repairModel.schoolOaRepairApproveList;
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

  _buildApproveTop(SchoolOaRepairApproveList approve) {
    return Row(
      children: [
        Expanded(
            child: Row(
              children: [
                Text(approve.kinds == "1" ? '审批人' : '通知人',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                hiSpace(width: 3),
                Text((approve.deptName ?? '') + ' ' + approve.approveName,
                    style: const TextStyle(fontSize: 12, color: Colors.black))
              ],
            )),
        Text(
            dateYearMothAndDayAndSecend(
                approve.approveDate?.replaceAll(".000", "") ??
                    approve.createTime?.replaceAll(".000", "")),
            style: const TextStyle(fontSize: 12, color: Colors.black)),
        hiSpace(width: 3),
        oaStatusText(approve.status, kinds: approve.kinds)
      ],
    );
  }

  _buildApproveList(SchoolOaRepairApproveList approve) {
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
        hiSpace(height: 6),
        approve.repairResult != null && approve.repairResult.isNotEmpty
            ? OAOneText('维修结果: ', approve.repairResult)
            : Container(),
        approve.repairReport != null && approve.repairReport.isNotEmpty
            ? OAOneText('维修报告: ', approve.repairReport)
            : Container(),
      ],
    );
  }

  _buildContent(FundManagerDetail model) {
    return Column(
      children: [
        _buildTopInfo(model),
        _buildDepartment(model),
        _buildRemark(model),
        line(context),
        hiSpace(height: 6),
        line(context),
        _buildApplyDetail(model),
        _buildAttachment(model),
        _buildReadInfo(model)
      ],
    );
  }

  _buildReadInfo(FundManagerDetail model) {
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
        )
      ],
    );
  }

  _buildAttachment(FundManagerDetail model) {
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
        line(context, margin: EdgeInsets.symmetric(horizontal: 14)),
        // OAAttachDetail(
        //     items:
        //         repairModel.schoolOaRepairEnclosureList ?? new List<Attach>()),
        line(context, margin: EdgeInsets.symmetric(horizontal: 14)),
      ],
    );
  }

  _buildTopInfo(FundManagerDetail model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "表单编号：",
                style: TextStyle(fontSize: 14, color: HiColor.color_878B99),
              ),
              Text(
                model.formId ?? "",
                style:
                const TextStyle(fontSize: 14, color: HiColor.color_878B99),
              ),
              const Text(
                "申请日期：",
                style: TextStyle(fontSize: 14, color: HiColor.color_878B99),
              ),
              Text(
                model.createTime ?? "",
                style: const TextStyle(
                    fontSize: 14, color: HiColor.color_878B99),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
            child: Row(
              children: [
                const Text(
                  "发 起 人：",
                  style: TextStyle(fontSize: 14, color: HiColor.color_878B99),
                ),
                Text(
                  "王强军",
                  style: TextStyle(fontSize: 14, color: HiColor.color_878B99),
                ),
                const Text(
                  "申请状态：",
                  style: TextStyle(fontSize: 14, color: HiColor.color_878B99),
                ),
                Text(
                  _buildStates(model.status),
                  style: TextStyle(fontSize: 14, color: HiColor.color_EA0000),
                ),
              ],
            ),
          ),
          line(context)
        ],
      ),
    );
  }

  _buildDepartment(FundManagerDetail model) {
    return Container(
      padding: EdgeInsets.fromLTRB(13, 15, 13, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "部门：",
                style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
              ),
              Text(
                model.orgName ?? "",
                style: TextStyle(fontSize: 12, color: HiColor.color_181717),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),
            child: Row(
              children: [
                const Text(
                  "需求时间：",
                  style:
                  TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
                ),
                Text(
                  model.needDate ?? "",
                  style: TextStyle(fontSize: 12, color: HiColor.color_181717),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "用途",
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

  _buildRemark(FundManagerDetail model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 9, 17, 0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                model.content ?? "",
                textAlign: TextAlign.left,
                style:
                const TextStyle(fontSize: 12, color: HiColor.color_787777),
              )),
          const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 14, 0, 8),
                child: Text(
                  "备注",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: HiColor.color_181717),
                ),
              )),
          line(context),
          hiSpace(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model.remark ?? "",
              style: const TextStyle(fontSize: 12, color: HiColor.color_787777),
            ),
          )
        ],
      ),
    );
  }

  _buildApplyDetail(FundManagerDetail model) {
    return Column(
      children: [
        _buildApplyTitle(),
        line(context),
        _buildApplyList(model.fundItemParamList)
      ],
    );
  }

  _buildApplyTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 7, 0, 7),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "项目申请明细",
            style: TextStyle(
                fontSize: 12,
                color: HiColor.color_181717,
                fontWeight: FontWeight.bold),
          )),
    );
  }

  _buildApplyList(List<FundManagerItemParam> list) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length ?? 0,
        itemBuilder: (BuildContext context, int index) =>
            FundManagerDetailCard(
                item: list[index],
                subItems: list));
  }

  ///状态（0未发送、1批阅中、2已备案、3已拒绝）
  _buildStates(int status) {
     if (status==1) {
       return "批阅中";
    } else if(status==2){
       return "已备案";
    } else if(status==3){
       return "已拒绝";
    } else {
       return "未发送";
    }
  }
}
