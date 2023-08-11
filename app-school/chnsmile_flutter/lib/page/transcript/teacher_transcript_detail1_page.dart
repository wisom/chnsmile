import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/teacher_transcript1_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_detail1_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/teacher_transcript_detail1_card.dart';
import 'package:flutter/material.dart';

class TeacherTranscriptDetail1Page extends StatefulWidget {
  final Map params;
  TeacherTranscript1 item;
  String examId;

  TeacherTranscriptDetail1Page({Key key, this.params}) : super(key: key) {
    item = params['item'];
    examId = params['examId'];
  }

  @override
  _TeacherTranscriptDetail1PageState createState() => _TeacherTranscriptDetail1PageState();
}

class _TeacherTranscriptDetail1PageState extends HiBaseTabState<TeacherTranscriptDetail1Model,
    TeacherTranscriptDetail1, TeacherTranscriptDetail1Page> {

  @override
  void initState() {
    super.initState();
    needLoadMore(false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("成绩单"),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: isLoading,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  @override
  get contentChild => ListView.builder(
    itemCount: dataList.length,
    physics: const AlwaysScrollableScrollPhysics(),
    controller: scrollController,
    itemBuilder: (BuildContext context, int index) => TeacherTranscriptDetail1Card(item: dataList[index]),
  );

  @override
  Future<TeacherTranscriptDetail1Model> getData(int pageIndex) async {
    TeacherTranscriptDetail1Model result = await TranscriptDao.detail1(widget.examId, widget.item.classId);
    return result;
  }

  @override
  List<TeacherTranscriptDetail1> parseList(TeacherTranscriptDetail1Model result) {
    return result.list;
  }
}
