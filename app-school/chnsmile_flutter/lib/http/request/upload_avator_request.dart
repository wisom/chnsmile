import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';

class UploadAvatorRequest extends BaseRequest {
  final String type;

  UploadAvatorRequest(this.type);

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
    return HiConstant.uploadAvator + type;
  }
}
