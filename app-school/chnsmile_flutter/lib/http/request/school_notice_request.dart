import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';

class SchoolNoticeRequest extends BaseRequest {
  final String type;

  SchoolNoticeRequest(this.type);

  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return type == "send"
        ? HiConstant.schoolSendNoticeList
        : HiConstant.schoolReceiveNoticeList;
  }
}
