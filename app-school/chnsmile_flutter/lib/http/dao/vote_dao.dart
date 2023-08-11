import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_add_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_class_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_detail_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_edit_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_result_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_save_request.dart';
import 'package:chnsmile_flutter/http/request/school_vote_status_request.dart';
import 'package:chnsmile_flutter/http/request/vote_detail_request.dart';
import 'package:chnsmile_flutter/http/request/vote_request.dart';
import 'package:chnsmile_flutter/http/request/vote_submit_request.dart';
import 'package:chnsmile_flutter/model/school_vote_result_model.dart';
import 'package:chnsmile_flutter/model/vote_detail_model.dart';
import 'package:chnsmile_flutter/model/vote_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/model/vote_model1.dart';
import 'package:chnsmile_flutter/model/vote_school_class_model.dart';
import 'package:chnsmile_flutter/model/vote_school_detail_model.dart';

class VoteDao {
  static voteList1({int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = SchoolVoteRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return VoteModel1.fromJson(result['data']);
  }

  static voteList2({int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = VoteRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return VoteModel.fromJson(result['data']);
  }

  static voteList({int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = VoteRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return VoteModel.fromJson(result['data']);
  }


  static voteDetail(String voteId) async {
    BaseRequest request = VotedDetailRequest();
    request.add("id", voteId);
    var result = await HiNet.getInstance().fire(request);
    return VoteDetailModel.fromJson(result['data']);
  }

  static schoolVoteResult(String voteId) async {
    BaseRequest request = SchoolVotedResultRequest();
    request.add("id", voteId);
    var result = await HiNet.getInstance().fire(request);
    return SchoolVoteResultModel.fromJson(result['data']);
  }

  static voteSchoolDetail(String voteId) async {
    BaseRequest request = SchoolVotedDetailRequest();
    request.add("id", voteId);
    var result = await HiNet.getInstance().fire(request);
    return VoteSchoolDetailModel.fromJson(result['data']);
  }

  static classDetail() async {
    BaseRequest request = SchoolVotedClassRequest();
    var result = await HiNet.getInstance().fire(request);
    return VoteSchoolClassModel.fromJson(result['data']);
  }

  static submit(String options) async {
    VoteSubmitRequest request = VoteSubmitRequest();
    request.add("optionsIos", options);
    var result = await HiNet.getInstance().fire(request);
    print("result: ${result}");
    return result;
  }

  /// 教师提交
  static schoolAdd(Map<String, dynamic> params, {bool isSave}) async {
    BaseRequest request = SchoolVoteAddRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 教师编辑
  static schoolEdit(Map<String, dynamic> params) async {
    BaseRequest request = SchoolVoteEditRequest();
    request.params = params;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

  /// 撤销
  static revoke(String id) async {
    SchoolVoteStatusRequest request = SchoolVoteStatusRequest();
    request.add("id", id);
    request.add("voteStatus", 3);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
