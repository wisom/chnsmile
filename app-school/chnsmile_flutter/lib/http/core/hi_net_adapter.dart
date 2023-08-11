import 'dart:convert';

import 'package:chnsmile_flutter/http/request/hi_base_request.dart';


abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request);
}

class HiNetResponse<T> {
  T data;
  HiBaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extra;

  HiNetResponse(
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
