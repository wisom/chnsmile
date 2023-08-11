import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/document_dao.dart';
import 'package:chnsmile_flutter/model/document_detail_model.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/oa_two_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/view_util.dart';

class DocumentDetailPage extends StatefulWidget {
  final Map params;
  String id;
  String type; // 从哪个tab进来, "1", "2", "3"
  int reviewStatus;
  bool isFromOA = false;

  DocumentDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    type = params['type'];
    reviewStatus = params['reviewStatus'];
    isFromOA = params['isFromOA'];
  }

  @override
  _DocumentDetailPageState createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends HiState<DocumentDetailPage> {
  DocumentDetailModel model;

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
          color: Colors.white,
          child: RefreshIndicator(
              child: ListView(
                children: [
                  _buildTop(),
                ],
              ),
              onRefresh: loadData),
        ));
  }

  _buildAppBar() {
    var title = "";
    if (widget.type == "1") { // 从申请进来
      if (isUnSend) {
        title = '删除';
      } else if (isApply0) {
        title = '撤销';
      }
    } else {
      if (widget.type == "2") { // 从审批进来
        if (isApply) {
          title = '审批';
        }
      } else { // 通知

      }
    }

    return appBar('公文流转详情', rightTitle: title, rightButtonClick: () {
      if (title == '删除') {
        delete();
      } else if (title == '撤销') {
        revoke();
      } else if (title == '审批') {
        showApproveDialog();
      }
    });
  }

  showApproveDialog() async {
    final result = await BoostNavigator.instance.push('document_approve_page', arguments: {"id": model.id, "formId": model.formId});
    Navigator.of(context).pop();
    loadData();


    // showCupertinoDialog(context: context, builder: (context) {
    //   var params = {"id": model.id, "formId": model.formId};
    //   return DocumentApprovePage(params: params);
    // });

    // showCupertinoDialog(context: context, builder: (context) {
    //   return OAApproveDialog(
    //       isShowBottomContent: false,
    //       onLeftPress: (String content, String result, String report) {
    //     approve(content, result, report, 2);
    //     Navigator.of(context).pop();
    //   }, onRightPress: (String content, String result, String report) {
    //     approve(content, result, report, 3);
    //     Navigator.of(context).pop();
    //   }, onClosePress: () {
    //     Navigator.of(context).pop();
    //   });
    // });
  }

  approve(String content, String repairResult, String report, int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = model?.formId;
      params['repairResult'] = report;
      params['repairReport'] = repairResult;
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await DocumentDao.approve(params);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  read() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DocumentDao.read(model.formId);
      PlatformMethod.sentTriggerUnreadToNative();
      var bus = EventNotice();
      bus.formId = model.formId;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DocumentDao.delete(model.formId);
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
      var result = await DocumentDao.revoke(widget.id);
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
      var result = await DocumentDao.detail(widget.id);
      setState(() {
        model = result;
      });
      if (widget.type == '3') {
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
          OATwoText('表单编号:', model.formId, '发起日期:',
              dateYearMothAndDay(model.ddate),
              isLong: true,
              content1Color: Colors.grey, content2Color: Colors.grey),
          OATwoText('发起人:', model.cname, '状态:',
              buildOAStatus(model.status)[1],
              isLong: true,
              content1Color: Colors.grey,
              content2Color: buildOAStatus(model.status)[0]),
          boxLine(context),
          hiSpace(height: 10),
          OAOneText('文件编号:', model.docId),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('文件标题:${model.title}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          OAOneText('文件内容', '', tipColor: Colors.black),
          boxLine(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 20),
            child: Text(model.content ?? '',
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
          _buildAttach(),
          boxLine(context),
          OAOneText('批阅信息', '', tipColor: Colors.black),
          boxLine(context),
          hiSpace(height: 10),
          _buildApply(),
          isUnSend ? OASubmitButton(
              onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed) : Container(),
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
    if (model == null) {
      showWarnToast("获取数据异常，请关闭当前页面重进");
      return;
    }
    Map<String, dynamic> params = {};
    params['id'] = model.id;
    params['formId'] = model.formId;
    params['remark'] = model.remark;
    params['title'] = model.title;
    params['content'] = model.content;
    params['docId'] = model.docId;
    params['documentApproveInfoList'] = model.approves;
    params['documentEnclosureInfoList'] = model.attachs;

    try {
      EasyLoading.show(status: '加载中...');
      var result = await DocumentDao.submit(params, isSave: isSave);
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildAttach() {
    if (model != null &&
        model.attachs != null &&
        model.attachs.isNotEmpty) {
      return Column(
        children: [
          OAOneText('附件', '', tipColor: Colors.black),
          boxLine(context),
          OAAttachDetail(items: model.attachs)
        ],
      );
    } else {
      return Container();
    }
  }

  _buildApply() {
    List<DocumentApproveInfoList> datas = model.approves;
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

  _buildApproveTop(DocumentApproveInfoList approve) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text(approve.kinds == "1" ? '审批人' : '通知人',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            hiSpace(width: 3),
            Text('[${approve.floor.toString()}] ${approve.approveName}',
                style: const TextStyle(fontSize: 13, color: Colors.black)),
          ],
        )),
        Text(dateYearMothAndDayAndSecend(approve.approveDate?.replaceAll(".000", "")), style: const TextStyle(fontSize: 13, color: Colors.black)),
        hiSpace(width: 3),
        oaStatusText(approve.status, kinds: approve.kinds)
      ],
    );
  }

  _buildApproveList(DocumentApproveInfoList approve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hiSpace(height: approve.approveRemark.isNotEmpty ? 6 : 0),
        approve.approveRemark.isNotEmpty ? buildRemark(approve.approveRemark ?? '') : Container(),
      ],
    );
  }
}
