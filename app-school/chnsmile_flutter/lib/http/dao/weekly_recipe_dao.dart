import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/notice_request.dart';
import 'package:chnsmile_flutter/http/request/notice_status_request.dart';
import 'package:chnsmile_flutter/http/request/weekly_recipe_request.dart';
import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/model/weekly_recipe_model.dart';

class WeeklyRecipeDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    WeeklyRecipeRequest request = WeeklyRecipeRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return WeeklyRecipeModel.fromJson(result['data']);
  }
}
