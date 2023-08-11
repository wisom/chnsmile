import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/upload_file_request.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:dio/dio.dart';

class AttachDao {
  static upload({String path}) async {
    UploadFileRequest request = UploadFileRequest();
    FormData formdata =
        FormData.fromMap({"file": await MultipartFile.fromFile(path)});
    request.addFormData(formdata);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == HiConstant.successCode) {
      return UploadAttach.fromJson(result['data']);
    } else {
      throw HiNetError(HiConstant.errorBusCode, result['message']);
    }
  }
}
