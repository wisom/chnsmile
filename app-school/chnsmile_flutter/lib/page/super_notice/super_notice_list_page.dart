import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/super_notice_dao.dart';
import 'package:chnsmile_flutter/page/super_notice/super_file_notice_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/super_notice_model.dart';

///上级信息
class SuperNoticeListPage extends StatefulWidget {
  String type = "";

  SuperNoticeListPage({Key key, String type}) : super(key: key) {
    type = type;
  }

  @override
  _SuperNoticeListPageState createState() => _SuperNoticeListPageState();
}

class _SuperNoticeListPageState
    extends OABaseTabState<SuperNoticeModel, SuperNotice, SuperNoticeListPage> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              SuperNoticeListCard(notice: dataList[index], onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(SuperNotice item) {
    BoostNavigator.instance.push('super_notice_detail_page', arguments: {"item": item});
  }

  @override
  void initState() {
    super.initState();
    // eventBus.on<EventNotice>().listen((event) {
    //   setState(() {
    //     dataList.forEach((element) {
    //       if (element.formId == event.formId) {
    //         print("命中了....."+element.formId);
    //         element.reviewStatus = 2;
    //       }
    //     });
    //   });
    // });
  }

  @override
  void onPageShow() {}

  @override
  Future<SuperNoticeModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      SuperNoticeModel result =
          await SuperNoticeDao.list(pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      print("SuperFileList====" + e);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return null;
    }
  }

  @override
  List<SuperNotice> parseList(SuperNoticeModel result) {
    return result.list;
  }
}
