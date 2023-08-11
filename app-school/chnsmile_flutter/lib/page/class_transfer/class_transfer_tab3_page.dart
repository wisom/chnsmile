import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model3.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card3.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ClassTransferTab3Page extends StatefulWidget {
  const ClassTransferTab3Page({Key key}) : super(key: key);

  @override
  _ClassTransferTab3PageState createState() => _ClassTransferTab3PageState();
}

class _ClassTransferTab3PageState extends OABaseTabState<ClassTransferModel3,
    ClassTransfer3, ClassTransferTab3Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ClassTransferCard3(
              item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(ClassTransfer3 item) {
    BoostNavigator.instance
        .push('class_transfer_detail_page', arguments: {"id": item.id, "type": 3});
  }

  @override
  Future<ClassTransferModel3> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ClassTransferModel3 result =
          await ClassTransferDao.get3(pageIndex: pageIndex, pageSize: 20);
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
  List<ClassTransfer3> parseList(ClassTransferModel3 result) {
    return result != null  ? result.rows ?? [] : [];
  }
}
