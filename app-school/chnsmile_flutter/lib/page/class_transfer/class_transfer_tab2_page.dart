import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model2.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card2.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ClassTransferTab2Page extends StatefulWidget {
  const ClassTransferTab2Page({Key key}) : super(key: key);

  @override
  _ClassTransferTab2PageState createState() => _ClassTransferTab2PageState();
}

class _ClassTransferTab2PageState extends OABaseTabState<ClassTransferModel2,
    ClassTransfer2, ClassTransferTab2Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ClassTransferCard2(
              item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(ClassTransfer2 item) {
    BoostNavigator.instance
        .push('class_transfer_detail_page', arguments: {"id": item.cid, "type": 2});
  }

  @override
  Future<ClassTransferModel2> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ClassTransferModel2 result =
          await ClassTransferDao.get2(pageIndex: pageIndex, pageSize: 20);
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
  List<ClassTransfer2> parseList(ClassTransferModel2 result) {
    return result != null  ? result.rows ?? [] : [];
  }
}
