import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'clock_in_teacher_page.dart';

class ClockInPage extends OABaseState {
  final Map params;
  String isTeacher = "0"; //(0:查询教师的打卡列表，2：查询学生的打卡列表)

  ClockInPage({Key key, this.params, this.isTeacher})
      : super(key: key, params: params);

  @override
  _ClockInPageState createState() => _ClockInPageState();
}

class _ClockInPageState extends HiOAState<ClockInPage>
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
      appBar: appBar("打卡", rightTitle: "新建", rightButtonClick: () async {
        BoostNavigator.instance.push('clock_in_add_page');
      }),
      body: ClockInRolePage(isSchool: widget.isTeacher),
    );
  }

  @override
  void initState() {
    setTag("BX");
    super.initState();
    loadDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
