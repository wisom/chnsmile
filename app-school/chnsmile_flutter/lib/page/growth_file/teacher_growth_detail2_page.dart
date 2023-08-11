import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/growth_file_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/teacher_growth2_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
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
import 'package:hi_base/view_util.dart';

/// 校务通知
class TeacherGrowthDetail2Page extends StatefulWidget {
  final Map params;
  TeacherGrowth2 item;
  String operateDate;

  TeacherGrowthDetail2Page({Key key, this.params}) : super(key: key) {
    item = params['item'];
  }

  @override
  _TeacherGrowthDetail2PageState createState() =>
      _TeacherGrowthDetail2PageState();
}

class _TeacherGrowthDetail2PageState
    extends HiState<TeacherGrowthDetail2Page> {
  String timeInfo; // 点评日期
  String title; // 标题
  List<String> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  int selectCount = 0; // 选择人数

  @override
  void initState() {
    super.initState();
    title = widget.item.archiveContent;
    timeInfo = widget.item.timeInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('成长档案详情'),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: widget.item != null ? ListView(
          children: [
            _buildTop(),
            hiSpace(height: 10),
            _buildButton()
          ],
        ) : const EmptyView(),
      ),
    );
  }

  bool get isPublish {
    if (widget.item == null) return true;
    return widget.item.status == 1;
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

  _buildTop() {
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
                      child: Text(widget.item?.timeInfo ?? '请选择点评日期',
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
            initialValue: widget.item?.archiveContent ?? '',
            onChanged: (text) {
              title = text;
            })
      ],
    );
  }

  _buildButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
      child: OASubmitButton(
          leftEnabled: !isPublish,
          onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed),
    );
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['ids'] = [widget.item.id];
      params['archiveContent'] = title;
      params['studentScope'] = widget.item.studentScope;
      params['timeInfo'] = timeInfo;
      params['status'] = isSave ? 0 : 1;

      var result = await GrowthFileDao.edit(params, isSave: isSave);
      showWarnToast(isSave ? '保存成功' : '发布成功');
      if (!isSave){
        var bus = EventNotice();
        bus.formId = widget.item.id;
        eventBus.fire(bus);
      }
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }
}
