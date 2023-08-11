import 'package:chnsmile_flutter/http/request/school_performance_request.dart';
import 'package:chnsmile_flutter/model/school_performance_model.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';

class SchoolPerformanceDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    SchoolPerformanceRequest request = SchoolPerformanceRequest();
    request.add("pageNo", pageIndex)
        .add("pageSize", pageSize);;
    var result = await HiNet.getInstance().fire(request);
    return SchoolPerformanceModel.fromJson(result['data']);
  }
}
