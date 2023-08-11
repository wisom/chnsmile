import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/performance_dao.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_detail2_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_detail_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_dict_model.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

/// 校务通知
class TeacherPerformanceDetail2Page extends StatefulWidget {
  final Map params;
  String id;
  String operateDate;

  TeacherPerformanceDetail2Page({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _TeacherPerformanceDetail2PageState createState() =>
      _TeacherPerformanceDetail2PageState();
}

class _TeacherPerformanceDetail2PageState
    extends HiState<TeacherPerformanceDetail2Page> {
  String title; // 标题
  List<String> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  int selectCount = 0; // 选择人数

  TeacherPerformanceDetail2Model model;
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('表现'),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: model != null ? ListView(
          children: [
            _buildTop(),
            hiSpace(height: 10),
            _buildContent(),
            hiSpace(height: 10),
            _buildButton()
          ],
        ) : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData();
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool get isPublish {
    if (model == null) return true;
    return model.status == 1;
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      isLoaded = true;
      var result = await PerformanceDao.detail2(widget.id);
      setState(() {
        model = result;
        title = model.title;
      });
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      print(e);
      showWarnToast(e);
    }
  }

  _buildTop() {
    return Row(
      children: [
        const Text('标题:', style: TextStyle(fontSize: 15, color: Colors.black)),
        Expanded(
          child: NormalInput(
            hint: "请输入标题",
            initialValue: model != null ? model.title : '',
            onChanged: (text) {
              title = text;
            },
          ),
        )
      ],
    );
  }

  _buildTopText(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(title, style: const TextStyle(fontSize: 15, color: primary)),
    );
  }

  int getInt(String code) {
    return int.parse(code);
  }

  List<Widget> _items(int type, List<CommentDictList> items) {
    return items.map((CommentDictList item) {
      return InkWell(
          onTap: () {
            setState(() {
              if (type == 0) {
                items.forEach((element) {
                  if (element.id == item.id) {
                    item.checked = !item.checked;
                  } else {
                    element.checked = false;
                  }
                });

              } else {
                items.forEach((element) {
                  if (element.id == item.id) {
                    item.checked = !item.checked;
                  } else {
                    if ((getInt(item.code).abs() == getInt(element.code).abs()) && element.checked == true) {
                      element.checked = false;
                    }
                  }
                });
              }
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  color: item.checked ? Colors.grey[100] : Colors.white,
                  border: Border.all(color: Colors.grey[200], width: 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 10, top: 10, bottom: 3, left: 10),
                      child: cachedImage(item.remark, width: 60, height: 60)),
                  Text(item.value ?? '无',
                      style: const TextStyle(
                          fontSize: 13, color: HiColor.common_text)),
                ],
              )));
    }).toList();
  }

  _buildContent() {
    if (model == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopText('点评'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          children: _items(1, model.commentDictList),
        ),
        _buildTopText('考勤'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 6,
          children: _items(0, model.attendDictList),
        ),
      ],
    );
  }

  _buildButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 30),
      child: OASubmitButton(
          onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed),
    );
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    try {
      var comments = [];
      String attend = ""; // 考勤
      model.commentDictList.forEach((item) {
        if (item.checked != null && item.checked) {
          comments.add(item.code);
        }
      });
      model.attendDictList.forEach((item) {
        if (item.checked != null && item.checked) {
          attend = item.code;
        }
      });

      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['ids'] = [model.id];
      params['title'] = title;
      params['comments'] = comments;
      params['attend'] = attend;
      params['operateDate'] = currentYearMothAndDay();
      params['status'] = isSave ? 0 : 1;

      var result = await PerformanceDao.edit(params, isSave: isSave);
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }
}
