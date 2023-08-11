import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';

import '../../http/dao/info_collection_dao.dart';
import '../../model/info_collection_model.dart';
import 'info_collection_card.dart';

class InfoCollectionTabPage extends StatefulWidget {
  final String type;

  const InfoCollectionTabPage({Key key, this.type}) : super(key: key);

  @override
  _InfoCollectionTabPageState createState() => _InfoCollectionTabPageState();
}

class _InfoCollectionTabPageState
    extends OABaseTabState<InfoCollectionModel, InfoCollection, InfoCollectionTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    // eventBus.on<EventNotice>().listen((event) {
    //   setState(() {
    //     dataList.forEach((element) {
    //       if (element.id == event.formId) {
    //         print("命中了....."+element.id);
    //         element.releaseStatus = 1;
    //       }
    //     });
    //   });
    // });
  }

  @override
  void onPageShow() {
    if (widget.type == '1') {

    } else {
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
          itemBuilder: (BuildContext context, int index) =>
              isEmpty(widget.type) ? InfoCollectionCard(item: dataList[index], type:widget.type, onCellClick: _onCellClick) :
              InfoCollectionCard(item: dataList[index], type:widget.type,  onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
    loadData(loadMore: false);
  });

  /// 进入详情
  void _onCellClick(InfoCollection item) {
    if (getEditStatus(item.releaseStatus)) {
      BoostNavigator.instance.push('info_collection_add_page',
          arguments: {"id": item.id});
    } else {
      BoostNavigator.instance
          .push(
          'info_collection_detail_page', arguments: {"item": item, "type": widget.type, "reviewStatus": item.releaseStatus});
    }
  }

  @override
  Future<InfoCollectionModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      InfoCollectionModel result = await InfoCollectionDao.get(
          type: widget.type, pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      isLoaded = false;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<InfoCollection> parseList(InfoCollectionModel result) {
    return result.list;
  }
}
