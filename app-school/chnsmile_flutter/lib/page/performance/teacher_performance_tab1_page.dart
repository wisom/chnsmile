import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/performance_dao.dart';
import 'package:chnsmile_flutter/model/teacher_performance1_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_performance1_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherPerformanceTab1Page extends StatefulWidget {
  const TeacherPerformanceTab1Page({Key key}) : super(key: key);

  @override
  _TeacherPerformanceTab1PageState createState() =>
      _TeacherPerformanceTab1PageState();
}

class _TeacherPerformanceTab1PageState extends OABaseTabState<
    TeacherPerformance1Model, TeacherPerformance1, TeacherPerformanceTab1Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherPerformance1Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(TeacherPerformance1 item) {
    BoostNavigator.instance.push('teacher_performance_detail_page',
        arguments: {"classId": item.classId, "operateDate": item.operateDate});
  }

  @override
  Future<TeacherPerformance1Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherPerformance1Model result =
        await PerformanceDao.getTab1(pageIndex: pageIndex, pageSize: 10);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherPerformance1> parseList(TeacherPerformance1Model result) {
    return result.rows;
  }
}
