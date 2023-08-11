import 'dart:io';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';
import 'package:hi_cache/hi_cache.dart';

abstract class BaseRequest extends HiBaseRequest {
  @override
  String url() {
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      // addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return super.url();
  }

  @override
  Map<String, dynamic> header = {
    "Authorization": "Bearer ${HiCache.getInstance().get(HiConstant.spToken)}",
    HttpHeaders.userAgentHeader:
        HiCache.getInstance().get(HiConstant.spUserAgent),
  };
}
