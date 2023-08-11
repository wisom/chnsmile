import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vote.dart';
import 'package:chnsmile_flutter/model/vote_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/vote_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VotePage extends StatefulWidget {

  VotePage({Key key}) : super(key: key);

  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends OABaseTabState<VoteModel, Vote, VotePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
            isLoading: false,
            isEmpty: isEmpty,
            onRefreshClick: onRefreshClick,
            child: Column(children: [
              Expanded(child: super.build(context))
            ])));
  }

  onAddClick() {

  }

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
  get contentChild => ListView.builder(
      itemCount: dataList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) =>
          VoteCard(vote: dataList[index]));

  @override
  Future<VoteModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      VoteModel result = await VoteDao.voteList(
          pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<Vote> parseList(VoteModel result) {
    return result.list;
  }
}
