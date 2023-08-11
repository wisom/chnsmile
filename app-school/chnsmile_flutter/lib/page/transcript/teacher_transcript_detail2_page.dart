import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/transcript_dao.dart';
import 'package:chnsmile_flutter/model/teacher_transcript2_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_detail2_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/view_util.dart';

class TeacherTranscriptDetail2Page extends StatefulWidget {
  final Map params;
  Student item;
  String studentId;
  String classId;
  String examId;

  TeacherTranscriptDetail2Page({Key key, this.params}) : super(key: key) {
    item = params['item'];
    var arr = item.id.split("-");
    studentId = arr[0];
    classId = arr[1];
    examId = params['examId'];
  }

  @override
  _TeacherTranscriptDetail2PageState createState() =>
      _TeacherTranscriptDetail2PageState();
}

class _TeacherTranscriptDetail2PageState
    extends HiState<TeacherTranscriptDetail2Page> {
  TeacherTranscriptDetail2Model model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('${widget.item.name ?? ''}成绩单'),
        body: RefreshIndicator(
            child: ListView(
              children: [
                _buildContent(),
              ],
            ),
            onRefresh: loadData));
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await TranscriptDao.detail2(
          widget.examId, widget.classId, widget.studentId);
      setState(() {
        model = result;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildContent() {
    if (model == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              child: Text(
                model.examName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
          hiSpace(height: 6),
          Container(
              alignment: Alignment.centerRight,
              child: Text(
                widget.item.label,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey),
              )),
          hiSpace(height: 10),
          boxLine(context),
          hiSpace(height: 20),
          GridView.builder(
              shrinkWrap: true,
              itemCount: model.scoreList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10, crossAxisCount: 2, childAspectRatio: 8),
              itemBuilder: (BuildContext context, int index) {
                var score = model.scoreList[index];
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${score.courseName} : ',
                          style: const TextStyle(fontSize: 15, color: Colors.black)),
                      Text('${score.courseScore}',
                          style: const TextStyle(fontSize: 15, color: Colors.red)),
                      hiSpace(width: 6),
                      score.type == 1 ? Icon(Icons.upload_rounded, size: 16, color: Colors.green) : const Icon(Icons.file_download, size: 16, color: Colors.red)
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
