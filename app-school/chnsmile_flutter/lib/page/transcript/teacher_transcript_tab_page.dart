import 'package:chnsmile_flutter/page/growth_file/teacher_growth_tab1_page.dart';
import 'package:chnsmile_flutter/page/growth_file/teacher_growth_tab2_page.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab2_page.dart';
import 'package:chnsmile_flutter/page/transcript/teacher_transcript_tab1_page.dart';
import 'package:chnsmile_flutter/page/transcript/teacher_transcript_tab2_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/page/performance/teacher_performance_tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class TeacherTranscriptTabPage extends StatefulWidget {
  final Map params;
  String examId;

  TeacherTranscriptTabPage({Key key, this.params}) : super(key: key) {
    examId = params['examId'];
  }

  @override
  _TeacherTranscriptTabPageState createState() =>
      _TeacherTranscriptTabPageState();
}

class _TeacherTranscriptTabPageState
    extends State<TeacherTranscriptTabPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("成绩单"),
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
      return TeacherTranscriptTab1Page(examId: widget.examId);
    } else {
      return TeacherTranscriptTab2Page(examId: widget.examId);
    }
  }
}
