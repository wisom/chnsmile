import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/default_apply_document_request.dart';
import 'package:chnsmile_flutter/http/request/default_apply_request.dart';
import 'package:chnsmile_flutter/http/request/vacation_default_request.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';

class DefaultApplyDao {
  static get() async {
    DefaultApplyRequest request = DefaultApplyRequest();
    var result = await HiNet.getInstance().fire(request);
    if (result['data'] == null) return null;
    return DefaultApplyModel.fromJson(result['data']);
  }

  static getDocument() async {
    DefaultApplyDocumentRequest request = DefaultApplyDocumentRequest();
    var result = await HiNet.getInstance().fire(request);
    if (result['data'] == null) return null;
    return DefaultApplyModel.fromJson(result['data']);
  }

  static getVacation(String hour) async {
    VacationDefaultRequest request = VacationDefaultRequest();
    request.add("hour", hour);
    var result = await HiNet.getInstance().fire(request);
    return DefaultApplyModel.fromJson(result['data']);
  }
}
