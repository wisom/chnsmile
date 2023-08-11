import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vote.dart';
import 'package:chnsmile_flutter/model/vote_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/vote_card.dart';
import 'package:chnsmile_flutter/widget/vote_card2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SchoolVoteTab2Page extends StatefulWidget {

  @override
  _SchoolVoteTab2PageState createState() => _SchoolVoteTab2PageState();
}

class _SchoolVoteTab2PageState extends OABaseTabState<VoteModel,
    Vote, SchoolVoteTab2Page>  {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.voteId == event.formId) {
            print("命中了....."+element.voteId);
            element.submitAnsLabel = "已投票";
            element.hasSumbitAns = 1;
          }
        });
      });

    });
  }

  @override
  void onPageShow() {
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => VoteCard2(
              vote: dataList[index]))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  @override
  Future<VoteModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      VoteModel result = await VoteDao.voteList2(
          pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      print(e);
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<Vote> parseList(VoteModel result) {
    return result.list;
  }
}
