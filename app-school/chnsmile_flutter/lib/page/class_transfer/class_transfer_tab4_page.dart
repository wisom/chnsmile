import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model4.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card4.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ClassTransferTab4Page extends StatefulWidget {
  const ClassTransferTab4Page({Key key}) : super(key: key);

  @override
  _ClassTransferTab4PageState createState() => _ClassTransferTab4PageState();
}

class _ClassTransferTab4PageState extends OABaseTabState<ClassTransferModel4,
    ClassTransfer4, ClassTransferTab4Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ClassTransferCard4(
              item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(ClassTransfer4 item) {
    // BoostNavigator.instance
    //     .push('class_transfer_detail_page', arguments: {"id": item.formId, "type": 4});
  }

  @override
  Future<ClassTransferModel4> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ClassTransferModel4 result =
          await ClassTransferDao.get4(pageIndex: pageIndex, pageSize: 20);
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
  List<ClassTransfer4> parseList(ClassTransferModel4 result) {
    return result != null  ? result.rows ?? [] : [];
  }
}
