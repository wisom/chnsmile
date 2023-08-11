import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/growth_file_dao.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/teacher_growth2_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/teacher_growth2_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherGrowthNewPage extends StatefulWidget {
  final String type;

  const TeacherGrowthNewPage({Key key, this.type}) : super(key: key);

  @override
  _TeacherGrowthNewPageState createState() =>
      _TeacherGrowthNewPageState();
}

class _TeacherGrowthNewPageState extends OABaseTabState<
    TeacherGrowth2Model, TeacherGrowth2, TeacherGrowthNewPage> {
  var isLoaded = false;
  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolGrowtharchiveAdd);
    setState(() {
      isEnable = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDefaultData();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.id == event.formId) {
            print("命中了=" + element.id);
            element.status = 1;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {
    ListUtils.cleanSelecter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: Column(children: [Expanded(child: super.build(context))]));
  }

  _buildNavigationBar() {
    return appBar("成长档案",
        rightTitle: "添加", isEnable: isEnable, rightButtonClick: () {
            BoostNavigator.instance
                .push('teacher_growth_add_page').then((value){
              if (value == "success") {
                loadData();
              }
            });
    });
  }


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
    try {
      TeacherGrowth2Model result =
      await GrowthFileDao.getTab2(pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
    }
  }

  @override
  List<TeacherGrowth2> parseList(TeacherGrowth2Model result) {
    return result.rows;
  }
}
