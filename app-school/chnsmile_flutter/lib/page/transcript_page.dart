import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/student_info.dart';
import 'package:chnsmile_flutter/model/transcript_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/transcript_expandable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TranscriptPage extends StatefulWidget {
  final String studentId;

  const TranscriptPage({Key key, this.studentId}) : super(key: key);

  @override
  _TranscriptPageState createState() => _TranscriptPageState();
}

class _TranscriptPageState
    extends HiBaseTabState<TranscriptModel, Score, TranscriptPage> {
  StudentInfo _studentInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isLoading: false,
            isEmpty: isEmpty,
            onRefreshClick: onRefreshClick,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    return appBar("成绩单");
  }

  @override
  get contentChild => ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) =>
          buildExpandableContent(dataList[index], index));

  @override
  Future<TranscriptModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    TranscriptModel result = await TranscriptDao.transcriptList(
        pageIndex: pageIndex,
        pageSize: 20);
    EasyLoading.dismiss(animation: false);
    return result;
  }

  @override
  List<Score> parseList(TranscriptModel result) {
    setState(() {
      _studentInfo = result.studentInfo;
    });
    return result.scoreInfo.rows;
  }

  buildExpandableContent(Score score, int index) {
    return TranscriptExpandableContent(index: index,score: score);
  }
}
