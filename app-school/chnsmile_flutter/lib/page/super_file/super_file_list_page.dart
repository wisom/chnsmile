import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/page/super_file/super_file_list_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../http/dao/super_file_dao.dart';
import '../../model/super_file_model.dart';

class SuperFileListPage extends StatefulWidget {
  SuperFileListPage({Key key, String type}) : super(key: key) {}

  @override
  _SuperFileListPageState createState() => _SuperFileListPageState();
}

class _SuperFileListPageState
    extends OABaseTabState<SuperFileModel, SuperFile, SuperFileListPage> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => SuperFileListCard(
              item: dataList[index], onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(SuperFile item) {
    BoostNavigator.instance
        .push('super_file_detail_page', arguments: {"item": item});
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
  Future<SuperFileModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      SuperFileModel result =
          await SuperFileDao.list(pageIndex: pageIndex, pageSize: 10);
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
  List<SuperFile> parseList(SuperFileModel result) {
    return result.list;
  }
}
