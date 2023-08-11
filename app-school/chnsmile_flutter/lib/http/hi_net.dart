
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/core/platform_response.dart';
import 'package:chnsmile_flutter/http/core/dio_adapter.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/core/hi_net_adapter.dart';
import 'package:chnsmile_flutter/http/core/mock_adapter.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';


class HiNet {
  HiNet._();

  static HiNet _instance = HiNet._();

  static HiNet getInstance() {
    return _instance;
  }

  Future fire(HiBaseRequest request) async {
    HiNetResponse response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      print(e.message);
    } catch (e) {
      error = e;
      print(e);
    }

    if (response == null) {
      throw HiNetError(102321, '数据异常，请退出重试');
    }

    try {
      var result = response.data;
      if (result == null) {
        print("result ================");
        throw HiNetError(102321, '数据异常，请退出重试');
      }
      print("result: ${result}");

      var status = response.statusCode;
      switch (status) {
        case 200:
          var code = response.data["code"];
          var success = response.data["success"];
          if (code == 1011006) {
            PlatformResponse response = await PlatformMethod.logout();
            print(response);
          } else if (!success) {
            print("response.data['message']: ${response.data['message']}");
            if (code == 1013002) {
              showWarnToast(response.data['message']);
            }
            throw HiNetError(code, response.data['message']);
          }
          return result;
        case 401:
          throw NeedLogin();
        default:
          throw HiNetError(status, result.toString(), data: result);
      }
    } on NeedAuth catch (e) {
      PlatformResponse response = await PlatformMethod.logout();
      throw NeedAuth("返回的数据为空",);
    } on HiNetError catch (e) {
      throw HiNetError(e.code, e.message);
    }


  }

  Future<dynamic> send<T>(HiBaseRequest request) async {
    printLog('url:${request.url()}');
    Future<dynamic> response;
    HiNetAdapter adapter = MockAdapter();
    HiNetAdapter dioAdapter = DioAdapter();
    if (adapter is MockAdapter) {
      var mockData = adapter.handleMock(request);
      if (mockData == null) {
        response = dioAdapter.send(request);
      } else {
        response = adapter.send(request);
      }
    } else {
      response = dioAdapter.send(request);
    }
    return response;
  }

  void printLog(log) {
    // print('hi_net${log.toString()}');
  }
}
