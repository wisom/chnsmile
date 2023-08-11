import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/teacher_transcript1_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_transcript1_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherTranscriptTab1Page extends StatefulWidget {
  final String examId;

  const TeacherTranscriptTab1Page({Key key, this.examId}) : super(key: key);

  @override
  _TeacherTranscriptTab1PageState createState() => _TeacherTranscriptTab1PageState();
}

class _TeacherTranscriptTab1PageState extends HiBaseTabState<
    TeacherTranscript1Model, TeacherTranscript1, TeacherTranscriptTab1Page> {
  var isLoaded = false;

  @override
  void initState() {
    isNeedLoadMore = false;
    super.initState();
    print("examId: ${widget.examId}");
  }
  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherTranscript1Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(TeacherTranscript1 item) {
    BoostNavigator.instance.push('teacher_transcript_detail1_page',
        arguments: {"item": item, "examId": widget.examId});
  }

  @override
  Future<TeacherTranscript1Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherTranscript1Model result =
        await TranscriptDao.getTab1(widget.examId);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherTranscript1> parseList(TeacherTranscript1Model result) {
    return result.list;
  }
}
