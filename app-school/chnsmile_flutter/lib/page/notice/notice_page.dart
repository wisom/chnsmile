import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/notice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NoticePage extends StatefulWidget {
  final Map params;
  bool isFromOA = false;

  NoticePage({Key key, this.params}) : super(key: key) {
    isFromOA = params.isNotEmpty ? params['isFromOA'] : false;
  }

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends OABaseTabState<NoticeModel, Notice, NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            // onRefreshClick: loadData,
            isLoading: false,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    return appBar("通知",
        rightTitle: widget.isFromOA ? "添加" : "", rightButtonClick: onAddClick);
  }

  onAddClick() {
    BoostNavigator.instance.push('notice_add_page');
  }

  /// 进入详情
  void _onCellClick(Notice notice) {
    BoostNavigator.instance
        .push('notice_detail_page', arguments: {"notice": notice});
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.id == event.formId) {
            element.readStatus = 1;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {}

  @override
  get contentChild => ListView.builder(
        itemCount: dataList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) =>
            NoticeCard(onCellClick: _onCellClick, notice: dataList[index]),
      );

  @override
  Future<NoticeModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      NoticeModel result =
          await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<Notice> parseList(NoticeModel result) {
    return result.list;
  }
}
