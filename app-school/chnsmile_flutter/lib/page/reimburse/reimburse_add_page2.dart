// import 'package:chnsmile_flutter/constant/hi_constant.dart';
// import 'package:chnsmile_flutter/core/hi_state.dart';
// import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
// import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
// import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
// import 'package:chnsmile_flutter/http/dao/fund_manager_dao.dart';
// import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
// import 'package:chnsmile_flutter/model/default_apply_model.dart';
// import 'package:chnsmile_flutter/model/fund_manager_detail.dart';
// import 'package:chnsmile_flutter/model/fund_manager_item_param.dart';
// import 'package:chnsmile_flutter/model/local_file.dart';
// import 'package:chnsmile_flutter/model/sys_org_model.dart';
// import 'package:chnsmile_flutter/model/upload_attach.dart';
// import 'package:chnsmile_flutter/utils/common.dart';
// import 'package:chnsmile_flutter/utils/format_util.dart';
// import 'package:chnsmile_flutter/utils/hi_toast.dart';
// import 'package:chnsmile_flutter/utils/list_utils.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:chnsmile_flutter/widget/appbar.dart';
// import 'package:chnsmile_flutter/widget/border_time_line.dart';
// import 'package:chnsmile_flutter/widget/normal_select.dart';
// import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
// import 'package:chnsmile_flutter/widget/select_attach.dart';
// import 'package:chnsmile_flutter/widget/star.dart';
// import 'package:chnsmile_flutter/widget/w_pop/w_popup_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_boost/flutter_boost.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/string_util.dart';
// import 'package:hi_base/view_util.dart';
// import 'package:hi_cache/hi_cache.dart';
//
// import '../../model/fund_manager_approve.dart';
// import '../../widget/normal_input.dart';
// import '../../widget/normal_multi_input.dart';
// import '../../widget/time_picker/model/date_mode.dart';
// import '../../widget/time_picker/model/suffix.dart';
// import '../../widget/time_picker/pickers.dart';
//
// class ReimburseAddPage extends StatefulWidget {
//   final Map params;
//   String id;
//
//   ReimburseAddPage({Key key, this.params}) : super(key: key) {
//     id = params['id'];
//   }
//
//   @override
//   _ReimburseAddPageState createState() => _ReimburseAddPageState();
// }
//
// class _ReimburseAddPageState extends HiState<ReimburseAddPage> {
//   static String TAG = "FundManagerAddPage==";
//   final FocusNode focusNode1 = FocusNode();
//   final FocusNode focusNode2 = FocusNode();
//   final FocusNode focusNode3 = FocusNode();
//   final FocusNode focusNode4 = FocusNode();
//   final FocusNode focusNode5 = FocusNode();
//   final FocusNode focusNode6 = FocusNode();
//   final FocusNode focusNode7 = FocusNode();
//   final FocusNode focusNode8 = FocusNode();
//
//   bool buttonEnable = false;
//   int reviewType = 1;
//   String cname = ""; // 保修人姓名
//   String orgId = ""; // id
//   String orgName = ""; // 报销部门
//   String content = ""; // 报销内容
//   String remark = ""; // 备注
//   String budget = ""; // 总预算
//   String formId = ""; //
//   String status = "0"; //报销状态
//   String needDate = ""; //需求时间
//   String createTime = ""; //创建时间
//   List<Widget> optionsWidget = []; // 明细选项控件
//   List<FundManagerItemParam> detailList = []; //明细列表
//   List<FundManagerApprove> approves = []; // 审批人, 通知人
//   List<SysOrg> sysorgs = [];
//
//   List<ProcessInfo> defaultApproves; // 默认审批人
//   List<ProcessInfo> defaultNotices; // 默认通知人
//   List<ProcessInfo> customerApproves = []; // 自定义审批人
//   List<ProcessInfo> customerNotices = []; // 自定义通知人
//   List<LocalFile> files = []; // 选择文件数量
//
//   final ProcessInfo iconInfo =
//       ProcessInfo(avatarImg: "images/contact_add_button.png", userId: "-1");
//
//   FundManagerDetail model;
//   bool isLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     cname = HiCache.getInstance().get(HiConstant.spUserName);
//     orgId = HiCache.getInstance().get(HiConstant.spUserId);
//     createTime = currentYearMothAndDay();
//     optionsWidget.add(_buildOptions(optionsWidget.length));
//     loadDefaultData();
//   }
//
//   @override
//   void dispose() {
//     focusNode1.dispose();
//     focusNode2.dispose();
//     focusNode3.dispose();
//     focusNode4.dispose();
//     focusNode5.dispose();
//     focusNode6.dispose();
//     focusNode7.dispose();
//     focusNode8.dispose();
//     super.dispose();
//   }
//
//   unFocus() {
//     focusNode1.unfocus();
//     focusNode2.unfocus();
//     focusNode3.unfocus();
//     focusNode4.unfocus();
//     focusNode5.unfocus();
//     focusNode6.unfocus();
//     focusNode7.unfocus();
//     focusNode8.unfocus();
//   }
//
//   bool get isEdit {
//     return widget.id != null;
//   }
//
//   // handleApproves(List<FundManagerApprove> approves) {
//   //   for (var item in approves) {
//   //     if ("1" == item.kinds) {
//   //       defaultApproves.add(ProcessInfo(
//   //           avatarImg: item.approveImg,
//   //           userId: item.approveId,
//   //           approveName: item.approveName));
//   //     } else {
//   //       defaultNotices.add(ProcessInfo(
//   //           avatarImg: item.approveImg,
//   //           userId: item.approveId,
//   //           approveName: item.approveName));
//   //     }
//   //   }
//   // }
//
//   loadDefaultData() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await DefaultApplyDao.get();
//       defaultApproves ??= [];
//       defaultNotices ??= [];
//       // if (isEdit) {
//       //   var result1 = await RepairDao.detail(widget.id);
//       //   setState(() {
//       //     model = result1;
//       //     var repair = model?.schoolOaRepair;
//       //     // deptId = repair.deptId;
//       //     // deptName = repair.deptName;
//       //     // repairKinds = repair.repairKinds;
//       //     // repairMer = repair.repairMer;
//       //     // tel = repair.tel;
//       //     // email = repair.email;
//       //     // repairAddress = repair.repairAddress;
//       //     content = repair.content;
//       //     // reviewType = repair.type;
//       //
//       //     handleApproves(model.schoolOaRepairApproveList);
//       //   });
//       //   isLoaded = true;
//       // }
//       setState(() {
//         if (!isEdit) {
//           defaultApproves =
//               result != null ? result.defaultApprove.processMxList : [];
//         }
//         defaultApproves.add(_getAddIcon());
//
//         customerApproves.add(_getAddIcon());
//
//         if (!isEdit) {
//           defaultNotices =
//               result != null ? result.defaultNotice.processMxList : [];
//         }
//         defaultNotices.add(_getAddIcon());
//
//         customerNotices.add(_getAddIcon());
//       });
//       SysOrgModel rs = await RepairDao.getSysOrg();
//       setState(() {
//         if (rs == null || rs.list.isEmpty) {
//           showWarnToast("部门数据为空，请联系管理员添加");
//         }
//         sysorgs = rs.list;
//       });
//       isLoaded = true;
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       isLoaded = true;
//       print(e);
//       EasyLoading.dismiss(animation: false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       backgroundColor: Colors.white,
//       body: isLoaded
//           ? ListView(
//               children: [
//                 _buildTop(),
//                 _buildAttach(),
//                 hiSpace(height: 12),
//                 line(context,margin:EdgeInsets.fromLTRB(12, 0, 12, 0)),
//                 _buildTotal(),
//                 _buildBottom()
//               ],
//             )
//           : Container(),
//     );
//   }
//
//   _buildTotal() {
//     return Container(
//         padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Star(),
//             const Text('总计金额:',
//                 style: TextStyle(fontSize: 13, color: Colors.black)),
//             Expanded(
//               child: NormalInput(
//                 hint: "计算自动填写",
//                 focusNode: focusNode3,
//                 onChanged: (text) {
//                   budget = text;
//                 },
//               ),
//             ),
//             InkWell(
//                 onTap: () {},
//                 child: Container(
//                   margin: const EdgeInsets.only(right: 10),
//                   width: 34,
//                   height: 42,
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(
//                     color: HiColor.color_00B0F0,
//                   ),
//                   child: const Text('计算',
//                       style: TextStyle(fontSize: 13, color: Colors.white)),
//                 ))
//           ],
//         ));
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
//   _buildAppBar() {
//     var rightTitle = '';
//     if (isUnSend) {
//       rightTitle = '删除';
//     }
//
//     return appBar(isEdit ? '报销审批详情' : '报销申请', rightTitle: rightTitle,
//         rightButtonClick: () {
//       if (rightTitle == '删除') {
//         delete();
//       }
//     });
//   }
//
//   delete() async {
//     try {
//       EasyLoading.show(status: '加载中...');
//       var result = await RepairDao.delete(widget.id);
//       BoostNavigator.instance.pop();
//       EasyLoading.dismiss(animation: false);
//     } catch (e) {
//       EasyLoading.dismiss(animation: false);
//       showWarnToast(e.message);
//     }
//   }
//
//   showDepartDialog() {
//     // unFocus();
//     FocusManager.instance.primaryFocus?.unfocus();
//     List<String> list = [];
//     for (var item in sysorgs) {
//       list.add(item.name);
//     }
//
//     print("list:$list");
//     showListDialog(context, title: '请选择报销部门', list: list,
//         onItemClick: (String type, int index) {
//       setState(() {
//         SysOrg item = sysorgs[index];
//         orgName = item.name;
//         orgId = item.id;
//       });
//     });
//   }
//
//   showStatusDialog() {
//     List<String> list = ['未发出', '已备案', '审批中', '已拒绝'];
//     showListDialog(context, title: '请选择报销状态', list: list,
//         onItemClick: (String type, int index) {
//       setState(() {
//         status = type;
//       });
//     });
//   }
//
//   _buildTop() {
//     return Container(
//       padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 15),
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                   flex: 5,
//                   child: Row(
//                     children: [
//                       const Text('表单编号:',
//                           style: TextStyle(fontSize: 13, color: Colors.black)),
//                       Text('提交后生成',
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.black54))
//                     ],
//                   )),
//               Expanded(
//                   flex: 4,
//                   child: Row(
//                     children: [
//                       const Text('申请日期:',
//                           style: TextStyle(fontSize: 13, color: Colors.black)),
//                       Text(createTime ?? '',
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.black54))
//                     ],
//                   ))
//             ],
//           ),
//           hiSpace(height: 15),
//           Row(
//             children: [
//               Expanded(
//                   flex: 5,
//                   child: Row(
//                     children: [
//                       const Text('发  起  人:',
//                           style: TextStyle(fontSize: 13, color: Colors.black)),
//                       hiSpace(width: 5),
//                       Text(cname ?? "",
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.black54))
//                     ],
//                   )),
//               Expanded(
//                   flex: 4,
//                   child: Row(
//                     children: [
//                       const Text('申请状态:',
//                           style: TextStyle(fontSize: 13, color: Colors.black)),
//                       hiSpace(width: 5),
//                       Text('未发出',
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.black54))
//                     ],
//                   ))
//             ],
//           ),
//           hiSpace(height: 15),
//           Row(
//             children: [
//               Star(),
//               const Text('报  销  人:    ',
//                   style: TextStyle(fontSize: 13, color: Colors.black)),
//               Expanded(
//                 child: NormalSelect(
//                   hint: "请输入报销人",
//                   text: orgName ?? "",
//                   onSelectPress: showDepartDialog,
//                 ),
//               )
//             ],
//           ),
//           hiSpace(height: 15),
//           Row(
//             children: [
//               Star(),
//               const Text('报销日期:    ',
//                   style: TextStyle(fontSize: 13, color: Colors.black)),
//               Expanded(
//                 child: NormalSelect(
//                   hint: "请输入时间",
//                   text: needDate ?? "",
//                   rightWidget: const Icon(Icons.calendar_today_outlined,
//                       size: 18, color: HiColor.color_181717_A50),
//                   onSelectPress: timeClick,
//                 ),
//               )
//             ],
//           ),
//           hiSpace(height: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Star(),
//                   const Text('报销事由:',
//                       style: TextStyle(fontSize: 13, color: Colors.black)),
//                 ],
//               ),
//               hiSpace(height: 8),
//               NormalMultiInput(
//                   hint: '请输入报销事由',
//                   focusNode: focusNode5,
//                   minLines: 5,
//                   maxLines: 5,
//                   onChanged: (text) {
//                     content = text;
//                   }),
//               hiSpace(height: 10),
//             ],
//           ),
//           hiSpace(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "报销明细",
//                 style: TextStyle(color: HiColor.color_181717_A50, fontSize: 14),
//               ),
//               // InkWell(
//               //   onTap: () {
//               //     setState(() {
//               //       optionsWidget.add(_buildOptions(optionsWidget.length));
//               //     });
//               //   },
//               ActionChip(
//                 backgroundColor: Colors.lightBlueAccent,
//                 label: const Text("添加",
//                     style: TextStyle(fontSize: 10, color: Colors.white)),
//                 onPressed: () {
//                   setState(() {
//                     optionsWidget.add(_buildOptions(optionsWidget.length));
//                   });
//                 },
//               ),
//               // Text(
//               //   "添加",
//               //   style: TextStyle(color: Colors.white, fontSize: 10),
//               // ),
//               // )
//             ],
//           ),
//           hiSpace(height: 15),
//           Column(
//             children: optionsWidget.map((e) => e).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _buildOptions(int option) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Star(),
//             const Text('报销类型:',
//                 style: TextStyle(fontSize: 13, color: Colors.black)),
//             Expanded(
//               child: NormalInput(
//                 hint: "请输入类型",
//                 focusNode: focusNode2,
//                 onChanged: (text) {
//                   detailList[option].expendName = text;
//                 },
//               ),
//             )
//           ],
//         ),
//         hiSpace(height: 15),
//         Row(
//           children: [
//             Star(),
//             const Text('发票数量:',
//                 style: TextStyle(fontSize: 13, color: Colors.black)),
//             Expanded(
//               child: NormalInput(
//                 hint: "请输入数量",
//                 focusNode: focusNode5,
//                 onChanged: (text) {
//                   detailList[option].count = double.parse(text);
//                 },
//               ),
//             )
//           ],
//         ),
//         hiSpace(height: 15),
//         Row(
//           children: [
//             Star(),
//             const Text('报销金额:',
//                 style: TextStyle(fontSize: 13, color: Colors.black)),
//             Expanded(
//               child: NormalInput(
//                 hint: "请输入金额",
//                 focusNode: focusNode6,
//                 onChanged: (text) {
//                   detailList[option].unit = text;
//                 },
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
//
//   /// 添加附件
//   _buildAttach() {
//     // unFocus();
//     return SelectAttach(
//         attachs: model?.toAttachList(),
//         itemsCallBack: (List<LocalFile> items) {
//           print("items: ${items}");
//           files = items ?? [];
//         });
//   }
//
//   /// 批阅信息
//   _buildBottom() {
//     return Container(
//       padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 50),
//       color: Colors.white,
//       child: Column(
//         children: [
//           _buildBottomTips(),
//           _buttonBottomContent(),
//           OASubmitButton(
//               onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
//         ],
//       ),
//     );
//   }
//
//   checkInput() {
//     bool enable;
//
//     if (isNotEmpty(cname) &&
//         isNotEmpty(orgName) &&
//         isNotEmpty(needDate) &&
//         isNotEmpty(content)) {
//       enable = true;
//     } else {
//       enable = false;
//     }
//     setState(() {
//       buttonEnable = enable;
//     });
//   }
//
//   List getItemParams() {
//     List<FundManagerItemParam> list = [];
//     // optionsWidget.map((e) => {
//     //   list.add(FundManagerItemParam(
//     //
//     //   ))
//     // });
//     return list;
//   }
//
//   List getApproves() {
//     List<FundManagerApprove> approves = [];
//     // if (isDefault) {
//     //   for (var processInfo in defaultApproves) {
//     //     if (processInfo.userId == "-1") {
//     //       continue;
//     //     }
//     //     approves.add(FundManagerApprove(kinds: "1", approveId: processInfo.userId));
//     //   }
//     //
//     //   for (var processInfo in defaultNotices) {
//     //     if (processInfo.userId == "-1") {
//     //       continue;
//     //     }
//     //     approves.add(FundManagerApprove(kinds: "2", approveId: processInfo.userId));
//     //   }
//     // } else {
//     //   for (var processInfo in customerApproves) {
//     //     if (processInfo.userId == "-1") {
//     //       continue;
//     //     }
//     //     approves.add(FundManagerApprove(kinds: "1", approveId: processInfo.userId));
//     //   }
//     //
//     //   for (var processInfo in customerNotices) {
//     //     if (processInfo.userId == "-1") {
//     //       continue;
//     //     }
//     //     approves.add(FundManagerApprove(kinds: "2", approveId: processInfo.userId));
//     //   }
//     // }
//     //
//     // var list = [];
//     // for (FundManagerApprove oaPeople in approves) {
//     //   var json = oaPeople.toJson();
//     //   list.add(json);
//     // }
//     return approves;
//   }
//
//   onSavePressed() async {
//     onSubmitPressed(isSave: true);
//   }
//
//   onSubmitPressed({isSave = false}) async {
//     if (isEmpty(orgName)) {
//       showWarnToast("部门不能为空");
//       return;
//     }
//     if (isEmpty(needDate)) {
//       showWarnToast("需求时间不能为空");
//       return;
//     }
//     if (isEmpty(content)) {
//       showWarnToast("用途不能为空");
//       return;
//     }
//     // if (isEmpty(remark)) {
//     //   showWarnToast("备注不能为空");
//     //   return;
//     // }
//
//     if (isEmpty(budget)) {
//       showWarnToast("总计金额不能为空");
//       return;
//     }
//
//     // if (getApproves().isEmpty) {
//     //   showWarnToast("请选择审批人员");
//     //   return;
//     // }
//
//     try {
//       EasyLoading.show(status: '加载中...');
//       // 先上传文件
//
//       List infoEnclosureList = [];
//       if (isEdit &&
//           model.fundApplyAccessoryParamList != null &&
//           model.fundApplyAccessoryParamList.isNotEmpty) {
//         for (var item in model.fundApplyAccessoryParamList) {
//           infoEnclosureList.add({"attachId": item.fileId});
//         }
//       }
//       if (files.isNotEmpty) {
//         for (var file in files) {
//           if (!file.path.startsWith("http")) {
//             UploadAttach uploadAttach = await AttachDao.upload(path: file.path);
//             infoEnclosureList.add({"attachId": uploadAttach.id});
//           }
//         }
//       }
//
//       Map<String, dynamic> params = {};
//       params['id'] = widget.id;
//       params['orgId'] = orgId;
//       params['orgName'] = orgName;
//       params['content'] = content;
//       params['remark'] = remark;
//       params['budget'] = budget;
//       if (!isSave) {
//         params['formId'] = null;
//       }
//       params['needDate'] = needDate;
//       params['status'] = isSave ? "0" : "1";
//       params['fundClaimApproveParamList'] = getApproves();
//       params['fundItemParamList'] = getItemParams();
//       params['fundApplyAccessoryParamList'] = infoEnclosureList;
//
//       //
//       //
//       // params['dDate'] = repairDate;
//       // params['deptId'] = deptId;
//       // params['repairKinds'] = repairKinds;
//       // params['repairMer'] = repairMer;
//       // params['tel'] = tel;
//       // params['email'] = email;
//       // params['repairAddress'] = repairAddress;
//       // params['schoolOaRepairApproveList'] = getApproves();
//       // params['schoolOaRepairEnclosureList'] = infoEnclosureList;
//       // params['type'] = reviewType;
//
//       var result = await FundManagerDao.submit(params, isSave: isSave);
//       LogUtil.d(TAG, "submit result=" + result.toString());
//       formId = result['data'];
//       showWarnToast(isSave ? '保存成功' : '发布成功');
//       EasyLoading.dismiss(animation: false);
//       BoostNavigator.instance.pop({"success": true});
//     } catch (e) {
//       print(e);
//       showWarnToast(e.message);
//       EasyLoading.dismiss(animation: false);
//     }
//   }
//
//   _buildBottomTips() {
//     return Row(
//       children: [
//         const Expanded(
//             child: Text('批阅信息',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black))),
//         Row(
//           children: [
//             const Text('类型:',
//                 style: TextStyle(fontSize: 13, color: Colors.grey)),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Radio(
//                   value: 1,
//                   groupValue: reviewType,
//                   activeColor: Colors.blue,
//                   onChanged: (v) {
//                     setState(() {
//                       reviewType = v;
//                     });
//                   },
//                 ),
//                 const Text("默认",
//                     style: TextStyle(fontSize: 13, color: Colors.black87))
//               ],
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Radio(
//                   value: 2,
//                   groupValue: reviewType,
//                   onChanged: (v) {
//                     setState(() {
//                       reviewType = v;
//                     });
//                   },
//                 ),
//                 const Text("自定义",
//                     style: TextStyle(fontSize: 13, color: Colors.black87))
//               ],
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   /// 是否是默认的批阅信息
//   bool get isDefault {
//     return reviewType == 1;
//   }
//
//   _buttonBottomContent() {
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 2,
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
//                   _buildApproveTips(index),
//                   hiSpace(height: 10),
//                   _buildApproveList(index),
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
//   _buildApproveTips(int index) {
//     if (index == 0) {
//       return Row(
//         children: [
//           Expanded(
//               child: Row(
//             children: [
//               const Text('审批人',
//                   style: TextStyle(fontSize: 13, color: Colors.grey)),
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 margin: const EdgeInsets.only(left: 5),
//                 decoration: bottomBoxShadow1(context),
//                 child: const Text('依此审批',
//                     style: TextStyle(fontSize: 12, color: primary)),
//               ),
//               const Text(' *',
//                   style: TextStyle(fontSize: 13, color: Colors.red)),
//             ],
//           )),
//           const Text('按图标调整次序',
//               style: TextStyle(fontSize: 12, color: Colors.grey))
//         ],
//       );
//     } else {
//       return const Text('通知人',
//           style: TextStyle(fontSize: 13, color: Colors.grey));
//     }
//   }
//
//   _buildApproveList(int index) {
//     List<ProcessInfo> lists;
//     if (isDefault) {
//       // 默认
//       lists = index == 0 ? defaultApproves : defaultNotices;
//     } else {
//       // 自定义
//       lists = index == 0 ? customerApproves : customerNotices;
//     }
//
//     if (lists == null) {
//       return Container();
//     }
//
//     return Wrap(
//         direction: Axis.horizontal,
//         alignment: WrapAlignment.start,
//         children: lists.asMap().entries.map((entry) {
//           int rowIndex = entry.key; // 里面的列表
//           ProcessInfo processInfo = entry.value;
//           return lists.length - 1 == rowIndex
//               ? _buildOAPeople(processInfo, index)
//               : _buildMagio(lists, processInfo, index, rowIndex);
//         }).toList());
//   }
//
//   Widget _buildMagio(List<ProcessInfo> lists, ProcessInfo processInfo,
//       int index, int rowIndex) {
//     List<ProcessInfo> listsTemp = List.from(lists);
//     listsTemp.remove(iconInfo);
//     double menuWidth = 100;
//     if (listsTemp.length == 1) {
//       // 只有1个元素
//       menuWidth = 60;
//     } else if (listsTemp.length == 2) {
//       // 只有两个元素
//       menuWidth = 100;
//     } else {
//       // 多个元素
//       menuWidth = 140;
//     }
//     return WPopupMenu(
//         onValueChanged: (int value) {
//           _onValueChangedClick(listsTemp, index, rowIndex, value, processInfo);
//         },
//         backgroundColor: primary,
//         menuWidth: menuWidth,
//         menuHeight: 36,
//         actions: _buildActions(listsTemp, rowIndex),
//         pressType: PressType.longPress,
//         child: _buildOAPeople(processInfo, index));
//   }
//
//   Widget _buildOAPeople(ProcessInfo processInfo, int index) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           _buildIcon(processInfo, index),
//           hiSpace(height: 2),
//           Container(
//             width: 46,
//             alignment: Alignment.center,
//             child: Text(processInfo.approveName ?? '',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 12, color: Colors.black)),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// 前移
//   _before(
//       List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
//     setState(() {
//       if (isDefault) {
//         index == 0
//             ? ListUtils.swapList(defaultApproves, rowIndex - 1, rowIndex)
//             : ListUtils.swapList(defaultNotices, rowIndex - 1, rowIndex);
//       } else {
//         index == 0
//             ? ListUtils.swapList(customerApproves, rowIndex - 1, rowIndex)
//             : ListUtils.swapList(customerNotices, rowIndex - 1, rowIndex);
//       }
//     });
//   }
//
//   /// 后移
//   _after(
//       List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
//     // 后移
//     setState(() {
//       if (isDefault) {
//         index == 0
//             ? ListUtils.swapList(defaultApproves, rowIndex, rowIndex + 1)
//             : ListUtils.swapList(defaultNotices, rowIndex, rowIndex + 1);
//       } else {
//         index == 0
//             ? ListUtils.swapList(customerApproves, rowIndex, rowIndex + 1)
//             : ListUtils.swapList(customerNotices, rowIndex, rowIndex + 1);
//       }
//     });
//   }
//
//   /// 删除
//   _delete(
//       List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
//     // 删除
//     setState(() {
//       if (isDefault) {
//         index == 0
//             ? defaultApproves.remove(processInfo)
//             : defaultNotices.remove(processInfo);
//       } else {
//         index == 0
//             ? customerApproves.remove(processInfo)
//             : customerNotices.remove(processInfo);
//       }
//     });
//   }
//
//   /**
//    * 0 -- 0 --- 2 -- 0
//    * 0 -- 1 --- 3 -- 0
//    * index : 第一行，第二行  0，1之中选择
//    * rowIndex:  里面的列表行数
//    */
//   _onValueChangedClick(
//       List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
//     print("value: $value -- $index --- ${lists.length} -- ${rowIndex}");
//     if (lists.length == 1) {
//       // 只有1个元素
//       _delete(lists, index, rowIndex, value, processInfo);
//     } else if (lists.length == 2) {
//       // 只有两个元素
//       if (rowIndex == 0) {
//         if (value == 0) {
//           _after(lists, index, rowIndex, value, processInfo);
//         } else {
//           _delete(lists, index, rowIndex, value, processInfo);
//         }
//       } else {
//         if (value == 0) {
//           _before(lists, index, rowIndex, value, processInfo);
//         } else {
//           _delete(lists, index, rowIndex, value, processInfo);
//         }
//       }
//     } else {
//       // 多个元素
//       // 多个元素，最后一个元素只有两个，前移或者删除
//       // '前移', '后移', '删除'
//       if (rowIndex == lists.length - 1) {
//         if (value == 0) {
//           _before(lists, index, rowIndex, value, processInfo);
//         } else {
//           _delete(lists, index, rowIndex, value, processInfo);
//         }
//       } else if (rowIndex == 0) {
//         if (value == 0) {
//           _after(lists, index, rowIndex, value, processInfo);
//         } else {
//           _delete(lists, index, rowIndex, value, processInfo);
//         }
//       } else {
//         if (value == 0) {
//           _before(lists, index, rowIndex, value, processInfo);
//         } else if (value == 1) {
//           _after(lists, index, rowIndex, value, processInfo);
//         } else {
//           _delete(lists, index, rowIndex, value, processInfo);
//         }
//       }
//     }
//   }
//
//   _buildActions(List lists, int index) {
//     if (lists.length == 1) {
//       // 只有1个元素
//       return ['删除'];
//     } else if (lists.length == 2) {
//       // 只有两个元素
//       if (index == 0) {
//         return ['后移', '删除'];
//       } else {
//         return ['前移', '删除'];
//       }
//     } else {
//       // 多个元素
//       if (index == 0) {
//         return ['后移', '删除'];
//       } else if (index == lists.length - 1) {
//         return ['前移', '删除'];
//       } else {
//         return ['前移', '后移', '删除'];
//       }
//     }
//   }
//
//   _getAddIcon() {
//     return iconInfo;
//   }
//
//   _buildIcon(ProcessInfo processInfo, int index) {
//     double width = 40;
//     if (processInfo.userId == "-1") {
//       return InkWell(
//           onTap: () {
//             showContact(index);
//           },
//           child: Image(
//               image: AssetImage(processInfo.avatarImg),
//               width: width,
//               height: width));
//     } else {
//       return showAvatorIcon(
//           avatarImg: processInfo.avatarImg, name: processInfo.approveName);
//     }
//   }
//
//   // 添加联系人
//   showContact(int index) {
//     unFocus();
//     FocusManager.instance.primaryFocus?.unfocus();
//     BoostNavigator.instance.push("teacher_select_page", arguments: {
//       'router': "repair_add_page",
//       'isShowDepCheck': false
//     }).then((value) {
//       print("list: ${ListUtils.selecters}");
//
//       setState(() {
//         ListUtils.selecters.forEach((item) {
//           var p = ProcessInfo(
//               avatarImg: item.avatorUrl,
//               userId: item.id,
//               approveName: item.name);
//
//           if (isDefault) {
//             if (index == 0) {
//               if (!defaultApproves.contains(p)) {
//                 defaultApproves.insert(defaultApproves.length - 1, p);
//               }
//             } else {
//               // 通知人
//               if (!defaultNotices.contains(p)) {
//                 defaultNotices.insert(defaultNotices.length - 1, p);
//               }
//             }
//           } else {
//             if (index == 0) {
//               if (!customerApproves.contains(p)) {
//                 customerApproves.insert(customerApproves.length - 1, p);
//               }
//             } else {
//               // 通知人
//               if (!customerNotices.contains(p)) {
//                 customerNotices.insert(customerNotices.length - 1, p);
//               }
//             }
//           }
//         });
//       });
//     });
//   }
//
//   timeClick() {
//     Pickers.showDatePicker(
//       context,
//       mode: DateMode.YMD,
//       suffix: Suffix.normal(),
//       onConfirm: (p) {
//         String time = '${p.year}-${p.month}-${p.day}';
//         setState(() {
//           needDate = time;
//         });
//       },
//     );
//   }
// }
