// import 'package:chnsmile_flutter/core/hi_oa_state.dart';
// import 'package:chnsmile_flutter/core/oa_base_state.dart';
// import 'package:chnsmile_flutter/http/dao/home_dao.dart';
// import 'package:chnsmile_flutter/page/reimburse/reimburse_tab_page.dart';
// import 'package:chnsmile_flutter/widget/appbar.dart';
// import 'package:chnsmile_flutter/widget/hi_badge.dart';
// import 'package:chnsmile_flutter/widget/hi_tab.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_boost/flutter_boost.dart';
// import 'package:hi_base/view_util.dart';
//
// class ReimbursePage extends OABaseState {
//   final Map params;
//
//   ReimbursePage({Key key, this.params}) : super(key: key, params: params);
//
//   @override
//   _ReimbursePageState createState() => _ReimbursePageState();
// }
//
// class _ReimbursePageState extends HiOAState<ReimbursePage>
//     with SingleTickerProviderStateMixin {
//   final List<String> _tabs = [];
//   TabController _controller;
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
//       appBar: appBar("报销申请", rightTitle: isEnable ? "申请" : "",
//           rightButtonClick: () async {
//         BoostNavigator.instance.push('reimburse_add_page');
//       }),
//       body: Column(
//         children: [_tabBar(), _buildTabView()],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     setTag("BX");
//     super.initState();
//     loadDefaultData();
//     // if (widget.hasPermission("school_oa_repair_init"))
//       _tabs.add("报销申请");
//     // if (widget.hasPermission("school_oa_repair_approve"))
//       _tabs.add("报销审批");
//     // if (widget.hasPermission("school_oa_repair_information"))
//       _tabs.add("收到通知");
//     _controller = TabController(length: _tabs.length, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   _tabBar() {
//     return HiTab(
//       _tabs.map<Tab>((tab) {
//         return Tab(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(tab, style: const TextStyle(fontSize: 15)),
//               hiSpace(width: 6),
//               tab == '报修审批' && getCount("BX_BXSP") != 0
//                   ? HiBadge(unCountMessage: getCount("BX_BXSP"))
//                   : Container(),
//               tab == '收到通知' && getCount("BX_SDTZ") != 0
//                   ? HiBadge(unCountMessage: getCount("BX_SDTZ"))
//                   : Container()
//             ],
//           ),
//         );
//       }).toList(),
//       controller: _controller,
//     );
//   }
//
//   _buildTabView() {
//     return Flexible(
//         child: TabBarView(
//             controller: _controller,
//             children: _tabs.map((tab) {
//               return ReimburseTabPage(type: _buildType(tab));
//             }).toList()));
//   }
//
//   ///列表类型 1.发起列表；2.审批列表；3.通知列表；
//   ///列表类型 1.报销申请；2.报销审批；3.收到通知；
//   _buildType(String tab) {
//     if (tab == "报销申请") {
//       return "1";
//     } else if (tab == "报销审批") {
//       return "2";
//     } else {
//       return "3";
//     }
//   }
// }
