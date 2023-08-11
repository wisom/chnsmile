import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/reimburse/reimburse_tab_page.dart';
import 'package:chnsmile_flutter/page/student_leave/student_leave_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class StudentLeavePage extends OABaseState {
  final Map params;
  bool isFromOA=false;

  StudentLeavePage({Key key, this.params}) : super(key: key, params: params){
    isFromOA = params['isFromOA'];
  }

  @override
  _StudentLeavePageState createState() => _StudentLeavePageState();
}

class _StudentLeavePageState extends HiOAState<StudentLeavePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaRepairRepairSubmit);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("学生请假管理",
          rightTitle: _isTeacher() ? "" : "申请",
          isEnable: !_isTeacher(), rightButtonClick: () {
        BoostNavigator.instance.push('student_leave_add_page', arguments: {"isFromOA": false});
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    setTag("BX");
    super.initState();
    loadDefaultData();
    if (_isTeacher()) {
      // if (widget.hasPermission("school_oa_repair_init"))
      _tabs.add("请假审批");
      // if (widget.hasPermission("school_oa_repair_approve"))
      _tabs.add("收到通知");
      // if (widget.hasPermission("school_oa_repair_information"))
      _tabs.add("缺勤汇总");
    } else {
      _tabs.add("我的发起");
      _tabs.add("我的通知");
    }
    _controller = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _tabBar() {
    return HiTab(
      _tabs.map<Tab>((tab) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tab, style: const TextStyle(fontSize: 15)),
              hiSpace(width: 6),
              tab == '报修审批' && getCount("BX_BXSP") != 0
                  ? HiBadge(unCountMessage: getCount("BX_BXSP"))
                  : Container(),
              tab == '收到通知' && getCount("BX_SDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("BX_SDTZ"))
                  : Container()
            ],
          ),
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: _tabs.map((tab) {
              return StudentLeaveTabPage(
                type: _buildType(tab),
                isTeacher: _isTeacher(),
              );
            }).toList()));
  }

  ///列表类型 1.我的发起；2.请假审批；3.收到通知/我的通知；5.缺勤汇总
  _buildType(String tab) {
    if (tab == "请假审批") {
      return "2";
    } else if (tab == "收到通知") {
      return "3";
    } else if (tab == "我的通知") {
      return "3";
    } else if (tab == "缺勤汇总") {
      return "5";
    } else if (tab == "我的发起") {
      return "1";
    }
    return "1";
  }

  ///是否是老师
  bool _isTeacher() {
    return widget.isFromOA;
  }
}
