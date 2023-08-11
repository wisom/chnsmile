import 'package:chnsmile_flutter/page/growth_file/teacher_growth_tab1_page.dart';
import 'package:chnsmile_flutter/page/growth_file/teacher_growth_tab2_page.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab2_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class TeacherGrowthPage extends StatefulWidget {

  @override
  _TeacherGrowthPageState createState() =>
      _TeacherGrowthPageState();
}

class _TeacherGrowthPageState
    extends State<TeacherGrowthPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("成长档案", rightTitle: "添加", rightButtonClick: () {
        BoostNavigator.instance
            .push('teacher_growth_add_page');
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabs.add("班级");
    _tabs.add("个人");
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
          text: tab,
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
    if (tab == "班级") {
      return TeacherGrowthTab1Page();
    } else {
      return TeacherGrowthTab2Page();
    }
  }
}
