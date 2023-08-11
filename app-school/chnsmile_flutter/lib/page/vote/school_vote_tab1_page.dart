import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/vote_model1.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/vote_card1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SchoolVoteTab1Page extends StatefulWidget {
  @override
  _SchoolVoteTab1PageState createState() => _SchoolVoteTab1PageState();
}

class _SchoolVoteTab1PageState
    extends OABaseTabState<VoteModel1, Vote, SchoolVoteTab1Page> {
  var isLoaded = false;

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              VoteCard1(vote: dataList[index]))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  @override
  Future<VoteModel1> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      VoteModel1 result =
          await VoteDao.voteList1(pageIndex: pageIndex, pageSize: 10);
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
  List<Vote> parseList(VoteModel1 result) {
    return result.list;
  }
}
