import 'package:chnsmile_flutter/page/notice/read/teacher_notice_read_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';

class TeacherNoticeReadPage extends StatefulWidget {
  final Map params;
  String id;
  String classId;
  String className;
  String unReadSum;
  int userOperateType;
  int status;

  TeacherNoticeReadPage({Key key, this.params}) : super(key: key) {
    id = params.isNotEmpty ? params['id'] : "";
    classId = params.isNotEmpty ? params['classId'] : "";
    className = params.isNotEmpty ? params['className'] : "查看";
    unReadSum = params.isNotEmpty ? params['unReadSum'].toString() : "0";
    userOperateType = params.isNotEmpty ? params['userOperateType'] : 0;
    status = params.isNotEmpty ? params['status'] : 0;
  }

  @override
  _TeacherNoticeReadPageState createState() => _TeacherNoticeReadPageState();
}

class _TeacherNoticeReadPageState extends State<TeacherNoticeReadPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.className),
      body: Column(
        children: [_tabBar(), _buildTabView()],
      ),
    );
  }

  bool get isRead {
    return widget.userOperateType == 0;
  }

  getOperateType() {
    return isRead ? '查看' : '确认';
  }

  @override
  void initState() {
    super.initState();
    _tabs.add("已${getOperateType()}");
    _tabs.add("未${getOperateType()}");
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
              return TeacherNoticeReadTabPage(
                  id: widget.id,
                  classId: widget.classId,
                  type: tab == '已${getOperateType()}' ? 0 : 1,
                  typeText: getOperateType(),
                  status: widget.status);
            }).toList()));
  }
}
