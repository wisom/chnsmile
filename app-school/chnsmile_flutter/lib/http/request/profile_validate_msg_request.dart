import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';

class ProfileValidateMsgRequest extends BaseRequest {
  final String url1;

  ProfileValidateMsgRequest(this.url1);


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
    return url1;
  }
}
