import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/page/super_file/super_file_list_page.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
///上级文件
class SuperFilePage extends OABaseState {
  final Map params;

  SuperFilePage({Key key, this.params}) : super(key: key, params: params);

  @override
  _SuperFilePageState createState() => _SuperFilePageState();
}

class _SuperFilePageState extends HiOAState<SuperFilePage>
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
      appBar: appBar("上级文件"),
      body: SuperFileListPage(),
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
