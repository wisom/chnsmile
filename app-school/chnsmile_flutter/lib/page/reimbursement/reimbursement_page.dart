import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/reimbursement/reimbursement_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class ReimbursementPage extends OABaseState {
  final Map params;

  ReimbursementPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _ReimbursementPageState createState() => _ReimbursementPageState();
}

class _ReimbursementPageState extends HiOAState<ReimbursementPage>
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
      appBar: appBar("报销申请", rightTitle: isEnable ? "申请" : "",
          rightButtonClick: () async {
        BoostNavigator.instance.push('reimbursement_add_page');
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    setTag("BXIAO");
    super.initState();
    loadDefaultData();
      _tabs.add("报销申请");
      _tabs.add("报销审批");
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
              tab == '报销审批' && getCount("BXIAO_BXSP") != 0
                  ? HiBadge(unCountMessage: getCount("BXIAO_BXSP"))
                  : Container(),
              tab == '收到通知' && getCount("BXIAO_SDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("BXIAO_SDTZ"))
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
              return ReimbursementTabPage(type: _buildType(tab));
            }).toList()));
  }

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  _buildType(String tab) {
    if (tab == "报销申请") {
      return "1";
    } else if (tab == "报销审批") {
      return "2";
    } else if (tab == "收到通知") {
      return "3";
    } else {
      return "4";
    }
  }
}
