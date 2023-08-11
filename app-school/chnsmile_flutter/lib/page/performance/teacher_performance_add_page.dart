import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/performance_dao.dart';
import 'package:chnsmile_flutter/model/contact_family.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/model/teacher_performance_dict_model.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

/// 校务通知
class TeacherPerformanceAddPage extends StatefulWidget {
  @override
  _TeacherPerformanceAddPageState createState() =>
      _TeacherPerformanceAddPageState();
}

class _TeacherPerformanceAddPageState
    extends HiState<TeacherPerformanceAddPage> {
  final FocusNode focusNode1 = FocusNode();

  String title; // 标题
  List<ContactFamily> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  int selectCount = 0; // 选择人数

  TeacherPerformanceDictModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('添加表现'),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: ListView(
          children: [
            _buildTop(),
            hiSpace(height: 10),
            _buildContent(),
            hiSpace(height: 10),
            _buildContact(),
            hiSpace(height: 10),
            _buildButton()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadDefaultData();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    super.dispose();
  }

  unFocus() {
    focusNode1.unfocus();
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await PerformanceDao.dict();
      setState(() {
        model = result;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildTop() {
    return Row(
      children: [
        Star(),
        const Text('标题:', style: TextStyle(fontSize: 13, color: Colors.black)),
        Expanded(
          child: NormalInput(
            hint: "请输入标题",
            focusNode: focusNode1,
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

  List<Widget> _items(int type, List<CommentList> items) {
    return items.map((CommentList item) {
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
          childAspectRatio: 1,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          children: _items(1, model.commentList),
        ),
        _buildTopText('考勤'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 6,
          childAspectRatio: 0.8,
          children: _items(0, model.attendList),
        ),
      ],
    );
  }

  _buildContact() {
    return NormalSelect(
      hint: "学生",
      margin:0,
      rightWidget: Row(
        children: [
          Text('已选$selectCount人',
              style: const TextStyle(color: primary, fontSize: 13)),
          hiSpace(width: 5),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54)
        ],
      ),
      onSelectPress: showContact,
    );
  }

  showContact() {
    unFocus();
    BoostNavigator.instance.push('contact_family_page',
        arguments: {'selects': selectApproveList}).then((value) {
      var result = value as Map<String, ContactFamilyModel>;
      if (result == null) {
        return;
      }
      List<ContactFamily> sApproveList = [];
      var iApproveList = [];
      var selects = result['selects'];

      for (var item in selects.classInfo) {
        sApproveList.add(ContactFamily(item.classId, "", ""));
        iApproveList.add(item.classId);
      }

      for (var item in selects.studentParentInfo) {
        sApproveList.add(ContactFamily(item.classId, item.userId, item.studentId));
        iApproveList.add('${item.userId}-${item.studentId}-${item.classId}');
      }
      setState(() {
        selectApproveList = sApproveList;
        infoApproveList = iApproveList;
        selectCount = selects.selectedCount;
      });
    });
  }

  _buildButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
      child: OASubmitButton(
          onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed),
    );
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (isEmpty(title)) {
      showWarnToast("标题不能为空");
      return;
    }

    if (infoApproveList.isEmpty) {
      showWarnToast("请选择通知人");
      return;
    }

    try {
      var comments = [];
      var ids = [];
      String attend = ""; // 考勤
      model.commentList.forEach((item) {
        if (item.checked != null && item.checked) {
          comments.add(item.code);
        }
      });
      model.attendList.forEach((item) {
        if (item.checked != null && item.checked) {
          attend = item.code;
        }
      });

      if (comments.isEmpty && attend == "") {
        showWarnToast("请选择一个点评或者考勤内容");
        return;
      }

      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['title'] = title;
      params['comments'] = comments;
      params['attend'] = attend;
      params['studentScope'] = infoApproveList;
      params['operateDate'] = currentYearMothAndDay();
      params['status'] = isSave ? 0 : 1;

      var result = await PerformanceDao.submit(params, isSave: isSave);
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
