// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/view_util.dart';
//
// import '../../core/hi_state.dart';
// import '../../model/fund_manager_item_param.dart';
// import '../../model/reimburse_item_detail.dart';
//
// typedef VoidCallback = void Function(
//     String classId, String userId, bool isSelected);
//
// class ReimburseDetailCard extends StatefulWidget {
//   final ReimburseItemDetail item;
//   final List<ReimburseItemDetail> subItems;
//
//   const ReimburseDetailCard({Key key, this.item, this.subItems})
//       : super(key: key);
//
//   @override
//   _ReimburseDetailCardState createState() => _ReimburseDetailCardState();
// }
//
// class _ReimburseDetailCardState extends HiState<ReimburseDetailCard> {
//   // @override
//   // double topHeight() {
//   //   return 40;
//   // }
//   //
//   // @override
//   // double marginLR() {
//   //   return 10;
//   // }
//
//   // @override
//   // buildContent() {
//   //   // if (widget.subItems == null) return Container();
//   //   return Column(
//   //     children: [
//   //       Padding(
//   //         padding: EdgeInsets.only(top: 20),
//   //         child: Row(
//   //           children: [
//   //             const Text(
//   //               "项目名称：",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//   //             ),
//   //             Text(
//   //               "项目名称：",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_00B0F0),
//   //             ),
//   //             Text(
//   //               "单      位：",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//   //             ),
//   //             Text(
//   //               "台",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       Padding(
//   //         padding: EdgeInsets.fromLTRB(0, 10, 0, 18),
//   //         child: Row(
//   //           children: [
//   //             const Text(
//   //               "购买数量：",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//   //             ),
//   //             Text(
//   //               "5台",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//   //             ),
//   //             Text(
//   //               "物品单价：",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//   //             ),
//   //             Text(
//   //               "1000.00",
//   //               style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       line(context)
//   //     ],
//   //   );
//   //   // if (widget.subItems == null) return Container();
//   //   // return Column(
//   //   //   children: widget.subItems.asMap().entries.map((entry) {
//   //   //   int index = entry.key;
//   //   //   StudentParentInfo item = entry.value;
//   //   //     return Container(
//   //   //       height: 50,
//   //   //       decoration: BoxDecoration(
//   //   //         border: (index != widget.subItems.length - 1) ? borderLine(context) : const Border(bottom: BorderSide.none)
//   //   //       ),
//   //   //       child: InkWell(
//   //   //         onTap: () {
//   //   //           // 打开聊天页面
//   //   //           BoostNavigator.instance.push(HiConstant.chat + item.userId + '&name=' + item.studentName);
//   //   //         },
//   //   //         child: Row(
//   //   //           children: [
//   //   //             hiSpace(width: 10),
//   //   //             showAvatorIcon(avatarImg: item.avatarImg, name: item.studentName, width: 30, fontSize: 15),
//   //   //             hiSpace(width: 10),
//   //   //             Text('${item.studentName} - ${item.relations} (${item.parentName})', style: const TextStyle(fontSize: 13, color: Colors.black87))
//   //   //           ],
//   //   //         ),
//   //   //       ),
//   //   //     );
//   //   //   }).toList(),
//   //   // );
//   // }
//
//   // @override
//   // buildTop() {
//   //   return Row(
//   //   //   children: [
//   //   //     Container(
//   //   //       padding: const EdgeInsets.only(left: 20, right: 20),
//   //   //       child: Text(
//   //   //         '${widget.item.classGradeName} ${widget.item.className}',
//   //   //         style: const TextStyle(fontSize: 13, color: Colors.black),
//   //   //       ),
//   //   //     )
//   //   //   ],
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Row(
//                     children: [
//                       const Text(
//                         "报销类型：",
//                         style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//                       ),
//                       Text(
//                         widget.item.reimbursementType ?? "",
//                         style: TextStyle(fontSize: 12, color: HiColor.color_00B0F0),
//                       )
//                     ],
//                   )),
//               Expanded(
//                   child: Row(
//                     children: [
//                       const Text(
//                         "发票数量：",
//                         style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//                       ),
//                       Text(
//                         (widget.item.count ?? 0).toString(),
//                         style: const TextStyle(
//                             fontSize: 12, color: HiColor.color_181717),
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Row(
//                     children: [
//                       const Text(
//                         "报销金额：",
//                         style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//                       ),
//                       Text(
//                         (widget.item.amount ?? 0.0).toString(),
//                         style: const TextStyle(
//                             fontSize: 12, color: HiColor.color_181717),
//                       ),
//                     ],
//                   )),
//               Expanded(child: Container())
//             ],
//           ),
//         ),
//         line(context, margin: const EdgeInsets.fromLTRB(14, 0, 14, 0)),
//         hiSpace(height: 10),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
//           child: Row(
//             children: [
//               const Text(
//                 "单项预计总额：",
//                 style: TextStyle(fontSize: 12, color: HiColor.color_787777),
//               ),
//               Text(
//                 (widget.item.amount ?? 0.0).toString(),
//                 style:
//                 const TextStyle(fontSize: 12, color: HiColor.color_181717),
//               ),
//             ],
//           ),
//         ),
//         hiSpace(height: 20),
//         line(context),
//       ],
//     );
//   }
// }
