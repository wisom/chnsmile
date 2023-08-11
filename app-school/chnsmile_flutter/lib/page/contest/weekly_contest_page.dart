import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/weekly_contest_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/weekly_contest_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/weekly_contest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WeeklyContestPage extends StatefulWidget {
  @override
  _WeeklyContestPageState createState() => _WeeklyContestPageState();
}

class _WeeklyContestPageState extends OABaseTabState<WeeklyContestModel,
    WeeklyContest, WeeklyContestPage> {
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("每周竞赛"),
        body: LoadingContainer(
            isLoading: false,
            isEmpty: isEmpty,
            onRefreshClick: onRefreshClick,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.voteId == event.formId) {
            element.hasSubmitAns = 1;
            element.submitAnsLabel = "已参加";
          }
        });
      });
    });
  }

  @override
  void onPageShow() {}

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          itemCount: dataList?.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              WeeklyContestCard(item: dataList[index]))
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  @override
  Future<WeeklyContestModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      WeeklyContestModel result =
          await WeeklyContestDao.get(pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<WeeklyContest> parseList(WeeklyContestModel result) {
    return result != null ? result.rows : [];
  }
}
