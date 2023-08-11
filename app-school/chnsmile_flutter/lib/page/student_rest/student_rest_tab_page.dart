import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/page/student_rest/student_rest_card.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../http/dao/student_rest_dao.dart';
import '../../model/student_rest_model.dart';

class StudentRestTabPage extends StatefulWidget {
  final String type;
  final bool isFromOA;

  const StudentRestTabPage({Key key, this.type, this.isFromOA}): super(key: key);

  @override
  _StudentRestTabPageState createState() => _StudentRestTabPageState();

}

class _StudentRestTabPageState
    extends OABaseTabState<StudentRestModel, StudentRest, StudentRestTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.formId == event.formId) {
            print("命中了....." + element.formId);
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
  get contentChild =>
      dataList.isNotEmpty
          ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
          // isEmpty(widget.type) ?
          StudentRestCard(
              item: dataList[index], onCellClick: _onCellClick)
              // :
          // RepairApproveCard(item: dataList[index],
          //     type: widget.type,
          //     onCellClick: _onCellClick)
              )
          : isLoaded ? Container() : EmptyView(onRefreshClick: () {
        loadData(loadMore: false);
      });

  /// 进入详情
  void _onCellClick(StudentRest item) {
    if (getEditStatus(item.status)) {
      BoostNavigator.instance.push('student_rest_add_page',
          arguments: {"id": item.id});
    } else {
      BoostNavigator.instance
          .push(
          'student_rest_detail_page', arguments: {
        "item": item,
        "type": widget.type,
        "reviewStatus": item.reviewStatus
      });
    }
  }

  @override
  Future<StudentRestModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      StudentRestModel result = await StudentRestDao.get(
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
  List<StudentRest> parseList(StudentRestModel result) {
    return result.list;
  }
}
