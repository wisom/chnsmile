import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/salary_request.dart';
import 'package:chnsmile_flutter/model/salary_model.dart';

class SalaryDao {
  static get({int pageIndex = 1, int pageSize = 10}) async {
    SalaryRequest request = SalaryRequest();
    request.add("pageNo", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return SalaryModel.fromJson(result['data']);
  }
}
