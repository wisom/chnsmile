import 'package:chnsmile_flutter/http/request/teacher_transcript_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_transcript_tab1_detail_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_transcript_tab1_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_transcript_tab2_detail_request.dart';
import 'package:chnsmile_flutter/http/request/teacher_transcript_tab2_request.dart';
import 'package:chnsmile_flutter/http/request/transcript_request.dart';
import 'package:chnsmile_flutter/model/teacher_transcript1_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript2_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_detail1_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_detail2_model.dart';
import 'package:chnsmile_flutter/model/teacher_transcript_model.dart';
import 'package:chnsmile_flutter/model/transcript_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';

class TranscriptDao {
  static transcriptList(
      {int pageIndex = 1, int pageSize = 10}) async {
    TranscriptRequest request = TranscriptRequest();
    request
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TranscriptModel.fromJson(result['data']);
  }

  static teacherList({int pageIndex = 1, int pageSize = 10}) async {
    TeacherTranscriptRequest request = TeacherTranscriptRequest();
    request
        .add("pageNo", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return TeacherTranscriptModel.fromJson(result['data']);
  }

  /// 班级
  static getTab1(String examId) async {
    TeacherTranscriptTab1Request request = TeacherTranscriptTab1Request();
    request.add("id", examId);
    var result = await HiNet.getInstance().fire(request);
    return TeacherTranscript1Model.fromJson(result['data']);
  }

  /// 个人
  static getTab2(String examId) async {
    TeacherTranscriptTab2Request request = TeacherTranscriptTab2Request();
    request.add("id", examId);
    var result = await HiNet.getInstance().fire(request);
    return TeacherTranscript2Model.fromJson(result['data']);
  }

  static detail1(String examId, String classId) async {
    TeacherTranscriptTab1DetailRequest request = TeacherTranscriptTab1DetailRequest();
    request.add("examId", examId).add("classId", classId);
    var result = await HiNet.getInstance().fire(request);
    return TeacherTranscriptDetail1Model.fromJson(result['data']);
  }

  static detail2(String examId, String classId, String studentId) async {
    TeacherTranscriptTab2DetailRequest request = TeacherTranscriptTab2DetailRequest();
    request.add("examId", examId).add("classId", classId).add("studentId", studentId);
    var result = await HiNet.getInstance().fire(request);
    return TeacherTranscriptDetail2Model.fromJson(result['data']);
  }
}
