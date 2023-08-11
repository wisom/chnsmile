import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/request/base_request.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';

class FileDownloadRequest extends BaseRequest {
  final String fileUrl;

  FileDownloadRequest(this.fileUrl);

  @override
  HttpMethod httpMethod() {
    return HttpMethod.DOWNLOAD;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return fileUrl;
  }
}
