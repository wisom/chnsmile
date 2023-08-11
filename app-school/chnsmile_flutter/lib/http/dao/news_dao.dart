import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/campus_request.dart';
import 'package:chnsmile_flutter/http/request/news_request.dart';
import 'package:chnsmile_flutter/model/news_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:hi_base/string_util.dart';

class NewsDao {
  static newsList({int type = 0, int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request;
    if (type == 0) {
      request = NewsRequest();
    } else {
      request = CampusRequest();
    }
    request.add("pageNo", pageIndex);
    var result = await HiNet.getInstance().fire(request);
    return NewsModel.fromJson(result['data']);
  }
}
