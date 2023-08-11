import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/page/reimbursement/reimbursement_approve_card.dart';
import 'package:chnsmile_flutter/page/reimbursement/reimbursement_card.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart';

import '../../http/dao/reimbursement_dao.dart';
import '../../model/reimbursement_model.dart';

class ReimbursementTabPage extends StatefulWidget {
  final String type;

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  const ReimbursementTabPage({Key key, this.type}) : super(key: key);

  @override
  _ReimbursementTabPageState createState() => _ReimbursementTabPageState();
}

class _ReimbursementTabPageState
    extends OABaseTabState<ReimbursementModel, Reimbursement, ReimbursementTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.formId == event.formId) {
            print("命中了....."+element.formId);
            element.reviewStatus = 2;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {
    if (widget.type == '2') {

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
              (widget.type=="1") ? ReimbursementCard(item: dataList[index], onCellClick: _onCellClick) :
              ReimbursementApproveCard(item: dataList[index], type:widget.type,  onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
    loadData(loadMore: false);
  });

  /// 进入详情
  void _onCellClick(Reimbursement item) {
    if (getEditStatus(item.status)) {
      BoostNavigator.instance.push('reimbursement_add_page',
          arguments: {"id": item.id});
    } else {
      BoostNavigator.instance
          .push(
          'reimbursement_detail_page', arguments: {"item": item, "type": widget.type, "reviewStatus": item.reviewStatus});
    }
  }

  @override
  Future<ReimbursementModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      ReimbursementModel result = await ReimbursementDao.get(
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
  List<Reimbursement> parseList(ReimbursementModel result) {
    return result.list;
  }
}
