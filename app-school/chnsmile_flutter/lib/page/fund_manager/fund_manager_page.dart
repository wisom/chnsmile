import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/page/fund_manager/fund_manager_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

import '../../core/hi_oa_state.dart';
import '../../core/oa_base_state.dart';
import '../../widget/appbar.dart';
import '../../widget/hi_badge.dart';
import '../../widget/hi_tab.dart';

class FundManagerPage extends OABaseState {
  final Map params;

  FundManagerPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _FundManagerPage createState() => _FundManagerPage();
}

class _FundManagerPage extends HiOAState<FundManagerPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  @override
  initState() {
    super.initState();
    // if (widget.hasPermission("school_oa_repair_init"))
    _tabs.add("经费申请");
    // if (widget.hasPermission("school_oa_repair_approve"))
    _tabs.add("经费审批");
    // if (widget.hasPermission("school_oa_repair_approve"))
    _tabs.add("收到通知");
    _controller = TabController(length: _tabs.length, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return appBar('经费支出', rightTitle: "申请", rightButtonClick: () async {
      BoostNavigator.instance.push('fund_manager_add_page');
    });
  }

  _buildBody() {
    return Column(
      children: [_tabBar(), _buildTabView()],
    );
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
              tab == '经费申请' && getCount("BX_BXSP") != 0
                  ? HiBadge(unCountMessage: getCount("BX_BXSP"))
                  : Container(),
              tab == '经费审批' && getCount("BX_SDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("BX_SDTZ"))
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
              return FundManagerTabPage(type: _buildType(tab));
            }).toList()));
  }

  /// (列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改)
  /// 1=经费申请、2=经费审批、3=收到通知
  _buildType(String tab) {
    if (tab == "经费申请") {
      return "1";
    } else if (tab == "经费审批") {
      return "2";
    } else if (tab == "收到通知") {
      return "3";
    } else {
      return "1";
    }
  }

  loadData() {}
}
