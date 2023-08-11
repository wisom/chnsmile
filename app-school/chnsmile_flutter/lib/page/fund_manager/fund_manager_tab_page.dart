import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/model/fund_manager_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';

import '../../http/dao/fund_manager_dao.dart';
import '../../model/repair_model.dart';
import '../../utils/hi_toast.dart';
import 'fund_manager_card.dart';

class FundManagerTabPage extends StatefulWidget {
  final String type; //1=经费申请、2=经费审批、3=收到通知

  const FundManagerTabPage({Key key, this.type}) : super(key: key);

  @override
  _FundManagerTabPageState createState() => _FundManagerTabPageState();
}

class _FundManagerTabPageState
    extends OABaseTabState<FundManagerModel, FundManager, FundManagerTabPage> {
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
    // if (widget.type == '1') {
    //
    // } else {
    //   super.onPageShow();
    // }
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => isEmpty(widget.type)
              ? FundManagerCard(
                  item: dataList[index],
                  type: widget.type,
                  onCellClick: _onCellClick)
              : FundManagerCard(
                  item: dataList[index],
                  type: widget.type,
                  onCellClick: _onCellClick))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(FundManager item) {
    BoostNavigator.instance.push('fund_detail_page', arguments: {
      "item": item,
      "type": widget.type,
      "reviewStatus": item.status
    });

    // if (getEditStatus(item.releaseStatus)) {
    //   BoostNavigator.instance.push('info_collection_add_page',
    //       arguments: {"id": item.id});
    // } else {
    //   BoostNavigator.instance
    //       .push(
    //       'fund_manager_detail_page', arguments: {"item": item, "type": widget.type, "reviewStatus": item.releaseStatus});
    // }
  }

  @override
  Future<FundManagerModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      print("经费管理===getData start");
      var result = await FundManagerDao.list(pageIndex, widget.type);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      print("经费管理===getData " + result.toString());
      return result;
    } catch (e) {
      isLoaded = false;
      print("经费管理===getData " + e.toString());
      EasyLoading.dismiss(animation: false);
    }
  }

  // read() async {
  //   try {
  //     EasyLoading.show(status: '加载中...');
  //     Map<String, dynamic> params = {};
  //     params['pageNo'] = 1;
  //     params['pageSize'] = 10;
  //     params['listType'] = 1;
  //     var result = await FundManagerDao.approve(params);
  //     return result
  //     // PlatformMethod.sentTriggerUnreadToNative();
  //     // var bus = EventNotice();
  //     // bus.formId = widget.repair.formId;
  //     // eventBus.fire(bus);
  //     EasyLoading.dismiss(animation: false);
  //   } catch (e) {
  //     EasyLoading.dismiss(animation: false);
  //     // showWarnToast(e.message);
  //   }
  // }

  @override
  List<FundManager> parseList(FundManagerModel result) {
    return result.list;
  }
}
