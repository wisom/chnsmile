// import 'package:chnsmile_flutter/model/info_collection_model.dart';
// import 'package:chnsmile_flutter/utils/common.dart';
// import 'package:chnsmile_flutter/utils/format_util.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:flutter/material.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/view_util.dart';
//
// class InfoCollectionApproveCard extends StatelessWidget {
//   final InfoCollection item;
//   final ValueChanged<InfoCollection> onCellClick;
//   final String type;
//
//   const InfoCollectionApproveCard({Key key, this.item, this.onCellClick, this.type})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           onCellClick(item);
//         },
//         child: Container(
//           decoration: BoxDecoration(border: borderLine(context)),
//           padding:
//               const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
//           child: Column(
//             children: [
//               _buildContent(context),
//               hiSpace(height: 6),
//               _buildTime()
//             ],
//           ),
//         ));
//   }
//
//   bool get isNotice {
//     return type == "1";
//   }
//
//   bool get isApprove {
//     return type == "0";
//   }
//
//   /// 审批中状态
//   bool get isApply {
//     if (item == null) {
//       return false;
//     }
//     return item.releaseStatus == 1;
//   }
//
//   _buildContent(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('${item.cname}的报修申请',
//                     style: const TextStyle(fontSize: 13, color: Colors.black)),
//                 hiSpace(width: 6),
//                 isNotice
//                     ? Text('${buildOAStatus(item.status)[1]}',
//                         style: TextStyle(
//                             fontSize: 12, color: buildOAStatus(item.status)[0]))
//                     : Container()
//               ],
//             ),
//             hiSpace(height: 6),
//             Row(
//               children: [
//                 const Text('表单编号:',
//                     style: TextStyle(fontSize: 13, color: Colors.grey)),
//                 Text(item.formId,
//                     style: const TextStyle(fontSize: 13, color: Colors.grey))
//               ],
//             ),
//           ],
//         )),
//         hiSpace(width: 12),
//         isNotice
//             ? item.reviewStatus == 2 ? buildReadUnReadStatus('已读', Colors.green) : buildReadUnReadStatus('未读', Colors.red)
//             : Container(
//                 height: 24,
//                 width: 60,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: buildOAApplyStatus(item.reviewStatus)[0],
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Text(
//                   buildOAApplyStatus(item.reviewStatus)[1],
//                   style: const TextStyle(fontSize: 13, color: Colors.white),
//                 ),
//               )
//       ],
//     );
//   }
//
//   bool get isRefuse {
//     return item.reviewStatus == 3;
//   }
//
//   _buildTime() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Text('报修物品: ',
//                 style: TextStyle(fontSize: 13, color: Colors.grey)),
//             Text(item.repairMer,
//                 style: const TextStyle(fontSize: 13, color: Colors.grey))
//           ],
//         ),
//         hiSpace(height: 6),
//         Row(
//           children: [
//             isApprove ?
//             Text('报修日期:${dateYearMothAndDay(item.ddate.replaceAll(".000", ""))}',
//                 style: const TextStyle(fontSize: 13, color: Colors.grey)) :
//             Text('通知时间:${dateYearMothAndDayAndMinutes(item.ddate.replaceAll(".000", ""))}',
//                 style: const TextStyle(fontSize: 13, color: Colors.grey))
//           ],
//         ),
//       ],
//     );
//   }
// }
