import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab2_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class TeacherPerformancePage extends StatefulWidget {

  @override
  _TeacherPerformancePageState createState() =>
      _TeacherPerformancePageState();
}

class _TeacherPerformancePageState
    extends State<TeacherPerformancePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolBehaviorAdd);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("在校表现", isEnable: isEnable, rightTitle: "添加", rightButtonClick: () async {
          BoostNavigator.instance
              .push('teacher_performance_add_page');
      }),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadDefaultData();
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
      return TeacherPerformanceTab1Page();
    } else {
      return TeacherPerformanceTab2Page();
    }
  }
}
