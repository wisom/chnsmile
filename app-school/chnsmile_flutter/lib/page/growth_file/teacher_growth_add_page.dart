import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/growth_file_dao.dart';
import 'package:chnsmile_flutter/model/contact_family.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/star.dart';
import 'package:chnsmile_flutter/widget/time_picker/model/date_mode.dart';
import 'package:chnsmile_flutter/widget/time_picker/model/suffix.dart';
import 'package:chnsmile_flutter/widget/time_picker/pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

/// 校务通知
class TeacherGrowthAddPage extends StatefulWidget {
  @override
  _TeacherGrowthAddPageState createState() =>
      _TeacherGrowthAddPageState();
}

class _TeacherGrowthAddPageState
    extends HiState<TeacherGrowthAddPage> {
  String timeInfo; // 点评日期
  String content; // 内容
  List<ContactFamily> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  int selectCount = 0; // 选择人数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('添加成长档案'),
      body: Container(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        color: Colors.white,
        child: ListView(
          children: [
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
  }

  timeClick() {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day}';
        setState(() {
          timeInfo = time;
        });
      },
    );
  }

  _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Star(),
            const Text('点评日期:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            Expanded(
                child: InkWell(
                    onTap: () {
                      timeClick();
                    },
                    child: Container(
                      height: 38,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey[200], width: 1)),
                      child: Text(timeInfo ?? '请选择点评日期',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ))),
          ],
        ),
        hiSpace(height: 12),
        Row(
          children: [
            Star(),
            const Text('点评内容:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
          ],
        ),
        hiSpace(height: 8),
        NormalMultiInput(
            hint: '请输入点评内容',
            minLines: 5,
            maxLines: 5,
            onChanged: (text) {
              content = text;
            })
      ],
    );
  }

  _buildContact() {
    return NormalSelect(
      hint: "学生",
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
    BoostNavigator.instance.push('contact_family_page',
        arguments: {'selects': selectApproveList}).then((value) {
      var result = value as Map<String, ContactFamilyModel>;
      if (result == null) {
        return;
      }
      List<ContactFamily> sApproveList = [];
      var iApproveList = [];
      var selects = result['selects'];
      print("selects: $selects");

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
    if (isEmpty(timeInfo)) {
      showWarnToast("请选择点评日期");
      return;
    }

    if (isEmpty(content)) {
      showWarnToast("内容不能为空");
      return;
    }

    if (infoApproveList.isEmpty) {
      showWarnToast("请选择通知人");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['archiveContent'] = content;
      params['studentScope'] = infoApproveList;
      params['timeInfo'] = timeInfo;
      params['status'] = isSave ? 0 : 1;

      var result = await GrowthFileDao.submit(params, isSave: isSave);
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop("success");
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }
}
