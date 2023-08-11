import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model1.dart';
import 'package:chnsmile_flutter/model/repair_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card1.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/repair_approve_card.dart';
import 'package:chnsmile_flutter/widget/repair_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';

class ClassTransferTab1Page extends StatefulWidget {

  const ClassTransferTab1Page({Key key}) : super(key: key);

  @override
  _ClassTransferTab1PageState createState() => _ClassTransferTab1PageState();
}

class _ClassTransferTab1PageState
    extends OABaseTabState<ClassTransferModel1, ClassTransfer, ClassTransferTab1Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              ClassTransferCard1(item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(ClassTransfer item) {
    if (getEditStatus(item.status)) {
      BoostNavigator.instance.push('class_transfer_add_page',
          arguments: {"id": item.id});
    } else {
      BoostNavigator.instance
          .push(
          'class_transfer_detail_page', arguments: {"id": item.id, "type": 1});
    }
  }

  @override
  Future<ClassTransferModel1> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ClassTransferModel1 result = await ClassTransferDao.get(pageIndex: pageIndex, pageSize: 20);
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
  List<ClassTransfer> parseList(ClassTransferModel1 result) {
    return result != null  ? result.rows ?? [] : [];
  }
}
