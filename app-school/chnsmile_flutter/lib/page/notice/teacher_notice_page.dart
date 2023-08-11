import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/http/dao/school_notice_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/event_notice2.dart';
import 'package:chnsmile_flutter/model/teacher_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/teacher_notice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherNoticePage extends StatefulWidget {
  final Map params;
  bool isFromOA = false;

  TeacherNoticePage({Key key, this.params}) : super(key: key) {
    isFromOA = params.isNotEmpty ? params['isFromOA'] : false;
  }

  @override
  _TeacherNoticePageState createState() => _TeacherNoticePageState();
}

class _TeacherNoticePageState extends OABaseTabState<TeacherNoticeModel,
    TeacherNotice, TeacherNoticePage> {
  bool isEnable = false;
  bool isChange = false;

  @override
  void initState() {
    super.initState();
    loadDefaultData();
    eventBus.on<EventNotice2>().listen((event) {
      setState(() {
        loadData();
      });
    });
  }

  @override
  void onPageShow() {
    ListUtils.cleanSelecter();
  }

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolHomeNoticeAdd);
    setState(() {
      isEnable = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: false,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    return appBar("通知",
        isEnable: isEnable,
        rightTitle: widget.isFromOA ? "添加" : "",
        rightButtonClick: onAddClick);
  }

  onAddClick() async {
    BoostNavigator.instance.push('teacher_notice_add_page').then((value) {
      if (value == "success") {
        loadData();
      }
    });
  }

  /// 进入详情
  void _onCellClick(TeacherNotice notice) {
    if (notice.status == 0) {
      // 未发布
      BoostNavigator.instance.push('teacher_notice_add_page',
          arguments: {"id": notice.id}).then((value) {
        if (value == "success") {
          loadData();
        }
      });
    } else {
      BoostNavigator.instance
          .push('teacher_notice_detail_page', arguments: {"id": notice.id});
    }
  }

  @override
  get contentChild => ListView.builder(
        itemCount: dataList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) =>
            TeacherNoticeCard(onCellClick: _onCellClick, item: dataList[index]),
      );

  @override
  Future<TeacherNoticeModel> getData(int pageIndex) async {
    TeacherNoticeModel result;
    try {
      EasyLoading.show(status: '加载中...');
      result = await SchoolNoticeDao.getTeacherList(
          pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<TeacherNotice> parseList(TeacherNoticeModel result) {
    return result.list;
  }
}
