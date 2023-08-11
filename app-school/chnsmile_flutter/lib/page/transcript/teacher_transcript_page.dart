import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/teacher_transcript_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherTranscriptPage extends StatefulWidget {
  final Map params;
  bool isFromOA = false;

  TeacherTranscriptPage({Key key, this.params}) : super(key: key) {
    isFromOA = params.isNotEmpty ? params['isFromOA'] : false;
  }

  @override
  _TeacherTranscriptPageState createState() => _TeacherTranscriptPageState();
}

class _TeacherTranscriptPageState extends OABaseTabState<TeacherTranscriptModel,
    TeacherTranscript, TeacherTranscriptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: false,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    return appBar("成绩单");
  }

  /// 进入详情
  void _onCellClick(TeacherTranscript item) {
    BoostNavigator.instance.push('teacher_transcript_tab_page',
        arguments: {"examId": item.examId});
  }

  @override
  get contentChild => ListView.builder(
        itemCount: dataList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) => TeacherTranscriptCard(
            onCellClick: _onCellClick, item: dataList[index]),
      );

  @override
  Future<TeacherTranscriptModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      TeacherTranscriptModel result =
          await TranscriptDao.teacherList(pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      return null;
    }

  }

  @override
  List<TeacherTranscript> parseList(TeacherTranscriptModel result) {
    return result.rows;
  }
}
