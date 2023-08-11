import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/weekly_contest_detail_request.dart';
import 'package:chnsmile_flutter/http/request/weekly_contest_request.dart';
import 'package:chnsmile_flutter/http/request/weekly_contest_submit_request.dart';
import 'package:chnsmile_flutter/model/weekly_contest_detail_model.dart';
import 'package:chnsmile_flutter/model/weekly_contest_model.dart';

class WeeklyContestDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    WeeklyContestRequest request = WeeklyContestRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return WeeklyContestModel.fromJson(result['data']);
  }

  static detail(String id) async {
    WeeklyContestDetailRequest request = WeeklyContestDetailRequest();
    request.add("id", id);
    var result = await HiNet.getInstance().fire(request);
    return WeeklyContestDetailModel.fromJson(result['data']);
  }

  /// 保存
  static submit(String options) async {
    WeeklyContestSubmitRequest request = WeeklyContestSubmitRequest();
    request.add("optionsIos", options);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return result;
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }

}
