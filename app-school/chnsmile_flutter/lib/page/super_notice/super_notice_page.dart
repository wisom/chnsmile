import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/super_notice/super_notice_list_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
///上级通知
class SuperNoticePage extends OABaseState {
  final Map params;

  SuperNoticePage({Key key, this.params}) : super(key: key, params: params);

  @override
  _SuperNoticePageState createState() => _SuperNoticePageState();
}

class _SuperNoticePageState extends HiOAState<SuperNoticePage>
    with SingleTickerProviderStateMixin {
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolOaRepairRepairSubmit);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("上级信息"),
      body: SuperNoticeListPage(),
    );
  }

  @override
  void initState() {
    super.initState();
    loadDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
