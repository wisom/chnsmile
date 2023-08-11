import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model5.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card4.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card5.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ClassTransferTab5Page extends StatefulWidget {
  const ClassTransferTab5Page({Key key}) : super(key: key);

  @override
  _ClassTransferTab5PageState createState() => _ClassTransferTab5PageState();
}

class _ClassTransferTab5PageState extends OABaseTabState<ClassTransferModel5,
    ClassTransfer5, ClassTransferTab5Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ClassTransferCard5(
              item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(ClassTransfer5 item) {
    // BoostNavigator.instance
    //     .push('class_transfer_detail_page', arguments: {"id": item.formId, "type": 5});
  }

  @override
  Future<ClassTransferModel5> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ClassTransferModel5 result =
          await ClassTransferDao.get5(pageIndex: pageIndex, pageSize: 20);
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
  List<ClassTransfer5> parseList(ClassTransferModel5 result) {
    return result != null  ? result.rows ?? [] : [];
  }
}
