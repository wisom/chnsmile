import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/file_download_request.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';

class FileDao {

  static download(String url, String savePath) async {
    FileDownloadRequest request = FileDownloadRequest(url);
    request.add("savePath", savePath);
    var result = await HiNet.getInstance().fire(request);
    return 'ok';
  }

}
