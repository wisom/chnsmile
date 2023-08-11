import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/class_transfer/class_transfer_tab1_page.dart';
import 'package:chnsmile_flutter/page/class_transfer/class_transfer_tab2_page.dart';
import 'package:chnsmile_flutter/page/class_transfer/class_transfer_tab3_page.dart';
import 'package:chnsmile_flutter/page/class_transfer/class_transfer_tab4_page.dart';
import 'package:chnsmile_flutter/page/class_transfer/class_transfer_tab5_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferHomePage extends OABaseState {
  final Map params;

  ClassTransferHomePage({Key key, this.params}) : super(key: key, params: params);

  @override
  _ClassTransferHomePageState createState() => _ClassTransferHomePageState();
}

class _ClassTransferHomePageState extends HiOAState<ClassTransferHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaChangeSendChange);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("调课", rightTitle: isEnable ? "新建" : "", rightButtonClick: () async {
          BoostNavigator.instance.push('class_transfer_add_page');
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    setTag("DK");
    super.initState();
    loadDefaultData();
    if (widget.hasPermission("schooloaChangeManagement")) _tabs.add("调课计划");
    if (widget.hasPermission("school_oa_change_approve")) _tabs.add("调课单确认");
    if (widget.hasPermission("school_oa_change_information")) _tabs.add("收到通知");
    if (widget.hasPermission("school_oa_change_my_change")) _tabs.add("我的调课单");
    if (widget.hasPermission("school_oa_change_my_notice")) _tabs.add("我班的调课通知");
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
              tab == '调课单确认' && getCount("DK_DKDQR") != 0 ? HiBadge(unCountMessage: getCount("DK_DKDQR")) : Container(),
              tab == '收到通知' && getCount("DK_SDTZ") != 0 ? HiBadge(unCountMessage: getCount("DK_SDTZ")) : Container()
            ],
          ),
        );
      }).toList(),
      isScrollable: true,
      controller: _controller,
    );
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: _tabs.map((tab) {
              return _buildTabPage(tab);
            }).toList()));
  }

  Widget _buildTabPage(String tab) {
    if (tab == "调课计划") {
      return ClassTransferTab1Page();
    } else if (tab == "调课单确认") {
      return ClassTransferTab2Page();
    } else if (tab == "收到通知") {
      return ClassTransferTab3Page();
    } else if (tab == "我的调课单") {
      return ClassTransferTab4Page();
    } else if (tab == "我班的调课通知") {
      return ClassTransferTab5Page();
    }
  }
}
