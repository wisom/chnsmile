import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/model/oa_mark_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

abstract class HiOAState<T extends StatefulWidget> extends State<T> with PageVisibilityObserver  {

  List<Mark> unReadList = [];
  var tag = "";
  VoidCallback imListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    ///移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setTag(String tag) {
    this.tag = tag;
  }

  @override
  void onPageShow() {
    super.onPageShow();
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    imListener = BoostChannel.instance.addEventListener("triggerUnRead", (key, arguments) {
      _loadData();
      return;
    });
  }

  void _loadData() async {
    if (tag == "") return;
    OAMarkModel result = await HomeDao.getMark(tag);
    setState(() {
      if (result != null && result.list != null && result.list.isNotEmpty) {
        unReadList = result.list;
      }
    });
  }

  getCount(String module) {
    if (unReadList.isEmpty) return 0;
    for (Mark item in unReadList) {
      if (item == null) return 0;
      if (module == item.module) {
        return item.count;
      }
    }
  }
}
