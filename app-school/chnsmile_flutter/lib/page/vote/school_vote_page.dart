import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/vote/school_vote_tab1_page.dart';
import 'package:chnsmile_flutter/page/vote/school_vote_tab2_page.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:hi_base/view_util.dart';

class SchoolVotePage extends OABaseState {
  final Map params;

  SchoolVotePage({Key key, this.params}) : super(key: key, params: params);

  @override
  _SchoolVotePageState createState() => _SchoolVotePageState();
}

class _SchoolVotePageState extends HiOAState<SchoolVotePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolHomeVoteAdd);
    setState(() {
      isEnable = result;
    });
  }

  @override
  void initState() {
    setTag("XWTP");
    super.initState();
    ListUtils.cleanSelecter();
    loadDefaultData();
    if (widget.hasPermission("schoolhomevote_index")) _tabs.add("发起投票");
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
    return appBar("投票", rightTitle:  isEnable ? "新建投票" : "", rightButtonClick: () async {
        BoostNavigator.instance.push('school_vote_add_page');
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
              tab == '校园投票' && getCount("XWTP") != 0 ? HiBadge(unCountMessage: getCount("XWTP")) : Container(),
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
    if (tab == "发起投票") {
      return SchoolVoteTab1Page();
    } else {
      return SchoolVoteTab2Page();
    }
  }
}
