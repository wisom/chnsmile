import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/growth_file_dao.dart';
import 'package:chnsmile_flutter/model/teacher_growth2_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_growth2_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherGrowthTab2Page extends StatefulWidget {
  final String type;

  const TeacherGrowthTab2Page({Key key, this.type}) : super(key: key);

  @override
  _TeacherGrowthTab2PageState createState() =>
      _TeacherGrowthTab2PageState();
}

class _TeacherGrowthTab2PageState extends HiBaseTabState<
    TeacherGrowth2Model, TeacherGrowth2, TeacherGrowthTab2Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherGrowth2Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(TeacherGrowth2 item) {
    BoostNavigator.instance
        .push('teacher_growth_detail2_page', arguments: {"item": item});
  }

  @override
  Future<TeacherGrowth2Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherGrowth2Model result =
        await GrowthFileDao.getTab2(pageIndex: pageIndex, pageSize: 10);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherGrowth2> parseList(TeacherGrowth2Model result) {
    return result.rows;
  }
}
