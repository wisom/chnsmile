import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

///通用底层带分页和刷新的页面框架
///M为Dao返回数据模型，L为列表数据模型，T为具体widget
abstract class OABaseTabState<M, L, T extends StatefulWidget> extends HiBaseTabState<M, L, T> with PageVisibilityObserver {

  @override
  void onPageHide() {
    super.onPageHide();
    print("OABaseTabState - onPageHide");
  }

  @override
  void onPageShow() {
    super.onPageShow();
    print("OABaseTabState - onPageShow :");
    ListUtils.cleanSelecter();
    loadData();
  }

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
}
