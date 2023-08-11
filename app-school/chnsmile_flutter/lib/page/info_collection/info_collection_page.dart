import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

import 'info_collection_tab_page.dart';

class InfoCollectionPage extends OABaseState {
  final Map params;

  InfoCollectionPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _RepairPageState createState() => _RepairPageState();
}

class _RepairPageState extends HiOAState<InfoCollectionPage>
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
      appBar: appBar("信息采集", rightTitle: isEnable ? "新建" : "",
          rightButtonClick: () async {
        BoostNavigator.instance.push('info_collection_add_page');
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
    if (widget.hasPermission("school_oa_repair_init")) _tabs.add("我发起的统计单");
    if (widget.hasPermission("school_oa_repair_approve")) _tabs.add("我填写的统计单");
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
              return InfoCollectionTabPage(type: _buildType(tab));
            }).toList()));
  }

  /// (0:查询教师发起的列表，1：查询我填写的)
  _buildType(String tab) {
    if (tab == "我发起的统计单") {
      return "0";
    } else if (tab == "我填写的统计单") {
      return "1";
    } else {
      return "0";
    }
  }
}
