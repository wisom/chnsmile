// import 'package:chnsmile_flutter/core/hi_state.dart';
// import 'package:chnsmile_flutter/core/platform_method.dart';
// import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
// import 'package:chnsmile_flutter/http/dao/reimburse_manager_dao.dart';
// import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
// import 'package:chnsmile_flutter/model/event_notice.dart';
// import 'package:chnsmile_flutter/model/repair_detail_model.dart';
// import 'package:chnsmile_flutter/utils/common.dart';
// import 'package:chnsmile_flutter/utils/format_util.dart';
// import 'package:chnsmile_flutter/utils/hi_toast.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:chnsmile_flutter/widget/appbar.dart';
// import 'package:chnsmile_flutter/widget/border_time_line.dart';
// import 'package:chnsmile_flutter/widget/oa_approve_dialog.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_boost/flutter_boost.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/string_util.dart';
// import 'package:hi_base/view_util.dart';
//
// import '../../model/attach.dart';
// import '../../model/reimburse_approve.dart';
// import '../../model/reimburse_item_detail.dart';
// import '../../model/reimburse_model.dart';
// import '../../widget/oa_attach_detail.dart';
// import '../../widget/oa_submit_button.dart';
// import 'Reimburse_detail_card.dart';
//
// class ReimburseDetailPage extends StatefulWidget {
//   static String TAG = "ReimburseDetailPage==";
//   final Map params;
//   Reimburse item;
//   String type;
//
//   ///列表类型 1.报销申请；2.报销审批；3.收到通知；
//   int reviewStatus; // 审核需要用到
//   bool isFromOA = false;
//
//   ReimburseDetailPage({Key key, this.params}) : super(key: key) {
//     item = params['item'];
//     LogUtil.d(TAG, "ReimburseDetailPage item=" + item.toString());
//     type = params['type'];
//     reviewStatus = params['reviewStatus'];
//     // isFromOA = params['isFromOA'];
//   }
//
//   @override
//   _ReimburseDetailPageState createState() => _ReimburseDetailPageState();
// }
//
// class _ReimburseDetailPageState extends HiState<ReimburseDetailPage> {
//   Reimburse model;
//
//   @override
//   void initState() {
//     super.initState();
//     LogUtil.d("费用申请", "initState");
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
//                   _buildContent(model),
//                 ],
//               ),
//             ),
//             onRefresh: loadData));
//   }
//
//   ///列表类型 1.报销申请；2.报销审批；3.收到通知；
//   _buildAppBar() {
//     var title = "";
//     if (isEmpty(widget.type)) {
//       // 从申请进来
//       if (isUnSend) {
//         title = '删除';
//       } else if (isApply0) {
//         title = '撤销';
//       }
//     } else {
//       if (widget.type == "1") {
//         // 从审批进来
//         if (isApply) {
//           title = '审批';
//         }
//       } else {
//         // 通知
//       }
//     }
//
//     return appBar(_getTitle(), rightTitle: _getTitleRightText(),
//         rightButtonClick: () {
//       delete();
//     });
//   }
//
//   String _getTitle() {
//     if (widget.type == "1") {
//       return "报销申请详情";
//     } else {
//       return "报销审批详情";
//     }
//   }
//
//   String _getTitleRightText() {
//     if (widget.type == "1") {
//       if (isUnSend) {
//         return '删除';
//       } else if (isApply0) {
//         return '撤销';
//       }
//     } else {
//       if (isApply) {
//         return '审批';
//       }
//     }
//     return "";
//   }
//
//   bool get isNotice {
//     return widget.type == "3";
//   }
//
//   showApproveDialog() {
//     showCupertinoDialog(
//         context: context,
//         builder: (context) {
//           return OAApproveDialog(
//               onLeftPress: (String content, String result, String report) {
//             approve(content, result, report, 2);
//             Navigator.of(context).pop();
//           }, onRightPress: (String content, String result, String report) {
//             approve(content, result, report, 3);
//             Navigator.of(context).pop();
//           }, onClosePress: () {
//             Navigator.of(context).pop();
//           });
//         });
//   }
//
//   read() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       Map<String, dynamic> params = {};
//       // params['formId'] = repairModel?.schoolOaRepair?.formId;
//       params['status'] = 2;
//       params['kinds'] = "2";
//       var result = await RepairDao.approve(params);
//       PlatformMethod.sentTriggerUnreadToNative();
//       var bus = EventNotice();
//       bus.formId = widget.item.formId;
//       eventBus.fire(bus);
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   approve(
//       String content, String repairResult, String report, int status) async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       Map<String, dynamic> params = {};
//       // params['formId'] = repairModel?.schoolOaRepair?.formId;
//       params['kinds'] = 1;
//       params['repairResult'] = repairResult;
//       params['repairReport'] = report;
//       params['approveRemark'] = content;
//       params['status'] = status;
//       var result = await RepairDao.approve(params);
//       var bus = EventNotice();
//       bus.formId = widget.item.formId;
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
//       var result = await RepairDao.delete(widget.item.id);
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
//       var result = await RepairDao.revoke(widget.item.id);
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
//       LogUtil.d("费用申请", " loadData formId=" + widget.item.formId);
//       var result = await ReimbureseManagerDao.detail(widget.item.formId);
//       setState(() {
//         model = result;
//         LogUtil.d("费用申请", " loadData model=" + model.toString());
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
//   /// 审批中状态
//   bool get isApply0 {
//     if (model == null) {
//       return false;
//     }
//     // return repairModel?.schoolOaRepair?.status == 1 ||
//     //     repairModel?.schoolOaRepair?.status == 3;
//     return false;
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
//     if (model == null) {
//       return false;
//     }
//     return model?.status == 0;
//   }
//
//   onSavePressed() async {
//     onSubmitPressed(isSave: true);
//   }
//
//   onSubmitPressed({isSave = false}) async {
//     SchoolOaRepair repair;
//     // SchoolOaRepair repair = repairModel?.schoolOaRepair;
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
//     // params['schoolOaRepairApproveList'] = repairModel.schoolOaRepairApproveList;
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
//     // if (repairModel != null &&
//     //     repairModel.schoolOaRepairEnclosureList != null &&
//     //     repairModel.schoolOaRepairEnclosureList.isNotEmpty) {
//     //   return Column(
//     //     children: [
//     //       OAOneText('附件', '', tipColor: Colors.black),
//     //       boxLine(context),
//     //       OAAttachDetail(items: repairModel.schoolOaRepairEnclosureList)
//     //     ],
//     //   );
//     // } else {
//     return Container();
//     // }
//   }
//
//   _buildApply() {
//     List<ReimburseApprove> datas = model.claimApproveList;
//     return Padding(
//         padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
//         child: ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: datas.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(border: BorderTimeLine(index)),
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildApproveTop(datas[index]),
//                       hiSpace(height: 10),
//                       _buildApproveList(datas[index]),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }));
//   }
//
//   _buildApproveTop(ReimburseApprove approve) {
//     return Row(
//       children: [
//         Expanded(
//             child: Row(
//           children: [
//             Text(approve.kinds == "1" ? '审批人' : '通知人',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             hiSpace(width: 3),
//             Text((approve.orgName ?? '') + ' ' + approve.approveName,
//                 style: const TextStyle(fontSize: 12, color: Colors.black))
//           ],
//         )),
//         Text(
//             dateYearMothAndDayAndSecend(
//                 approve.approveDate?.replaceAll(".000", "") ?? ""),
//             style: const TextStyle(fontSize: 12, color: Colors.black)),
//         hiSpace(width: 3),
//         oaStatusText(approve.status, kinds: approve.kinds)
//       ],
//     );
//   }
//
//   _buildApproveList(ReimburseApprove approve) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         hiSpace(
//             height: approve.approveRemark != null &&
//                     approve.approveRemark.isNotEmpty
//                 ? 6
//                 : 0),
//         approve.approveRemark != null && approve.approveRemark.isNotEmpty
//             ? buildRemark(approve.approveRemark ?? '')
//             : Container(),
//         hiSpace(height: 6),
//       ],
//     );
//   }
//
//   _buildContent(Reimburse model) {
//     return Column(
//       children: [
//         _buildTopInfo(model),
//         _buildDepartment(model),
//         _buildRemark(model),
//         hiSpace(height: 6),
//         line(context),
//         _buildApplyDetail(model),
//         _buildAttachment(model),
//         _buildReadInfo(model)
//       ],
//     );
//   }
//
//   _buildReadInfo(Reimburse model) {
//     return Column(
//       children: [
//         const Padding(
//           padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "批阅信息",
//               style: TextStyle(
//                   fontSize: 12,
//                   color: HiColor.color_181717,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         hiSpace(height: 10),
//         _buildApply(),
//         isUnSend && !isNotice
//             ? OASubmitButton(
//                 onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
//             : Container(),
//         hiSpace(height: 30)
//       ],
//     );
//   }
//
//   _buildAttachment(Reimburse model) {
//     return Column(
//       children: [
//         const Padding(
//             padding: EdgeInsets.fromLTRB(14, 14, 14, 6),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "附件",
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: HiColor.color_181717,
//                     fontWeight: FontWeight.bold),
//               ),
//             )),
//         line(context, margin: const EdgeInsets.symmetric(horizontal: 14)),
//         Padding(
//           padding: EdgeInsets.fromLTRB(14, 14, 12, 0),
//           child: OAAttachDetail(items: model.toAttachList()),
//         ),
//         line(context, margin: const EdgeInsets.symmetric(horizontal: 14)),
//       ],
//     );
//   }
//
//   _buildTopInfo(Reimburse model) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Text(
//                 "表单编号：",
//                 style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
//               ),
//               Text(
//                 model?.formId ?? "",
//                 style:
//                     const TextStyle(fontSize: 12, color: HiColor.color_878B99),
//               ),
//               const Text(
//                 "申请日期：",
//                 style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
//               ),
//               Text(
//                 model?.createTime ?? "",
//                 style:
//                     const TextStyle(fontSize: 12, color: HiColor.color_878B99),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
//             child: Row(
//               children: [
//                 const Text(
//                   "发 起 人：",
//                   style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
//                 ),
//                 Text(
//                   model?.createName ?? "",
//                   style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
//                 ),
//                 const Text(
//                   "申请状态：",
//                   style: TextStyle(fontSize: 12, color: HiColor.color_878B99),
//                 ),
//                 Text(
//                   _buildStates(model?.status ?? 0),
//                   style: TextStyle(fontSize: 12, color: HiColor.color_EA0000),
//                 ),
//               ],
//             ),
//           ),
//           line(context)
//         ],
//       ),
//     );
//   }
//
//   _buildDepartment(Reimburse model) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 15, 13, 0),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "报销事由",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: HiColor.color_181717,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           line(context)
//         ],
//       ),
//     );
//   }
//
//   _buildRemark(Reimburse model) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 9, 17, 20),
//       child: Column(
//         children: [
//           Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 model?.reimbursementCause ?? "",
//                 textAlign: TextAlign.left,
//                 style:
//                     const TextStyle(fontSize: 12, color: HiColor.color_787777),
//               )),
//         ],
//       ),
//     );
//   }
//
//   _buildApplyDetail(Reimburse model) {
//     return Column(
//       children: [
//         _buildApplyTitle(),
//         line(context),
//         _buildApplyList(model?.itemList)
//       ],
//     );
//   }
//
//   _buildApplyTitle() {
//     return const Padding(
//       padding: EdgeInsets.fromLTRB(14, 7, 0, 7),
//       child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "项目申请明细",
//             style: TextStyle(
//                 fontSize: 12,
//                 color: HiColor.color_181717,
//                 fontWeight: FontWeight.bold),
//           )),
//     );
//   }
//
//   _buildApplyList(List<ReimburseItemDetail> list) {
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: list?.length ?? 0,
//         itemBuilder: (BuildContext context, int index) =>
//             ReimburseDetailCard(item: list[index], subItems: list));
//   }
//
//   ///状态（0未发送、1批阅中、2已备案、3已拒绝）
//   _buildStates(int status) {
//     if (status == 1) {
//       return "批阅中";
//     } else if (status == 2) {
//       return "已备案";
//     } else if (status == 3) {
//       return "已拒绝";
//     } else {
//       return "未发送";
//     }
//   }
// }
