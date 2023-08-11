// import 'package:chnsmile_flutter/core/hi_oa_state.dart';
// import 'package:chnsmile_flutter/core/oa_base_state.dart';
// import 'package:chnsmile_flutter/http/dao/home_dao.dart';
// import 'package:chnsmile_flutter/page/reimburse/reimburse_tab_page.dart';
// import 'package:chnsmile_flutter/utils/view_util.dart';
// import 'package:chnsmile_flutter/widget/appbar.dart';
// import 'package:chnsmile_flutter/widget/hi_badge.dart';
// import 'package:chnsmile_flutter/widget/hi_tab.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_boost/flutter_boost.dart';
// import 'package:hi_base/color.dart';
// import 'package:hi_base/view_util.dart';
//
// import 'clock_in_teacher_page.dart';
//
// class ClockInDetailPage extends OABaseState {
//   final Map params;
//   String isTeacher = "0"; //(0:查询教师的打卡列表，2：查询学生的打卡列表)
//
//   ClockInDetailPage({Key key, this.params, this.isTeacher})
//       : super(key: key, params: params);
//
//   @override
//   _ClockInDetailPageState createState() => _ClockInDetailPageState();
// }
//
// class _ClockInDetailPageState extends HiOAState<ClockInDetailPage>
//     with SingleTickerProviderStateMixin {
//   bool isEnable = false;
//
//   void loadDefaultData() async {
//     var result = await HomeDao.getP(HomeDao.schoolOaRepairRepairSubmit);
//     setState(() {
//       isEnable = result;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar("打卡详情", rightTitle: "新建", rightButtonClick: () async {
//         BoostNavigator.instance.push('clock_in_add_page');
//       }),
//       body: Column(
//         children: [
//           _buildTopInfo(),
//           box(context),
//           _buildCenterInfo(),
//         ],
//       ),
//     );
//   }
//
//   _buildCenterInfo() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(17, 13, 9, 15),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         children: [
//           _buildDay(),
//           GridView.builder(
//             shrinkWrap: true,
//             itemCount: 7,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 mainAxisSpacing: 10, crossAxisCount: 2, childAspectRatio: 8),
//             itemBuilder: (BuildContext context, int index) {
//               return Column(
//                 children: [
//                   const Text(
//                     "日",
//                     style: TextStyle(
//                         fontSize: 12, color: HiColor.color_000000_A25),
//                   ),
//                   hiSpace(height: 9),
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: const BoxDecoration(
//                         color: HiColor.color_00B0F0,
//                         borderRadius: BorderRadius.all(Radius.circular(12))),
//                     child: Text(
//                       "27",
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   )
//                 ],
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   _buildTopInfo() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(17, 13, 9, 15),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         children: [
//           _buildFirstLine(),
//           hiSpace(height: 12),
//           _buildSecondLine(),
//           hiSpace(height: 10),
//           _buildThirdLine(),
//           hiSpace(height: 10),
//           _buildForthLine(),
//         ],
//       ),
//     );
//   }
//
//   _buildDay() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "已进行",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//         ),
//         Container(
//           width: 71,
//           height: 20,
//           decoration: const BoxDecoration(
//               color: HiColor.color_00B0F0,
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: const Text(
//             "导出明细",
//             style: TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         )
//       ],
//     );
//   }
//
//   _buildForthLine() {
//     return Row(
//       children: [
//         Text(
//           "打卡时间：",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
//         ),
//         Text(
//           "每天",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//         ),
//       ],
//     );
//   }
//
//   _buildThirdLine() {
//     return Row(
//       children: [
//         Text(
//           "打卡频次",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
//         ),
//         Text(
//           "每天",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717),
//         ),
//       ],
//     );
//   }
//
//   _buildSecondLine() {
//     return Row(
//       children: [
//         Text(
//           "参与范围：",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
//         ),
//         Text(
//           "参与范围：",
//           style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
//         ),
//       ],
//     );
//   }
//
//   _buildFirstLine() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Text(
//               "单纯打开",
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: HiColor.color_181717),
//             ),
//             hiSpace(width: 9),
//             Container(
//               width: 48,
//               height: 16,
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 color: HiColor.color_F2F3F3,
//                 borderRadius: BorderRadius.all(Radius.circular(9.5)),
//               ),
//               child: const Text(
//                 "已结束",
//                 style: TextStyle(fontSize: 8, color: HiColor.color_181717_A50),
//               ),
//             )
//           ],
//         ),
//         const Icon(
//           Icons.arrow_forward_ios_outlined,
//           size: 10,
//           color: HiColor.color_3D3D3D,
//         ),
//       ],
//     );
//   }
//
//   @override
//   void initState() {
//     setTag("BX");
//     super.initState();
//     loadDefaultData();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
