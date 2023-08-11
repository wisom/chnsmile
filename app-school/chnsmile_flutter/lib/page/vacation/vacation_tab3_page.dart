import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vacation_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vacation_model1.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/vacation_card2.dart';
import 'package:chnsmile_flutter/widget/vacation_card3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VacationTab3Page extends StatefulWidget {
  const VacationTab3Page({Key key}) : super(key: key);

  @override
  _VacationTab3PageState createState() => _VacationTab3PageState();
}

class _VacationTab3PageState
    extends OABaseTabState<VacationModel1, Vacation, VacationTab3Page> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.formId == event.formId) {
            print("命中了....."+element.formId);
            element.reviewStatus = 2;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              VacationCard3(item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(Vacation item) {
    BoostNavigator.instance
        .push('vacation_detail_page', arguments: {"id": item.id, "type": 3});
  }

  @override
  Future<VacationModel1> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      VacationModel1 result =
          await VacationDao.get(type: 3, pageIndex: pageIndex, pageSize: 10);
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
