import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/document/document_tab_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class DocumentPage extends OABaseState {
  final Map params;

  DocumentPage({Key key, this.params}) : super(key: key, params: params);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends HiOAState<DocumentPage>
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
    setTag("GWLZ");
    super.initState();
    loadDefaultData();
    if (widget.hasPermission("schooloa_document_init")) _tabs.add("公文发起");
    if (widget.hasPermission("school_oa_document_approve")) _tabs.add("公文审批");
    if (widget.hasPermission("school_oa_document_information")) _tabs.add("收到通知");
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
    return appBar("公文流转", rightTitle: isEnable ? "新建" : "", rightButtonClick: () async {
        BoostNavigator.instance.push('document_add_page');
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
              tab == '公文审批' && getCount("GWLZ_GWSP") != 0 ? HiBadge(unCountMessage: getCount("GWLZ_GWSP")) : Container(),
              tab == '收到通知' && getCount("GWLZ_SDTZ") != 0 ? HiBadge(unCountMessage: getCount("GWLZ_SDTZ")) : Container()
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
              return DocumentTabPage(type: tab);
            }).toList()));
  }
}
