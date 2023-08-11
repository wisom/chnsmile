// import 'package:chnsmile_flutter/utils/common.dart';
// import 'package:chnsmile_flutter/utils/format_util.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:flutter/material.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/view_util.dart';
//
// import '../../model/reimburse_model.dart';
//
// class ReimburseCard extends StatelessWidget {
//   final String type;
//   final Reimburse item;
//   final ValueChanged<Reimburse> onCellClick;
//
//   const ReimburseCard({Key key, this.type, this.item, this.onCellClick})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           onCellClick(item);
//         },
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(border: borderLine(context)),
//           padding:
//               const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 8),
//           child: Column(
//             children: [
//               _buildContent(),
//               hiSpace(height: 13),
//               line(context),
//               hiSpace(height: 11),
//               _buildBottom(),
//             ],
//           ),
//         ));
//   }
//
//   _buildContent() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ///列表类型 1.发起列表；2.审批列表；3.通知列表；
//             (type == "2" || type == "3")
//                 ? Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(item.createName + "发出的报销申请",
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   color: HiColor.color_181717,
//                                   fontWeight: FontWeight.bold)),
//                           type == "3"
//                               ? Text(
//                                   "    " + buildOAStatus(item.status)[1],
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       color: HiColor.color_181717,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               : Container()
//                         ],
//                       ),
//                       hiSpace(height: 8)
//                     ],
//                   )
//                 : Container(),
//             Container(
//                 width: 250,
//                 child: Row(
//                   children: [
//                     Text('报销事由:',
//                         style:
//                             TextStyle(fontSize: 14, color: getColorByType())),
//                     Expanded(
//                         child: Text(item.reimbursementCause,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontSize: 14, color: getColorByType()))),
//                   ],
//                 )),
//             hiSpace(height: 8),
//             Row(
//               children: [
//                 const Text('报销总额:',
//                     style: TextStyle(
//                         fontSize: 14, color: HiColor.color_181717_A50)),
//                 hiSpace(width: 6),
//                 Text((item.budgetPriceTotal ?? 0).toString(),
//                     style: const TextStyle(
//                         fontSize: 14, color: HiColor.color_00B0F0)),
//               ],
//             )
//           ],
//         ),
//         Container(
//           height: 24,
//           width: 60,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               color: getStatusColor(), borderRadius: BorderRadius.circular(12)),
//           child: Text(
//             buildOAStatus(item.status)[1],
//             style: const TextStyle(fontSize: 12, color: Colors.white),
//           ),
//         )
//       ],
//     );
//   }
//
//   _buildBottom() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Text("表单编号",
//                 style:
//                     TextStyle(fontSize: 10, color: HiColor.color_181717_A50)),
//             hiSpace(width: 16),
//             type == "1"
//                 ? Text(item.formId,
//                     style: const TextStyle(
//                         fontSize: 10, color: HiColor.color_181717_A50))
//                 : Text(item.formId,
//                     style: const TextStyle(
//                         fontSize: 10, color: HiColor.color_181717)),
//           ],
//         ),
//         Text(
//             getTextByType() +
//                 '日期  ${type == "2" ? dateYearMothAndDayAndMinutes(item.reimbursementDate.replaceAll(".000", "")) : dateYearMothAndDay(item.reimbursementDate.replaceAll(".000", ""))}',
//             style:
//                 const TextStyle(fontSize: 10, color: HiColor.color_181717_A50)),
//       ],
//     );
//   }
//
//   getTextByType() {
//     if (type == "1") {
//       return "报销";
//     } else if (type == "2") {
//       return "发起";
//     } else if (type == "3") {
//       return "通知";
//     } else {
//       return "";
//     }
//   }
//
//   Color getStatusColor() {
//     if (type == "2") {
//       return buildOAApplyStatus(item.status)[0];
//     } else if (type == "3") {
//       return buildOAApplyNoticeStatus(item.reviewStatus)[0];
//     } else {
//       return buildOAStatus(item.status)[0];
//     }
//   }
//
//   Color getColorByType() {
//     if (type == "3") {
//       return HiColor.color_181717_A50;
//     } else {
//       return HiColor.color_181717;
//     }
//   }
// }
