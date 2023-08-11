import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/teacher_transcript2_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_transcript2_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherTranscriptTab2Page extends StatefulWidget {
  final String examId;

  const TeacherTranscriptTab2Page({Key key, this.examId}) : super(key: key);

  @override
  _TeacherTranscriptTab2PageState createState() =>
      _TeacherTranscriptTab2PageState();
}

class _TeacherTranscriptTab2PageState extends HiBaseTabState<
    TeacherTranscript2Model, TeacherTranscript2, TeacherTranscriptTab2Page> {
  var isLoaded = false;

  @override
  void initState() {
    isNeedLoadMore = false;
    super.initState();
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherTranscript2Card(
                  item: dataList[index], onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(Student item) {
    BoostNavigator.instance.push('teacher_transcript_detail2_page',
        arguments: {"item": item, "examId": widget.examId});
  }

  @override
  Future<TeacherTranscript2Model> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    TeacherTranscript2Model result = await TranscriptDao.getTab2(widget.examId);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<TeacherTranscript2> parseList(TeacherTranscript2Model result) {
    return result.list;
  }
}
