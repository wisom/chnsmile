import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/page/student_leave_early/student_leave_early_apply_card.dart';
import 'package:chnsmile_flutter/page/student_leave_early/student_leave_early_notify_card.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../http/dao/student_leave_early_dao.dart';
import '../../model/student_leave_early_model.dart';

class StudentLeaveEarlyTabPage extends StatefulWidget {
  ///列表类型 列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  final String type;
  final bool isTeacher;

  const StudentLeaveEarlyTabPage({Key key, this.type, this.isTeacher})
      : super(key: key);

  @override
  _StudentLeaveEarlyTabPageState createState() =>
      _StudentLeaveEarlyTabPageState();
}

class _StudentLeaveEarlyTabPageState extends OABaseTabState<
    StudentLeaveEarlyModel, StudentLeaveEarly, StudentLeaveEarlyTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        // dataList.forEach((element) {
        //   if (element.formId == event.formId) {
        //     print("命中了....."+element.formId);
        //     element.reviewStatus = 2;
        //   }
        // });
      });
    });
  }

  @override
  void onPageShow() {}

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              _getCardByType(index))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(StudentLeaveEarly item) {
    BoostNavigator.instance.push('student_leave_early_detail_page', arguments: {
      "item": item,
      "type": widget.type,
      "reviewStatus": item.status
    });
  }

  @override
  Future<StudentLeaveEarlyModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      LogUtil.d("学生早退", "getData==");
      StudentLeaveEarlyModel result =
          await StudentLeaveEarlyDao.list(pageIndex, 10, widget.type, "", "");
      LogUtil.d("学生早退", "getData==后");
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      LogUtil.d("学生早退", "报错：" + e);
      isLoaded = false;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<StudentLeaveEarly> parseList(StudentLeaveEarlyModel result) {
    return result.list;
  }

  StatelessWidget _getCardByType(int index) {
    ///列表类型 1.我的发起；2.请假审批；3.收到通知/我的通知；5.缺勤汇总
    LogUtil.d("学生早退", "_getCardByType type=" + (widget.type ?? 0).toString());
    LogUtil.d("学生早退", "_getCardByType dataList=" + dataList.length.toString());
    if (widget.type == "2") {
      return StudentLeaveEarlyNotifyCard(
          type: widget.type, item: dataList[index], onCellClick: _onCellClick);
    } else if (widget.type == "3") {
      return widget.isTeacher
          ? StudentLeaveEarlyNotifyCard(
              type: widget.type,
              item: dataList[index],
              isTeacher: widget.isTeacher,
              onCellClick: _onCellClick)
          : StudentLeaveEarlyNotifyCard(
              type: widget.type,
              item: dataList[index],
              isTeacher: widget.isTeacher,
              onCellClick: _onCellClick);
    } else if (widget.type == "5") {
      return StudentLeaveEarlyNotifyCard(
          type: widget.type, item: dataList[index], onCellClick: _onCellClick);
    } else if (widget.type == "1") {
      return StudentLeaveEarlyApplyCard(
          type: widget.type, item: dataList[index], onCellClick: _onCellClick);
    } else {
      return Container();
    }
  }
}
