import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/performance_dao.dart';
import 'package:chnsmile_flutter/model/teacher_performance_detail_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class TeacherPerformanceDetailPage extends StatefulWidget {
  final Map params;
  String classId;
  String operateDate;

  TeacherPerformanceDetailPage({Key key, this.params}) : super(key: key) {
    classId = params['classId'];
    operateDate = params['operateDate'];
  }

  @override
  _TeacherPerformanceDetailPageState createState() =>
      _TeacherPerformanceDetailPageState();
}

class _TeacherPerformanceDetailPageState
    extends HiState<TeacherPerformanceDetailPage> {
  TeacherPerformanceDetailModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await PerformanceDao.detail(widget.classId, widget.operateDate);
      setState(() {
        model = result;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('班级表现'),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: loadData,
            child: ListView(
              children: [
                _buildContent(),
              ],
            ),
          ),
        ));
  }

  List<Widget> _items(List<Comments> items) {
    return items.map((Comments item) {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200], width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      right: 10, top: 10, bottom: 3, left: 10),
                  child: Text(item.count.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.black))),
              hiSpace(height: 10),
              Text(item.behaviorContent ?? '无',
                  style: const TextStyle(
                      fontSize: 16, color: HiColor.common_text)),
            ],
          ));
    }).toList();
  }

  _buildContent() {
    if (model == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopText('考勤'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1,
          children: _items(model.attend),
        ),
        _buildTopText('点评'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1,
          children: _items(model.comments),
        ),
      ],
    );
  }

  _buildTopText(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, color: primary)),
    );
  }
}
