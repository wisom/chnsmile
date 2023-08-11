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
import 'class_photo_tab_page.dart';

class ClassPhotoPage extends OABaseState {
  final Map params;

  ClassPhotoPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _ClassPhotoPage createState() => _ClassPhotoPage();
}

class _ClassPhotoPage extends HiOAState<ClassPhotoPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  @override
  initState() {
    super.initState();
    _tabs.add("最新动态");
    _tabs.add("相册");
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
    return appBar('班级相册', rightTitle: "新建", rightButtonClick: () async {
      BoostNavigator.instance.push('class_photo_add_page');
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
              return ClassPhotoTabPage(type: _buildType(tab));
            }).toList()));
  }

  /// 列表类型 1.我的；2.全部
  _buildType(String tab) {
    if (tab == "最新动态") {
      return "1";
    } else if (tab == "相册") {
      return "2";
    }
  }

  loadData() {}
}
