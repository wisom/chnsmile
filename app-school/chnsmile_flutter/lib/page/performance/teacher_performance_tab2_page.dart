import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/performance_dao.dart';
import 'package:chnsmile_flutter/model/teacher_performance2_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_performance2_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherPerformanceTab2Page extends StatefulWidget {
  final String type;

  const TeacherPerformanceTab2Page({Key key, this.type}) : super(key: key);

  @override
  _TeacherPerformanceTab2PageState createState() =>
      _TeacherPerformanceTab2PageState();
}

class _TeacherPerformanceTab2PageState extends OABaseTabState<
    TeacherPerformance2Model, TeacherPerformance2, TeacherPerformanceTab2Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherPerformance2Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(TeacherPerformance2 item) {
    BoostNavigator.instance
        .push('teacher_performance_detail2_page', arguments: {"id": item.id});
  }

  @override
  Future<TeacherPerformance2Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherPerformance2Model result =
        await PerformanceDao.getTab2(pageIndex: pageIndex, pageSize: 10);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherPerformance2> parseList(TeacherPerformance2Model result) {
    return result.rows;
  }
}
