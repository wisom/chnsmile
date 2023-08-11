import 'package:chnsmile_flutter/core/hi_oa_state.dart';
import 'package:chnsmile_flutter/core/oa_base_state.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/utils/clockin_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

import '../../model/clock_in_times_model.dart';
import 'clock_in_card.dart';
import 'clock_in_teacher_page.dart';
import 'clock_in_times_select_card.dart';

class ClockInTimeSelectPage extends OABaseState {
  final Map params;
  final String TAG = "ClockInTimeSelectPage==";

  ClockInTimeSelectPage({Key key, this.params})
      : super(key: key, params: params);

  @override
  _ClockInTimeSelectPageState createState() => _ClockInTimeSelectPageState();
}

class _ClockInTimeSelectPageState extends HiOAState<ClockInTimeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("打卡频次", rightTitle: "保存", rightButtonClick: () {
        ClockInUtils.cleanTimes();
        var selectSize = 0;
        dataList.forEach((element) {
          if (element.isSelect) {
            // LogUtil.d(widget.TAG, "dataList element=" + element.toString());
            selectSize = selectSize + 1;
            ClockInUtils.addTimes(element);
          }
        });
        // LogUtil.d(widget.TAG, "dataList selectSize=" + selectSize.toString());
        if (selectSize >= 7) {
          ClockInUtils.timesStr = "每天";
        } else {
          String timesTemp = "";
          ClockInUtils.getAllTimes()?.forEach((element) {
            if (element?.content != null && element.content.isNotEmpty) {
              timesTemp = timesTemp + element.content + "、";
            }
          });
          ClockInUtils.timesStr = timesTemp;
        }
        BoostNavigator.instance.popUntil(route: "clock_in_add_page");
      }),
      body: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) =>
              ClockInTimesSelectCard(
                  item: dataList[index], onCellClick: _onCellClick)),
    );
  }

  void _onCellClick(ClockInTimesModel item) {
    dataList.forEach((data) {
      if (item.content == data.content) {
        data.isSelect = !data.isSelect;
      }
      setState(() {});
    });
  }

  List<ClockInTimesModel> dataList = [];

  @override
  void initState() {
    super.initState();
    dataList.clear();
    dataList.add(ClockInTimesModel(content: "周一", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周二", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周三", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周四", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周五", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周六", isSelect: false));
    dataList.add(ClockInTimesModel(content: "周日", isSelect: false));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
