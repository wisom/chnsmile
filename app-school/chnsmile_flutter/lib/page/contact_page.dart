import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:chnsmile_flutter/widget/teacher_im_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'contact_tab_page.dart';

class ContactPage extends StatefulWidget {
  final Map params;

  const ContactPage({Key key, this.params}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with SingleTickerProviderStateMixin,PageVisibilityObserver {
  final List<String> _tabs = [];
  TabController _controller;
  VoidCallback removeListener;

  @override
  void initState() {
    super.initState();
    _tabs.add("消息");
    _tabs.add("分组");
    _controller = TabController(length: _tabs.length, vsync: this);
    removeListener = BoostChannel.instance.addEventListener("switchTab", (key, arguments) {
      switchTab();
    });
  }

  @override
  void onPageHide() {
    super.onPageHide();
  }

  @override
  void onPageShow() {
    super.onPageShow();
    switchTab();
  }

  switchTab() {
    _controller.animateTo(0, duration: const Duration(milliseconds: 10));
  }

  String getType(String type) {
    return type == '消息' ? 'message' : 'contact';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    ///移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    removeListener.call();
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
    bool showBackButton = true;
    try {
      if (widget.params["isFromNative"]) {
        showBackButton = false;
      }
    } catch (e) {
      print(e);
    }
    return appBar("通讯录", showBackButton: showBackButton);
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
              return getType(tab) == 'message'
                  ? TeacherIMTabPage(type: getType(tab))
                  : ContactTabPage();
            }).toList()));
  }
}
