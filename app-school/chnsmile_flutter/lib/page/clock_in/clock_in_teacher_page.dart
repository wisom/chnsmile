import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/clock_in_dao.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/clock_in_model.dart';
import 'clock_in_card.dart';

class ClockInRolePage extends StatefulWidget {
  final String isSchool; //(0:查询教师的打卡列表，2：查询学生的打卡列表)

  const ClockInRolePage({Key key, this.isSchool}) : super(key: key);

  @override
  _ClockInRolePageState createState() => _ClockInRolePageState();
}

class _ClockInRolePageState
    extends OABaseTabState<ClockInModel, ClockIn, ClockInRolePage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void onPageShow() {}

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ClockInCard(
              isSchool: widget.isSchool,
              item: dataList[index],
              onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(ClockIn item) {
    // if (getEditStatus(item.releaseStatus)) {
    //   BoostNavigator.instance
    //       .push('clock_in_add_page', arguments: {"id": item.punchId});
    // } else {
      BoostNavigator.instance.push('clock_in_detail_role_page', arguments: {
        "item": item,
        "type": widget.isSchool
      });
    // }
  }

  @override
  Future<ClockInModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      ClockInModel result =
          await ClockInDao.list(pageIndex, 10, "0");
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      isLoaded = false;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<ClockIn> parseList(ClockInModel result) {
    return result.list;
  }
}
