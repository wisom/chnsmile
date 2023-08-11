import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'file_report_tab_page.dart';

///文件发起、文件上报
class FileReportPage extends OABaseState {
  final Map params;

  FileReportPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _FileReportPageState createState() => _FileReportPageState();
}

class _FileReportPageState extends HiOAState<FileReportPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = [];
  TabController _controller;

  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaDocumentSubmitDocument);
    setState(() {
      isEnable = result;
    });
  }

  @override
  void initState() {
    setTag("WJFQ");
    super.initState();
    loadDefaultData();
    _tabs.add("文件发起");
    _tabs.add("文件审批");
    _tabs.add("我的通知");
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
    return appBar("文件发起", rightTitle: isEnable ? "新建" : "",
        rightButtonClick: () async {
      BoostNavigator.instance.push('file_report_add_page');
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
              // hiSpace(width: 3),
              tab == '公文审批' && getCount("WJFQ_WJSP") != 0
                  ? HiBadge(unCountMessage: getCount("WJFQ_WJSP"))
                  : Container(),
              tab == '收到通知' && getCount("WJFQ_WDTZ") != 0
                  ? HiBadge(unCountMessage: getCount("WJFQ_WDTZ"))
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
              return FileReportTabPage(type: tab);
            }).toList()));
  }
}
