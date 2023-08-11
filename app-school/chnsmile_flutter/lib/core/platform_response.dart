import 'dart:convert' as convert;

class PlatformResponse<T> {
  ///success为false msg一定有 直接show出来就可以
  bool get success => error == null;

  String msg;
  /// 约定1000以上为本地网络出错
  int code = 0;
  bool get netError => code >= 1000;
  T data;
  StackTrace stackTrace;
  dynamic error;

  PlatformResponse.from(Map map) {
    this.code = map["code"];
    this.data = map["data"];
    this.msg = map["msg"];
  }

  List listData() {
    try {
      List<dynamic> listData = data as List;
      return listData;
    } catch (error) {
      throw Exception("data不是list类型");
    }
  }

  List<Map<String, dynamic>> listMapData() {
    try {
      List<dynamic> listData = data as List;
      List<Map<String, dynamic>> listMapData = [];
      for (var i in listData) {
        if (i is Map) {
          listMapData.add(i);
        } else {
          Map<String, dynamic> map = convert.jsonDecode(i as String);
          listMapData.add(map);
        }
      }
      return listMapData;
    } catch (error) {
      throw Exception("data不是list类型");
    }
  }

  Map<String, dynamic> mapData() {
    try {
      if (data == null || data == "") {
        return {};
      }
      if (data is Map) {
        return data as Map<String, dynamic>;
      }
      if (data is String) {
        Map<String, dynamic> mapData = convert.jsonDecode(data as String);
        return mapData;
      }
      return {};
    } catch (error) {
      throw Exception("data不是map类型");
    }
  }

  PlatformResponse.error(e, StackTrace stackTrace,{int code,String msg = "数据获取异常"}) {
    this.stackTrace = stackTrace;
    this.error = e;
    this.msg = msg;
    this.code = code;
  }

  Exception errorException() {
    if (netError) {
      return NetErrorException();
    } else if (!success) {
      return ErrorException(
          message: this.msg, error: this.error, stackTrace: this.stackTrace);
    }
    return null;
  }
}

class NetErrorException implements Exception {
  const NetErrorException();

  @override
  String toString() => '本地网络错误';
}

class ErrorException implements Exception {
  ErrorException({this.message, this.error, this.stackTrace});
  String message;
  dynamic error;
  StackTrace stackTrace;
}
