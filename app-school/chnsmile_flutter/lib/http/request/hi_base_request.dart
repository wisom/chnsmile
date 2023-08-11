import 'dart:convert';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:dio/dio.dart';

enum HttpMethod { GET, POST, DELETE, DOWNLOAD }

abstract class HiBaseRequest {
  var pathParams;
  var useHttps = false;

  String authority() {
    return HiConstant.baseUrl;
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    // Uri uri;
    String url;
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    if (path().startsWith("http")) {
      url = path();
    } else {
      url = '${authority()}/${path()}';
    }

    return url;
  }

  bool needLogin();

  Map<String, dynamic> params = Map();
  FormData formData;

  // 添加参数
  HiBaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // 添加formdata参数
  HiBaseRequest addFormData(FormData params) {
    formData = params;
    return this;
  }

  Map<String, dynamic> header = {};

  // 添加header
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
