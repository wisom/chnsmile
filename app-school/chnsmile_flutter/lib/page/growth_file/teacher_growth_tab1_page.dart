import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/growth_file_dao.dart';
import 'package:chnsmile_flutter/model/teacher_growth1_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_growth1_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherGrowthTab1Page extends StatefulWidget {
  const TeacherGrowthTab1Page({Key key}) : super(key: key);

  @override
  _TeacherGrowthTab1PageState createState() => _TeacherGrowthTab1PageState();
}

class _TeacherGrowthTab1PageState extends OABaseTabState<
    TeacherGrowth1Model, TeacherGrowth1, TeacherGrowthTab1Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherGrowth1Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(TeacherGrowth1 item) {
    BoostNavigator.instance.push('teacher_growth_detail_page',
        arguments: {"classId": item.classId, "operateDate": item.operateDate});
  }

  @override
  Future<TeacherGrowth1Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherGrowth1Model result =
        await GrowthFileDao.getTab1(pageIndex: pageIndex, pageSize: 10);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherGrowth1> parseList(TeacherGrowth1Model result) {
    return result.list;
  }
}
