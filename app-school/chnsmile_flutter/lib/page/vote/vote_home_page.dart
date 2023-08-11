import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vote.dart';
import 'package:chnsmile_flutter/model/vote_model.dart';
import 'package:chnsmile_flutter/page/vote/vote_page.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/vote_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/view_util.dart';

class VoteHomePage extends OABaseState {
  final Map params;

  VoteHomePage({Key key, this.params}) : super(key: key, params: params);

  @override
  _VoteHomePageState createState() => _VoteHomePageState();
}

class _VoteHomePageState extends HiOAState<VoteHomePage> with SingleTickerProviderStateMixin {

  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  @override
  void initState() {
    setTag("XYTP");
    super.initState();
    _tabs.add("校园投票");
    _controller = TabController(length: _tabs.length, vsync: this);
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
    return appBar("投票");
  }

  _tabBar() {
    return HiTab(
      _tabs.map<Tab>((tab) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tab, style: const TextStyle(fontSize: 15)),
              tab == '校园投票' && getCount("XYTP") != 0 ? HiBadge(unCountMessage: getCount("XYTP")) : Container(),
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
              return _buildTabPage(tab);
            }).toList()));
  }

  Widget _buildTabPage(String tab) {
    return VotePage();
  }
}
