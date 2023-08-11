import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/school_notice_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/event_notice2.dart';
import 'package:chnsmile_flutter/model/school_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/school_notice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SchoolNoticeTabPage extends StatefulWidget {
  String type;

  SchoolNoticeTabPage({Key key, String type}) : super(key: key) {
    this.type = type == '发出通知' ? 'send' : 'receive';
  }

  @override
  _SchoolNoticeTabPageState createState() => _SchoolNoticeTabPageState();
}

class _SchoolNoticeTabPageState extends OABaseTabState<SchoolNoticeModel,
    SchoolNotice, SchoolNoticeTabPage> {
  var isLoaded = false;
  var isRefresh = false;

  @override
  void initState() {
    super.initState();
    ListUtils.cleanSelecter();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.formId == event.formId) {
            print("命中了....."+element.formId);
            element.approveStatus = 2;
          }
        });
      });
    });

    eventBus.on<EventNotice2>().listen((event) {
      setState(() {
        isRefresh = true;
        print("xxxxx====");
        loadData();
      });
    });

  }

  @override
  void onPageShow() {
    if (widget.type == 'send') {
      super.onPageShow();
    }
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => SchoolNoticeCard(
              notice: dataList[index], type: widget.type,  onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(SchoolNotice notice) {
    if (getEditStatus(notice.status)) {
      BoostNavigator.instance.push('school_notice_add_page',
          arguments: {"id": notice.formId});
    } else {
      if (widget.type == 'send') {
        BoostNavigator.instance
            .push('school_notice_detail_page',
            arguments: {"item": notice});
      } else {
        BoostNavigator.instance
            .push('school_notice_detail2_page',
            arguments: {"item": notice});
      }
    }
  }

  @override
  Future<SchoolNoticeModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      SchoolNoticeModel result = await SchoolNoticeDao.get(widget.type,
          pageIndex: pageIndex, pageSize: 10);
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<SchoolNotice> parseList(SchoolNoticeModel result) {
    return result.list;
  }
}
