import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vacation_dao.dart';
import 'package:chnsmile_flutter/model/vacation_model1.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/vacation_card2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VacationTab2Page extends StatefulWidget {
  const VacationTab2Page({Key key}) : super(key: key);

  @override
  _VacationTab2PageState createState() => _VacationTab2PageState();
}

class _VacationTab2PageState
    extends OABaseTabState<VacationModel1, Vacation, VacationTab2Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              VacationCard2(item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(Vacation item) {
    BoostNavigator.instance
        .push('vacation_detail_page', arguments: {"id": item.id, "type": 2, "reviewStatus": item.reviewStatus});
  }

  @override
  Future<VacationModel1> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      VacationModel1 result =
          await VacationDao.get(type: 2, pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      print(e);
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<Vacation> parseList(VacationModel1 result) {
    return result.rows;
  }
}
