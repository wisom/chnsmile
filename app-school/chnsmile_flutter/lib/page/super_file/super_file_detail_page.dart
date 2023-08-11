import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/super_file_dao.dart';
import 'package:chnsmile_flutter/model/super_file_detail_model.dart';
import 'package:chnsmile_flutter/model/super_file_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:chnsmile_flutter/widget/oa_two_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';
import '../../model/contact_select.dart';
import '../../utils/list_utils.dart';
import '../../widget/oa_attach_detail.dart';
import '../../widget/oa_one_text_wrap.dart';

///上级文件详情
class SuperFileDetailPage extends StatefulWidget {
  final Map params;
  SuperFile info;
  int reviewStatus = 0; // 审核需要用到
  bool isFromOA = false;
  String TAG = "SuperFileDetailPage==";

  SuperFileDetailPage({Key key, this.params}) : super(key: key) {
    info = params['item'];
    reviewStatus = params['reviewStatus'];
    // isFromOA = params['isFromOA'];
  }

  @override
  _SuperFileDetailPageState createState() => _SuperFileDetailPageState();
}

class _SuperFileDetailPageState extends HiState<SuperFileDetailPage> {
  SuperFileDetailModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: RefreshIndicator(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [_buildTop(), _buildBottom()],
              ),
            ),
            onRefresh: loadData));
  }

  _buildAppBar() {
    return appBar("文件详情", rightTitle: "转发", rightButtonClick: () {
      showContact();
    });
  }

  transfer(List<ContactSelect> list) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await SuperFileDao.transfer(widget.info.formId, list);
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await SuperFileDao.detail(widget.info.formId ?? "");
      setState(() {
        model = result;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print("SuperFileDetail===" + e);
      showWarnToast(e.message);
    }
  }

  _buildBottom() {
    return Container(
        child: Column(
      children: [
        line(context),
        hiSpace(height: 10),
        _buildApply(),
        hiSpace(height: 30)
      ],
    ));
  }

  _buildTop() {
    if (model == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          OATwoText('表单编号:', model.formId ?? "", '通知日期:',
              dateYearMothAndDay(widget.info.createTime),
              // isLong: true,
              content1Color: Colors.grey,
              content2Color: Colors.grey),
          OATwoText('发  起  人:', model.createName ?? "", '通知状态:',
              buildOAApplyStatus2(model.status)[1],
              content1Color: Colors.grey,
              // isLong: true,
              content2Color: buildOAApplyStatus2(model.status)[0]),
          boxLine(context),
          OAOneText('文件编号:    ', model.formId ?? ""),
          OAOneText(
            '文件标题:    ',
            model.title ?? "",
          ),
          OAOneText('文件内容', "",
              tipColor: HiColor.color_181717, tipFontWeight: FontWeight.bold),
          line(context),
          hiSpace(height: 8),
          OAOneTextWrap(
            '',
            model.content ?? "",
            contentColor: HiColor.color_181717_A50,
          ),
          hiSpace(height: 8),
          OAOneText('备注', "",
              tipColor: HiColor.color_181717, tipFontWeight: FontWeight.bold),
          line(context),
          OAOneText('', model.remark ?? ""),
        ],
      ),
    );
  }

  _buildApply() {
    List<UploadAttach> datas = model?.papersDowmAccessoryList;
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: datas?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(border: BorderTimeLine(index)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildAttach(datas)],
                  ),
                ),
              );
            }));
  }

  _buildAttach(List<UploadAttach> attach) {
    if (attach != null && attach.isNotEmpty) {
      return Column(
        children: [
          OAOneText('附件', '', tipColor: Colors.black),
          boxLine(context),
          OAAttachDetail(items: attach.map((e) => e.toAttach(e)))
        ],
      );
    } else {
      return Container();
    }
  }

  List<ContactSelect> teacherContacts = []; // 老师
  showContact() {
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': "super_file_detail_page",
      'isCleanPeople': true
    }).then((value) {
      var lists = ListUtils.selecters;
      print("list: $lists");
      if (lists.isEmpty) return;

      teacherContacts.clear();
      teacherContacts.addAll(ListUtils.selecters);

      transfer(teacherContacts);
    });
  }
}
