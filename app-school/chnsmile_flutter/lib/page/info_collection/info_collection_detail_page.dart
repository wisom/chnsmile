import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/info_collection_dao.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../model/info_collection_detail_model.dart';
import '../../model/info_collection_model.dart';
import '../../widget/empty_view.dart';

class InfoCollectionDetailPage extends StatefulWidget {
  final Map params;
  InfoCollection infoCollection;
  String type; // 从哪个tab进来, "", "1", "2"
  int reviewStatus; // 审核需要用到
  bool isFromOA = false;
  String id;
  String TAG = "InfoCollectionDetailPage==";

  InfoCollectionDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    infoCollection = params['item'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    isFromOA = params['isFromOA'];
  }

  @override
  _InfoCollectionDetailPageState createState() =>
      _InfoCollectionDetailPageState();
}

class _InfoCollectionDetailPageState extends HiState<InfoCollectionDetailPage> {
  InfoCollectionDetailModel model;
  ScrollController scrollController = ScrollController();

  get isLoaded => false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: HiColor.color_F7F7F7,
            child: ListView.builder(
                //使用子控件的总长度来设置ListView的长度（这里的长度为高度）
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10),
                itemCount: model?.messageQuestionResultList?.length ?? 0,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) =>
                    _buildContent(model?.messageQuestionResultList[index]))));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: _buildAppBar(),
  //       body: RefreshIndicator(
  //           child: Container(
  //               width: double.infinity,
  //               height: double.infinity,
  //               color: HiColor.color_F7F7F7,
  //               child:
  //               // _buildInfo(),
  //               (model?.messageQuestionResultList != null &&
  //                   model.messageQuestionResultList.isNotEmpty)
  //                   ? ListView.builder(
  //                   physics: const AlwaysScrollableScrollPhysics(),
  //                   padding: const EdgeInsets.only(top: 10),
  //                   itemCount:
  //                   model?.messageQuestionResultList?.length ?? 0,
  //                   controller: scrollController,
  //                   itemBuilder: (BuildContext context, int index) =>
  //                       _buildContent(
  //                           model?.messageQuestionResultList[index]))
  //                   : isLoaded
  //                   ? Container()
  //                   : EmptyView(onRefreshClick: () {
  //                 loadData();
  //               })
  //             // hiSpaceWithColor(context,
  //             //     color: HiColor.color_F7F7F7, height: 12),
  //             // _buildName(),
  //             // hiSpaceWithColor(context,
  //             //     color: HiColor.color_F7F7F7, height: 12),
  //             // _buildExp(),
  //             // hiSpaceWithColor(context,
  //             //     color: HiColor.color_F7F7F7, height: 12),
  //             // _buildPhone(),
  //             // hiSpaceWithColor(context,
  //             //     color: HiColor.color_F7F7F7, height: 12),
  //             // _buildDetainBtn(),
  //           ),
  //           onRefresh: loadData));
  // }

  _buildContent(MessageQuestionResultList item) {
    LogUtil.d(widget.TAG, "_buildContent=" + item.toString());
    //1 单选 2多选 3填空
    switch (item?.questionType ?? 0) {
      case 1:
        return _buildExp(item);
      case 2:
        return _buildExp(item);
      case 3:
        return _buildName(item);
    }

    return Container();
  }

  _buildAppBar() {
    return appBar('信息采集详情', rightTitle: "", rightButtonClick: () {});
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
    // try {
    //   EasyLoading.show(status: '加载中...');
    //   Map<String, dynamic> params = {};
    //   params['formId'] = model?.schoolOaRepair?.formId;
    //   params['status'] = 2;
    //   params['kinds'] = "2";
    //   var result = await RepairDao.approve(params);
    //   PlatformMethod.sentTriggerUnreadToNative();
    //   var bus = EventNotice();
    //   bus.formId = widget.infoCollection.id;
    //   eventBus.fire(bus);
    //   EasyLoading.dismiss(animation: false);
    // } catch (e) {
    //   EasyLoading.dismiss(animation: false);
    //   showWarnToast(e.message);
    // }
  }

  approve(
      String content, String repairResult, String report, int status) async {
    // try {
    //   EasyLoading.show(status: '加载中...');
    //   Map<String, dynamic> params = {};
    //   params['formId'] = model?.schoolOaRepair?.formId;
    //   params['kinds'] = 1;
    //   params['repairResult'] = repairResult;
    //   params['repairReport'] = report;
    //   params['approveRemark'] = content;
    //   params['status'] = status;
    //   var result = await RepairDao.approve(params);
    //   var bus = EventNotice();
    //   bus.formId = widget.infoCollection.id;
    //   eventBus.fire(bus);
    //   PlatformMethod.sentTriggerUnreadToNative();
    //   BoostNavigator.instance.pop();
    //   EasyLoading.dismiss(animation: false);
    // } catch (e) {
    //   EasyLoading.dismiss(animation: false);
    //   showWarnToast(e.message);
    // }
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await RepairDao.delete(widget.infoCollection.id);
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
      var result = await RepairDao.revoke(widget.infoCollection.id);
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
      var result = await InfoCollectionDao.detail(widget.infoCollection.id);
      setState(() {
        model = result;
        LogUtil.d(widget.TAG, "信息采集 model=" + model.toString());
      });
      if (isNotice) {
        read();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      LogUtil.d(widget.TAG, "信息采集 e=" + e.toString());
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildInfo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      color: Colors.white,
      child: Column(
        children: [
          _buildTop1(),
          hiSpace(height: 12),
          _buildTop2(),
          hiSpace(height: 12),
          _buildTop3(),
          hiSpace(height: 12),
          line(context),
          hiSpace(height: 12),
          _buildTop4(),
          hiSpace(height: 12),
        ],
      ),
    );
  }

  _buildDetainBtn() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 28,
      decoration: BoxDecoration(
        color: HiColor.color_00B0F0,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "导出明细",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  _buildPhone1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "*03.",
              style: TextStyle(
                  fontSize: 14,
                  color: HiColor.color_00B0F0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "手机",
              style: TextStyle(
                  fontSize: 14,
                  color: HiColor.color_181717,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        const Text(
          "必填",
          style: TextStyle(fontSize: 12, color: HiColor.color_5A5A5A),
        )
      ],
    );
  }

  _buildPhone() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: Column(
        children: [
          _buildPhone1(),
          hiSpace(height: 16),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "在上报明细中可查看结果",
              style: TextStyle(fontSize: 12, color: HiColor.color_black_A40),
            ),
          )
        ],
      ),
    );
  }

  _buildExpOther(MessageOptionInfo option) {
    String leftText = option?.optionName ?? "";
    String rightText = (option?.optionSort ?? 0).toString();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style:
                  const TextStyle(fontSize: 14, color: HiColor.color_black_A90),
            ),
            Text(
              rightText,
              style:
                  const TextStyle(fontSize: 14, color: HiColor.color_black_A90),
            )
          ],
        ),
        hiSpace(height: 16)
      ],
    );
  }

  _buildExp1(MessageQuestionResultList item) {
    String options = ""; //1 单选 2多选 3填空
    if (item?.questionType != null) {
      if (item?.questionType == 1) {
        options = "单选";
      } else if (item?.questionType == 2) {
        options = "多选";
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Text(
            (item?.questionSort ?? -1) != -1 ? "*${item?.questionSort}." : "",
            style: const TextStyle(
                fontSize: 14,
                color: HiColor.color_00B0F0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            item?.questionName ?? "",
            style: const TextStyle(
                fontSize: 14,
                color: HiColor.color_181717,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      Row(
        children: [
          Text(
            options,
            style: const TextStyle(fontSize: 12, color: HiColor.color_5A5A5A),
          ),
          hiSpace(width: 11),
          Text(
            (item?.requiredFlag != null && item?.requiredFlag == true)
                ? "必填"
                : "",
            style: const TextStyle(fontSize: 12, color: HiColor.color_5A5A5A),
          )
        ],
      )
    ]);
  }

  _buildExp(MessageQuestionResultList item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      color: Colors.white,
      child: Column(
        children: [
          _buildExp1(item),
          hiSpace(height: 16),
          ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 10),
              itemCount: item?.messageOptionInfoParams?.length ?? 0,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) =>
                  _buildExpOther(item?.messageOptionInfoParams[index]))
        ],
      ),
    );
  }

  _buildName1(MessageQuestionResultList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              (item?.questionSort ?? -1) == -1
                  ? ""
                  : "*${item?.questionSort ?? ""}.",
              style: const TextStyle(
                  fontSize: 14,
                  color: HiColor.color_00B0F0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              item?.questionName ?? "",
              style: const TextStyle(
                  fontSize: 14,
                  color: HiColor.color_181717,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Text(
          (item?.requiredFlag != null && item?.requiredFlag == true)
              ? "必填"
              : "",
          style: const TextStyle(fontSize: 12, color: HiColor.color_5A5A5A),
        )
      ],
    );
  }

  _buildName(MessageQuestionResultList item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      color: Colors.white,
      child: Column(
        children: [
          _buildName1(item),
          hiSpace(height: 16),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "在上报明细中可查看结果",
              style: TextStyle(fontSize: 12, color: HiColor.color_black_A40),
            ),
          )
        ],
      ),
    );
  }

  _buildTop4() {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          "因为学校安全考虑需要大家发一下健康码与个人信息",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, color: HiColor.color_181717_A60),
        ));
  }

  _buildTop3() {
    return Row(
      children: [
        const Text(
          "有效时间：",
          style: TextStyle(fontSize: 10, color: HiColor.color_181717_A50),
        ),
        Text(
          "${dateYearMothAndDayAndMinutes(model?.startTime)}-${dateYearMothAndDayAndMinutes(model?.endTime)}",
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }

  _buildTop2() {
    return Row(
      children: [
        const Text(
          "参与范围：",
          style: TextStyle(fontSize: 10, color: HiColor.color_181717_A50),
        ),
      ],
    );
  }

  _buildTop1() {
    return Row(
      children: [
        Text(
          model?.statisticsName ?? "",
          style: const TextStyle(
              fontSize: 14,
              color: HiColor.color_181717,
              fontWeight: FontWeight.bold),
        ),
        hiSpace(width: 20),
        Container(
            width: 48,
            height: 16,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9.5)),
                color: HiColor.color_00b632_A19),
            child: const Align(
              child: Text(
                "已结束",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 8, color: HiColor.color_00b632_A100),
              ),
              alignment: Alignment.center,
            ))
      ],
    );
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    // SchoolOaRepair repair = model?.schoolOaRepair;
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
    // params['schoolOaRepairApproveList'] = model.schoolOaRepairApproveList;
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
}
