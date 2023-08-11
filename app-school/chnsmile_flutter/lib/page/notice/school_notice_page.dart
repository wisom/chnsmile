import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/page/notice/school_notice_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class SchoolNoticePage extends OABaseState {
  final Map params;

  SchoolNoticePage({Key key, this.params}) : super(key: key, params: params);


  @override
  _SchoolNoticePageState createState() => _SchoolNoticePageState();
}

class _SchoolNoticePageState extends HiOAState<SchoolNoticePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  @override
  void initState() {
    setTag("XWTZ");
    super.initState();
    loadDefaultData();
    if (widget.hasPermission("information_initiated")) _tabs.add("发出通知");
    if (widget.hasPermission("school_oa_info_read"))  _tabs.add("收到通知");
    _controller = TabController(length: _tabs.length, vsync: this);
  }

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaInfoAddInfo);
    setState(() {
      isEnable = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavigationBar(),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return appBar("校务通知", rightTitle: isEnable ? "新建" : "", rightButtonClick: () async {
        BoostNavigator.instance.push('school_notice_add_page');
    });
  }

  _tabBar() {
    return HiTab(
      _tabs.map<Tab>((tab) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tab, style: const TextStyle(fontSize: 15)),
              tab == '收到通知' && getCount("XWTZ_SDTZ") != 0 ? HiBadge(unCountMessage: getCount("XWTZ_SDTZ")) : Container()
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
              return SchoolNoticeTabPage(type: tab);
            }).toList()));
  }
}
