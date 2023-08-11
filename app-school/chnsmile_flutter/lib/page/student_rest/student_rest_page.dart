import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/student_rest/student_rest_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/widget/repair_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

///学生请假
class StudentRestPage extends OABaseState {
  final Map params;
  bool isFromOA = false;

  StudentRestPage({Key key, this.params}) : super(key: key, params: params) {
    isFromOA = params['isFromOA'];
  }

  @override
  _StudentRestPageState createState() => _StudentRestPageState();
}

class _StudentRestPageState extends HiOAState<StudentRestPage>
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
      appBar: appBar("学生请假管理", rightTitle: isEnable ? "申请" : "",
          rightButtonClick: () async {
        BoostNavigator.instance.push('student_leave_add_page');
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    setTag("XSQJ");
    super.initState();
    loadDefaultData();
    if (widget.isFromOA) {
      _tabs.add("请假审批");
      _tabs.add("收到通知");
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
              tab == '请假审批' && getCount("XSQJ_QJSP") != 0
                  ? HiBadge(unCountMessage: getCount("XSQJ_QJSP"))
                  : Container(),
              tab == '收到通知' && getCount("XSQJ_SDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("XSQJ_SDTZ"))
                  : Container(),
              tab == '我的通知' && getCount("XSQJ_WDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("XSQJ_WDTZ"))
                  : Container(),
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
              return StudentRestTabPage(type: _buildType(tab),isFromOA: widget.isFromOA,);
              // return RepairTabPage(type: _buildType(tab));
            }).toList()));
  }

  ///列表类型 1.我的发起；2.请假审批；3.收到通知/我的通知；5.缺勤汇总
  _buildType(String tab) {
    if (tab == "请假审批" && widget.isFromOA == true) {
      return "2";
    } else if (tab == "收到通知" && widget.isFromOA == true) {
      return "3";
    } else if (tab == "我的通知" && widget.isFromOA == false) {
      return "3";
    } else if (tab == "缺勤汇总" && widget.isFromOA == true) {
      return "5";
    } else if (tab == "我的发起" && widget.isFromOA == false) {
      return "1";
    }
    return "1";
  }
}
