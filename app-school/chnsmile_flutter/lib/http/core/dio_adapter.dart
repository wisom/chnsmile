import 'dart:io';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/core/hi_net_adapter.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';
import 'package:chnsmile_flutter/proxy.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DioAdapter extends HiNetAdapter {
  void checkForCharlesProxy(Dio dio) {
    if (!usingProxy) return;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) => "PROXY $localProxyIPAddress:$localProxyPort;";
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    Response response;
    var dioOptions = BaseOptions(connectTimeout: 10000, receiveTimeout: 10000, sendTimeout: 10000);
    var dio = Dio(dioOptions);

    checkForCharlesProxy(dio);

    var options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await dio.get(request.url(), queryParameters: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await dio.post(request.url(), data: request.formData ?? request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await dio.delete(request.url(),
            data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DOWNLOAD) {
        response = await dio.download(request.path(), request.params['savePath']);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

  HiNetResponse buildRes(Response response, HiBaseRequest request) {
    return HiNetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
