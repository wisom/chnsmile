import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/course_dao.dart';
import 'package:chnsmile_flutter/model/course_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/syllabus_page.dart';
import 'package:flutter/material.dart';
import 'package:hi_cache/hi_cache.dart';

class MyCoursePage extends StatefulWidget {

  @override
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends HiState<MyCoursePage> {
  List<Course> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('课程表'),
      body: RefreshIndicator(child: SyllabusPage(list: list), onRefresh: loadData),
    );
  }

  bool get isFamily {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "1";
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  Future<void> loadData() async {
    try {
      // EasyLoading.show(status: '加载中...');
      var result = await CourseDao.get();
      setState(() {
        list = result.list;
      });
      if (list.isEmpty) {
        if (isFamily) {
          showWarnToast("请联系班主任设置课程对应的任课教师");
        } else {
          showWarnToast("请联系管理员设置课程对应的班级");
        }
      }

      // EasyLoading.dismiss(animation: false);
    } on HiNetError catch (e) {
      // EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    } catch (e) {
      print(e);
      showWarnToast("数据异常");
    }
  }
}
