import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/vacation/vacation_tab2_page.dart';
import 'package:chnsmile_flutter/page/vacation/vacation_tab3_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/page/vacation/vacation_tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:hi_base/view_util.dart';

class VacationPage extends OABaseState {
  final Map params;

  VacationPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _VacationPageState createState() => _VacationPageState();
}

class _VacationPageState extends HiOAState<VacationPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaLeaveSubmitLeave);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("请假", rightTitle: isEnable ? "申请" : "", rightButtonClick: () async {
        if (await HomeDao.getP(HomeDao.schoolOaLeaveSubmitLeave)) {
          BoostNavigator.instance.push('vacation_add_page');
        }
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    setTag("QJ");
    super.initState();
    loadDefaultData();
    if (widget.hasPermission("school_oa_leave_my_leave_apply")) _tabs.add("请假申报");
    if (widget.hasPermission("school_oa_leave_my_approve_leave_apply")) _tabs.add("请假审批");
    if (widget.hasPermission("school_oa_leave_my_approve_leave_received")) _tabs.add("收到通知");
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
              tab == '请假审批' && getCount("QJ_QJSP") != 0 ? HiBadge(unCountMessage: getCount("QJ_QJSP")) : Container(),
              tab == '收到通知' && getCount("QJ_SDTZ") != 0 ? HiBadge(unCountMessage: getCount("QJ_SDTZ")) : Container()
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
              return  _buildTabPage(tab);
            }).toList()));
  }

  Widget _buildTabPage(String tab) {
    if (tab == "请假申报") {
      return VacationTab1Page();
    } else if (tab == "请假审批") {
      return VacationTab2Page();
    } else {
      return VacationTab3Page();
    }
  }
}
