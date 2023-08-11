import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/student_leave_early/student_leave_early_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class StudentLeaveEarlyPage extends OABaseState {
  final Map params;

  StudentLeaveEarlyPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _StudentLeaveEarlyPageState createState() => _StudentLeaveEarlyPageState();
}

class _StudentLeaveEarlyPageState extends HiOAState<StudentLeaveEarlyPage>
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
      appBar: appBar("早退管理"),
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
      // if (widget.hasPermission("school_oa_repair_init"))
      _tabs.add("早退申报");
      // if (widget.hasPermission("school_oa_repair_approve"))
      _tabs.add("早退审批");
      // if (widget.hasPermission("school_oa_repair_information"))
      _tabs.add("收到通知");
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
              return StudentLeaveEarlyTabPage(
                type: _buildType(tab),
                isTeacher: true,
              );
            }).toList()));
  }

  ///列表类型 1.早退申报；2.早退审批；3.收到通知；
  _buildType(String tab) {
    if (tab == "早退申报") {
      return "1";
    } else if (tab == "早退审批") {
      return "2";
    } else if (tab == "收到通知") {
      return "3";
    }
    return "1";
  }
}
