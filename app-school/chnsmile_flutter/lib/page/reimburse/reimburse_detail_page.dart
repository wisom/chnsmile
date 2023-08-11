// import 'package:chnsmile_flutter/core/hi_state.dart';
// import 'package:chnsmile_flutter/core/platform_method.dart';
// import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
// import 'package:chnsmile_flutter/model/event_notice.dart';
// import 'package:chnsmile_flutter/model/repair_detail_model.dart';
// import 'package:chnsmile_flutter/model/repair_model.dart';
// import 'package:chnsmile_flutter/utils/common.dart';
// import 'package:chnsmile_flutter/utils/format_util.dart';
// import 'package:chnsmile_flutter/utils/hi_toast.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:chnsmile_flutter/widget/appbar.dart';
// import 'package:chnsmile_flutter/widget/border_time_line.dart';
// import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
// import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
// import 'package:chnsmile_flutter/widget/oa_one_text.dart';
// import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
// import 'package:chnsmile_flutter/widget/oa_two_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_boost/flutter_boost.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hi_base/string_util.dart';
// import 'package:hi_base/view_util.dart';
//
// class ReimburseDetailPage extends StatefulWidget {
//   final Map params;
//   Repair repair;
//   String type; // 从哪个tab进来, "", "1", "2"
//   int reviewStatus; // 审核需要用到
//   bool isFromOA = false;
//
//   ReimburseDetailPage({Key key, this.params}) : super(key: key) {
//     repair = params['item'];
//     type = params['type'];
//     reviewStatus = params['reviewStatus'];
//     isFromOA = params['isFromOA'];
//   }
//
//   @override
//   _RepairDetailPageState createState() => _RepairDetailPageState();
// }
//
// class _RepairDetailPageState extends HiState<ReimburseDetailPage> {
//   RepairDetailModel repairModel;
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: _buildAppBar(),
//         body: RefreshIndicator(
//             child: Container(
//               color: Colors.white,
//               child: ListView(
//                 children: [
//                   _buildTop(),
//                 ],
//               ),
//             ),
//             onRefresh: loadData));
//   }
//
//   _buildAppBar() {
//     var title = "";
//     if (isEmpty(widget.type)) { // 从申请进来
//       if (isUnSend) {
//         title = '删除';
//       } else if (isApply0) {
//         title = '撤销';
//       }
//     } else {
//       if (widget.type == "1") { // 从审批进来
//         if (isApply) {
//           title = '审批';
//         }
//       } else { // 通知
//
//       }
//     }
//
//     return appBar('报销申请详情', rightTitle: title, rightButtonClick: () {
//       if (title == '删除') {
//         delete();
//       } else if (title == '撤销') {
//         revoke();
//       } else if (title == '审批') {
//         showApproveDialog();
//       }
//     });
//   }
//
//   bool get isNotice {
//     return widget.type == "2";
//   }
//
//   showApproveDialog() {
//     showCupertinoDialog(context: context, builder: (context) {
//       return OAApproveDialog(onLeftPress: (String content, String result, String report) {
//         approve(content, result, report, 2);
//         Navigator.of(context).pop();
//       }, onRightPress: (String content, String result, String report) {
//         approve(content, result, report, 3);
//         Navigator.of(context).pop();
//       }, onClosePress: () {
//         Navigator.of(context).pop();
//       });
//     });
//   }
//
//
//   read() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       Map<String, dynamic> params = {};
//       params['formId'] = repairModel?.schoolOaRepair?.formId;
//       params['status'] = 2;
//       params['kinds'] = "2";
//       var result = await RepairDao.approve(params);
//       PlatformMethod.sentTriggerUnreadToNative();
//       var bus = EventNotice();
//       bus.formId = widget.repair.formId;
//       eventBus.fire(bus);
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   approve(String content, String repairResult, String report, int status) async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       Map<String, dynamic> params = {};
//       params['formId'] = repairModel?.schoolOaRepair?.formId;
//       params['kinds'] = 1;
//       params['repairResult'] = repairResult;
//       params['repairReport'] = report;
//       params['approveRemark'] = content;
//       params['status'] = status;
//       var result = await RepairDao.approve(params);
//       var bus = EventNotice();
//       bus.formId = widget.repair.formId;
//       eventBus.fire(bus);
//       PlatformMethod.sentTriggerUnreadToNative();
//       BoostNavigator.instance.pop();
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   delete() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await RepairDao.delete(widget.repair.id);
//       BoostNavigator.instance.pop();
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   revoke() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await RepairDao.revoke(widget.repair.id);
//       BoostNavigator.instance.pop();
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   Future<void> loadData() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await RepairDao.detail(widget.repair.id);
//       setState(() {
//         repairModel = result;
//       });
//       if (isNotice) {
//         read();
//       }
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       print(e);
//       showWarnToast(e.message);
//     }
//   }
//
//   _buildTop() {
//     SchoolOaRepair schoolOaRepair = repairModel?.schoolOaRepair;
//     if (schoolOaRepair == null) {
//       return Container();
//     }
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           OATwoText('表单编号:', schoolOaRepair.formId, '报修日期:',
//               dateYearMothAndDay(schoolOaRepair.ddate),
//               // isLong: true,
//               content1Color: Colors.grey, content2Color: Colors.grey),
//           OATwoText('报修人:', schoolOaRepair.cname, '报修状态:',
//               buildOAStatus(schoolOaRepair.status)[1],
//               content1Color: Colors.grey,
//               // isLong: true,
//               content2Color: buildOAStatus(schoolOaRepair.status)[0]),
//           OAOneText('报修部门:', schoolOaRepair.deptName),
//           boxLine(context),
//           hiSpace(height: 10),
//           OATwoText('报修种类:', schoolOaRepair.repairKinds, '报修物品:',
//               schoolOaRepair.repairMer, isLong: false,),
//           OAOneText('联系方式:', schoolOaRepair.tel),
//           OAOneText('E-MAIL:', schoolOaRepair.email),
//           OAOneText('报修地址:', schoolOaRepair.repairAddress),
//           OAOneText('故障描述', '', tipColor: Colors.black),
//           Container(
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
//             child: Text(schoolOaRepair.content ?? '',
//                 style: const TextStyle(fontSize: 13, color: Colors.grey)),
//           ),
//           schoolOaRepair.repairResult.isNotEmpty ? Column(
//             children: [
//               OAOneText('维修结果', '', tipColor: Colors.black),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
//                 child: Text(schoolOaRepair.repairResult ?? '',
//                     style: const TextStyle(fontSize: 13, color: Colors.grey)),
//               ),
//             ],
//           ) : Container(),
//           schoolOaRepair.repairReport.isNotEmpty ? Column(
//             children: [
//               OAOneText('维修报告', '', tipColor: Colors.black),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
//                 child: Text(schoolOaRepair.repairReport ?? '',
//                     style: const TextStyle(fontSize: 13, color: Colors.grey)),
//               ),
//             ],
//           ) : Container(),
//           _buildAttach(),
//           boxLine(context),
//           OAOneText('批阅信息', '', tipColor: Colors.black),
//           hiSpace(height: 10),
//           _buildApply(),
//           isUnSend && !isNotice ? OASubmitButton(
//               onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed) : Container(),
//           hiSpace(height: 30)
//         ],
//       ),
//     );
//   }
//
//   /// 审批中状态
//   bool get isApply0 {
//     if (repairModel == null) {
//       return false;
//     }
//     return repairModel?.schoolOaRepair?.status == 1 || repairModel?.schoolOaRepair?.status == 3;
//   }
//
//   /// 审批中状态
//   bool get isApply {
//     if (widget.reviewStatus == null) {
//       return false;
//     }
//     return widget.reviewStatus == 1;
//   }
//
//   /// 未发出状态
//   bool get isUnSend {
//     if (repairModel == null) {
//       return false;
//     }
//     return repairModel?.schoolOaRepair?.status == 0;
//   }
//
//   onSavePressed() async {
//     onSubmitPressed(isSave: true);
//   }
//
//   onSubmitPressed({isSave = false}) async {
//     SchoolOaRepair repair = repairModel?.schoolOaRepair;
//     if (repair == null) {
//       showWarnToast("获取数据异常，请关闭当前页面重进");
//       return;
//     }
//     Map<String, dynamic> params = {};
//     params['id'] = repair.id;
//     params['cname'] = repair.cname;
//     params['dDate'] = repair.ddate;
//     params['repairStatus'] = repair.status;
//     params['deptName'] = repair.deptName;
//     params['repairKinds'] = repair.repairKinds;
//     params['repairMer'] = repair.repairMer;
//     params['tel'] = repair.tel;
//     params['email'] = repair.email;
//     params['repairAddress'] = repair.repairAddress;
//     params['content'] = repair.content;
//     params['schoolOaRepairApproveList'] = repairModel.schoolOaRepairApproveList;
//     params['type'] = repair.type;
//
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await RepairDao.submit(params, isSave: isSave);
//       print(result);
//       if (result['code'] == 200) {
//         showWarnToast(isSave ? '保存成功' : '发布成功');
//         EasyLoading.dismiss(animation: false);
//         BoostNavigator.instance.pop();
//       } else {
//         print(result['message']);
//         showWarnToast(result['message']);
//         EasyLoading.dismiss(animation: false);
//       }
//     } catch (e) {
//       print(e);
//       showWarnToast(e.message);
//       EasyLoading.dismiss(animation: false);
//     }
//   }
//
//   _buildAttach() {
//     if (repairModel != null &&
//         repairModel.schoolOaRepairEnclosureList != null &&
//         repairModel.schoolOaRepairEnclosureList.isNotEmpty) {
//       return Column(
//         children: [
//           OAOneText('附件', '', tipColor: Colors.black),
//           boxLine(context),
//           OAAttachDetail(items: repairModel.schoolOaRepairEnclosureList)
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   _buildApply() {
//     List<SchoolOaRepairApproveList> datas =
//         repairModel.schoolOaRepairApproveList;
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: datas.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             decoration: BoxDecoration(border: BorderTimeLine(index)),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildApproveTop(datas[index]),
//                   hiSpace(height: 10),
//                   _buildApproveList(datas[index]),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   _buildApproveTop(SchoolOaRepairApproveList approve) {
//     return Row(
//       children: [
//         Expanded(
//             child: Row(
//           children: [
//             Text(approve.kinds == "1" ? '审批人' : '通知人',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             hiSpace(width: 3),
//             Text((approve.deptName ?? '') + ' ' + approve.approveName,
//                 style: const TextStyle(fontSize: 12, color: Colors.black))
//           ],
//         )),
//         Text(dateYearMothAndDayAndSecend(approve.approveDate?.replaceAll(".000", "") ?? approve.createTime?.replaceAll(".000", "")), style: const TextStyle(fontSize: 12, color: Colors.black)),
//         hiSpace(width: 3),
//         oaStatusText(approve.status, kinds: approve.kinds)
//       ],
//     );
//   }
//
//   _buildApproveList(SchoolOaRepairApproveList approve) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         hiSpace(height: approve.approveRemark != null && approve.approveRemark.isNotEmpty ? 6 : 0),
//         approve.approveRemark != null && approve.approveRemark.isNotEmpty ? buildRemark(approve.approveRemark ?? '') : Container(),
//         hiSpace(height: 6),
//         approve.repairResult != null && approve.repairResult.isNotEmpty ? OAOneText('维修结果: ', approve.repairResult) : Container(),
//         approve.repairReport != null && approve.repairReport.isNotEmpty ? OAOneText('维修报告: ', approve.repairReport) : Container(),
//       ],
//     );
//   }
// }
