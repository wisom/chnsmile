import 'package:chnsmile_flutter/http/hi_net.dart';
import 'package:chnsmile_flutter/http/request/course_request.dart';
import 'package:chnsmile_flutter/model/course_model.dart';

class CourseDao {
  static get() async {
    CourseRequest request = CourseRequest();
    var result = await HiNet.getInstance().fire(request);
    return CourseModel.fromJson(result['data']);
  }
}
