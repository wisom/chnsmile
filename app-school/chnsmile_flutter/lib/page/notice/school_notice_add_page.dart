import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/model/event_notice2.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/school_notice_detail_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/select_attach.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

/// 校务通知
class SchoolNoticeAddPage extends StatefulWidget {
  final Map params;
  String id;

  SchoolNoticeAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _SchoolNoticeAddPageState createState() => _SchoolNoticeAddPageState();
}

class _SchoolNoticeAddPageState extends HiState<SchoolNoticeAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  int noticeType = 1; // 通知类型
  int process = -1; // 教师处理类型
  String title; // 标题
  String content; // 内容
  String noticeConfimType; // 通知确认方式
  List<String> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  List orgIds = []; // 组织人员
  int selectCount = 0; // 选择人数
  List<LocalFile> files = [];
  List<ContactSelect> teacherContacts = []; // 老师

  SchoolNoticeDetailModel model;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadDefaultData();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  bool get isEdit {
    return widget.id != null;
  }

  void loadDefaultData() async {
    if (isEdit) {
      try {
        var result = await NoticeDao.detail(widget.id);
        setState(() {
          model = result;
          process = model.process;
          title = model.title;
          content = model.content;
          selectCount = model.infoApproveList.length;
          noticeType = model.grade;
          noticeConfimType = model.process == 1 ? '仅需教师阅读通知' : '需教师回复';
          model.infoApproveList.forEach((item) {
            var i =
                ContactSelect(item.approveId, item.approveName, false, null);
            ListUtils.selecters.add(i);
            infoApproveList.add({"approveId": item.approveId, "id": item.id, "orgId":item.deptId, "orgName": item.deptName, "realName":item.approveName});
            teacherContacts.add(i);
          });
        });
        isLoaded = true;
        EasyLoading.dismiss(animation: false);
      } catch (e) {
        print(e);
        isLoaded = true;
        EasyLoading.dismiss(animation: false);
      }
    }
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoaded
          ? Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListView(
                children: [
                  _buildContact(),
                  hiSpace(height: 10),
                  _buildTop(),
                  hiSpace(height: 10),
                  _buildAttach(),
                  hiSpace(height: 10),
                  _buildBottom(),
                  hiSpace(height: 10),
                  _buildButton()
                ],
              ),
            )
          : Container(),
    );
  }

  _buildAppBar() {
    var title = isEdit ? '通知详情' : '通知发送';
    var rightTitle = model != null && model.status == 0 ? '删除' : '';

    return appBar(title, rightTitle: rightTitle, rightButtonClick: () {
      delete();
    });
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await NoticeDao.delete(model?.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  _buildType(int type, String typeName, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: type,
          groupValue: noticeType,
          activeColor: primary,
          onChanged: (v) {
            setState(() {
              noticeType = v;
            });
          },
        ),
        Text(typeName, style: TextStyle(fontSize: 13, color: color))
      ],
    );
  }

  _buildTop() {
    return Column(
      children: [
        Row(
          children: [
            _buildType(1, '普通', primary),
            _buildType(2, '重要', Colors.deepOrange),
            _buildType(3, '紧急', Colors.red),
          ],
        ),
        hiSpace(height: 10),
        NormalInput(
          hint: "请输入标题",
          focusNode: focusNode1,
          initialValue: model != null ? model.title : '',
          onChanged: (text) {
            title = text;
          },
        ),
        hiSpace(height: 10),
        NormalMultiInput(
            hint: '请输入文字内容',
            focusNode: focusNode2,
            initialValue: model != null ? model.content : '',
            minLines: 5,
            maxLines: 5,
            onChanged: (text) {
              content = text;
            })
      ],
    );
  }

  _buildAttach() {
    return SelectAttach(
        attachs: model?.infoEnclosureList,
        itemsCallBack: (List<LocalFile> items) {
          print("items: ${items}");
          files = items ?? [];
        });
  }

  getClassAndContact() {
    var text = "";
    var deps = [];
    var contacts = [];
    if (teacherContacts.length == 0) {
      return text;
    }
    for (var item in teacherContacts) {
      if (item.isDep) {
        deps.add(item);
      } else {
        contacts.add(item);
      }
    }
    if (teacherContacts.length == 1) {
      text = teacherContacts[0].name;
    } else if (deps.length > 1) {
      text = deps[0].name + "等，${isEdit ? '共$selectCount名老师' : '老师'}";
    } else if (contacts.length > 1) {
      text = contacts[0].name + "等，${isEdit ? '共$selectCount名老师' : '老师'}";
    } else if (deps.length == 1) {
      if (contacts.length >= 1) {
        text = deps[0].name + "等，${isEdit ? '共$selectCount名老师' : '老师'}";
      }
    } else {
      text = contacts[0].name + "等，${isEdit ? '共$selectCount名老师' : '老师'}";
    }

    return text;
  }

  _buildContact() {
    return NormalSelect(
      hint: "发送通知给",
      rightWidget: Row(
        children: [
          Text('${getClassAndContact()}',
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
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': "school_notice_add_page",
      'isCleanPeople': false
    }).then((value) {
      var lists = ListUtils.selecters;
      print("list: $lists");
      if (lists.isEmpty) return;

      teacherContacts.clear();
      teacherContacts.addAll(ListUtils.selecters);

      List<String> sApproveList = [];
      var iApproveList = [];
      var iOrgIds = [];
      for (var item in lists) {
        sApproveList.add(item.id);
        if (item.isDep) {
          iOrgIds.add(item.id);
        } else {
          iApproveList.add({"approveId": item.id, "id": item.teacherId, "orgId":item.parentId, "orgName": item.orgName, "realName":item.name});
        }
      }
      setState(() {
        selectApproveList = sApproveList;
        orgIds = iOrgIds;
        infoApproveList = iApproveList;
        selectCount = infoApproveList.length;
      });
    });
  }

  unFocus() {
    focusNode1.unfocus();
    focusNode2.unfocus();
  }

  showStatusDialog() {
    unFocus();
    List<String> list = ['仅需教师阅读通知', '需教师回复'];
    showListDialog(context, title: '请选择教师确认方式', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        noticeConfimType = type;
        process = list.indexOf(type) + 1;
      });
    });
  }

  _buildBottom() {
    return NormalSelect(
      hint: "请选择教师确认方式",
      text: noticeConfimType ?? "",
      onSelectPress: showStatusDialog,
    );
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

    if (isEmpty(content)) {
      showWarnToast("内容不能为空");
      return;
    }

    if (infoApproveList.isEmpty) {
      if (orgIds.isEmpty) {
        showWarnToast("请选择通知人");
        return;
      }
    }

    if (process == -1) {
      showWarnToast("请选择教师确认方式");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      // 先上传文件
      List infoEnclosureList = [];
      if (isEdit &&
          model.infoEnclosureList != null &&
          model.infoEnclosureList.isNotEmpty) {
        for (var item in model.infoEnclosureList) {
          infoEnclosureList.add({"attachId": item.attachId});
        }
      }
      if (files.isNotEmpty) {
        for (var file in files) {
          if (!file.path.startsWith("http")) {
            UploadAttach uploadAttach = await AttachDao.upload(path: file.path);
            infoEnclosureList.add({"attachId": uploadAttach.id});
          }
        }
      }

      Map<String, dynamic> params = {};
      params['formId'] = model != null ? model.formId : '';
      params['title'] = title;
      params['title'] = title;
      params['content'] = content;
      params['grade'] = noticeType;
      params['process'] = process;
      params['orgIds'] = orgIds;
      params['infoApproveList'] = infoApproveList;
      params['infoEnclosureList'] = infoEnclosureList;
      params['remark'] = '';

      var result = await NoticeDao.submit(params, isSave: isSave);
      var bus = EventNotice2();
      eventBus.fire(bus);

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
