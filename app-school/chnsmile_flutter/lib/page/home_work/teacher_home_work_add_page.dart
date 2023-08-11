import 'dart:io';

import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/file_dao.dart';
import 'package:chnsmile_flutter/http/dao/home_work_dao.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/contact_family.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/model/event_notice2.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/teacher_home_work_detail_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/audio/demo_active_codec.dart';
import 'package:chnsmile_flutter/widget/audio/demo_common.dart';
import 'package:chnsmile_flutter/widget/audio/recorder_state.dart';
import 'package:chnsmile_flutter/widget/audio/temp_file.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_save_button.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/player_widget.dart';
import 'package:chnsmile_flutter/widget/record/voice_widget.dart';
import 'package:chnsmile_flutter/widget/select_attach.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chnsmile_flutter/flutter_sound/flutter_sound.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

/// 教师端的添加作业
class TeacherHomeWorkAddPage extends StatefulWidget {
  final Map params;
  String id;

  TeacherHomeWorkAddPage({Key key, this.params}) : super(key: key) {
    id = params != null ? params['id'] : '';
  }

  @override
  _TeacherHomeWorkAddPageState createState() => _TeacherHomeWorkAddPageState();
}

class _TeacherHomeWorkAddPageState extends HiState<TeacherHomeWorkAddPage> {
  int process = -1; // 教师处理类型
  String title; // 标题
  String content; // 内容
  String noticeConfimType; // 通知确认方式
  List<ContactFamily> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  int selectCount = 0; // 选择人数
  List<ContactSelect> familyContacts = []; // 家长
  List<LocalFile> files = [];
  String recordPath; // 本地的
  String urlAudioPath; // 网络的
  bool isRecorded = false;

  bool initialized = false;
  Track track;
  Track trackUrl;
  bool isShowVoice = true;

  bool isLoaded = false;
  TeacherHomeWorkDetailModel model;

  @override
  void initState() {
    super.initState();
    tempFile(suffix: '.aac').then((path) {
      print("add-path: $path");
      track = Track(trackPath: path);
      recordPath = path;
      setState(() {});
    });
    loadData();
  }

  loadData() async {
    if (isEdit) {
      isShowVoice = false;
      try {
        EasyLoading.show(status: '加载中...');
        var result = await HomeWorkDao.teacherDetail(widget.id);
        setState(() {
          model = result;
          title = model.title;
          content = model.content;
          process = model.userOperateType;
          noticeConfimType = model.userOperateType == 0 ? '仅需家长阅读通知' : '需家长点击确认';
          model.parentLabels.forEach((item) {
            infoApproveList.add(item.id);
            familyContacts.add(ContactSelect(item.id, item.name, item.type == 0, null));
            if (item.type == 0) {
              selectApproveList.add(ContactFamily("", item.id, ""));
            } else {
              var ss = item.id.split("-");
              if (ss.length > 0) {
                selectApproveList.add(ContactFamily("", ss[0], ""));
              }
            }
          });
          if (model.attachInfoList != null &&
              model.attachInfoList.isNotEmpty) {
            List<Attach> audioItems = [];
            for (var attach in result.attachInfoList) {
              if (isAudioType(attach.attachSuffix) &&
                  isNotEmpty(attach.attachUrl)) {
                audioItems.add(attach);
              }
            }
            if (audioItems.isNotEmpty) {
              for (var item in audioItems) {
                tempFile(fileName: item.origionName).then((path) {
                  print("path: $path");
                  if (!fileExists(path)) {
                    print("path1: $path");
                    var r = FileDao.download(item.attachUrl, path);
                  }
                  item.attachUrl = path;

                  setState(() {
                    urlAudioPath = path;
                    trackUrl = Track(trackPath: urlAudioPath);
                  });
                });
              }
            }
          }
          selectCount = int.parse(model.noticeUserSum);
        });
        isLoaded = true;
        EasyLoading.dismiss(animation: false);
      } on HiNetError catch (e) {
        print(e);
        isLoaded = true;
        showWarnToast(e.message);
        EasyLoading.dismiss(animation: false);
      }
    } else {
      isLoaded = true;
    }
  }

  @override
  void dispose() {
    // focusNode1.dispose();
    // focusNode2.dispose();
    super.dispose();
  }

  unFocus() {
    // focusNode1.unfocus();
    // focusNode2.unfocus();
  }

  bool get isEdit {
    return widget.id != null;
  }

  Future<bool> init() async {
    if (!initialized) {
      await UtilRecorder().init();
      ActiveCodec().recorderModule = UtilRecorder().recorderModule;
      ActiveCodec().setCodec(withUI: false, codec: Codec.aacADTS);

      initialized = true;
    }
    return initialized;
  }

  bool get isPublished {
    return model?.status == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(model?.status != 1 ? '添加作业' : '修改作业'),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: isLoaded ? ListView(
          children: [
            _buildContact(),
            hiSpace(height: 10),
            _buildTop(),
            hiSpace(height: 10),
            isShowVoice ? _buildVoice() : Container(),
            hiSpace(height: 10),
            !isShowVoice ? _buildAudio() : Container(),
            hiSpace(height: 10),
            _buildAttach(),
            hiSpace(height: 12),
            _buildBottom(),
            hiSpace(height: 10),
            _buildButton()
          ],
        ) : Container(),
      ),
    );
  }

  _buildTop() {
    return Column(
      children: [
        hiSpace(height: 10),
        NormalInput(
          hint: "请输入标题",
          initialValue: model != null ? model.title : '',
          onChanged: (text) {
            title = text;
          },
        ),
        hiSpace(height: 10),
        NormalMultiInput(
            hint: '请输入文字内容',
            initialValue: model != null ? removeHtmlTag(model.content) : '',
            minLines: 5,
            maxLines: 5,
            onChanged: (text) {
              content = text;
            })
      ],
    );
  }

  // startRecord() {
  //   print("开始录制");
  // }
  //
  // stopRecord(String path, double audioTimeLength) {
  //   print("结束束录制");
  //   setState(() {
  //     recordPath = path;
  //     isRecorded = true;
  //     print("recordPath: ${recordPath}");
  //   });
  // }

  _contentAudio() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 10, right: 10),
      height: 40,
      padding: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(width: 0.5, color: Colors.grey[300])),
      child: PlayerWidget(recordPath),
    );
  }

  _buildVoice() {
    return Column(
      children: [
        SoundRecorderUI(track),
      ],
    );
    // return Column(
    //   children: [
    //     recordPath != null ? _contentAudio() : Container(),
    //     VoiceWidget(
    //       startRecord: startRecord,
    //       stopRecord: stopRecord,
    //       height: 40,
    //     )
    //   ],
    // );
  }
  _buildAudio() {
    if (trackUrl == null) return Container();
    return Column(
      children: [
        SoundPlayerUI.fromTrack(
          trackUrl,
          showTitle: true,
          audioFocus: AudioFocus.requestFocusAndDuckOthers,
        ),
        isEdit ? InkWell(
          onTap: () {
            setState(() {
              isShowVoice = !isShowVoice;
            });
          },
          child: Container(
            alignment: Alignment.centerRight,
            child:  !isShowVoice ? const Icon(Icons.delete_forever_rounded, size: 22, color: Colors.red) : Container(),
          ),
        ) : Container()
      ],
    );
  }

  _buildAttach() {
    unFocus();
    List<Attach> attachs = [];
    model?.attachInfoList?.forEach((attach) {
      if (!isAudioType(attach.attachSuffix)) {
        attachs.add(attach);
      }
    });
    return SelectAttach(attachs: attachs, itemsCallBack: (List<LocalFile> items) {
      print("items: ${items}");
      files = items ?? [];
    });
  }

  _buildContact() {
    unFocus();
    return NormalSelect(
      hint: "发送通知给",
      isEnable: !isPublished,
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

  getClassAndContact() {
    var text = "";
    var deps = [];
    var contacts = [];
    if (familyContacts.length == 0) {
      return text;
    }
    for (var item in familyContacts) {
      if (item.isDep) {
        deps.add(item);
      } else {
        contacts.add(item);
      }
    }
    if (familyContacts.length == 1) {
      text = familyContacts[0].name;
    } else if (deps.length > 1) {
      text = deps[0].name + "等，共$selectCount名学生的家长";
    } else if (contacts.length > 1) {
      text = contacts[0].name + "等，共$selectCount名学生的家长";
    } else if (deps.length == 1) {
      if (contacts.length >= 1) {
        text = deps[0].name + "等，共$selectCount名学生的家长";
      }
    } else {
      text = contacts[0].name + "等，共$selectCount名学生的家长";
    }

    return text;
  }

  showContact() {
    FocusManager.instance.primaryFocus?.unfocus();
    BoostNavigator.instance.push('contact_family_page',
        arguments: {'selects': selectApproveList}).then((value) {
      var result = value as Map<String, ContactFamilyModel>;
      if (result == null) {
        return;
      }
      familyContacts.clear();

      List<ContactFamily> sApproveList = [];
      var iApproveList = [];
      var selects = result['selects'];
      selectCount = selects.selectedCount;

      List<ContactSelect> contacts = [];
      for (var item in selects.classInfo) {
        sApproveList.add(ContactFamily(item.classId, "", ""));
        iApproveList.add(item.classId);
        contacts.add(ContactSelect(
            item.classId, item.classGradeName + item.className, true, null));
      }
      for (var item in selects.studentParentInfo) {
        sApproveList.add(ContactFamily(item.classId, item.userId, item.studentId));
        iApproveList.add('${item.userId}-${item.studentId}-${item.classId}');
        contacts.add(ContactSelect(
            item.userId, item.studentName ?? item.className, false, null));
      }
      setState(() {
        selectApproveList = sApproveList;
        infoApproveList = iApproveList;
        familyContacts.addAll(contacts);
      });
    });
  }

  showStatusDialog() {
    FocusManager.instance.primaryFocus?.unfocus();
    List<String> list = ['仅需家长阅读通知', '需家长点击确认'];
    showListDialog(context, title: '请选择家长确认方式', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        noticeConfimType = type;
        process = list.indexOf(type);
      });
    });
  }

  _buildBottom() {
    return NormalSelect(
      hint: "请选择家长确认方式",
      isEnable: !isPublished,
      text: noticeConfimType ?? "",
      onSelectPress: showStatusDialog,
    );
  }

  _buildButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
      child: model?.status != 1 ? OASubmitButton(
          onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed) : OASaveButton(onSavePressed: onSavePressed),
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
      showWarnToast("请选择通知人");
      return;
    }

    if (process == -1) {
      showWarnToast("请选择教师确认方式");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      // 先上传文件
      List infoEnclosureList = [];
      if (isEdit && model.attachInfoList != null && model.attachInfoList.isNotEmpty) {
        for (var item in model.attachInfoList) {
          infoEnclosureList.add(item.attachId);
        }
      }
      if (files.isNotEmpty) {
        for (var file in files) {
          if (!file.path.startsWith("http")) {
            UploadAttach uploadAttach = await AttachDao.upload(path: file.path);
            infoEnclosureList.add(uploadAttach.id);
          }
        }
      }


      var recodeFile = File(recordPath);
      // 上传录音文件
      if (await recodeFile.exists() && await recodeFile.length() > 0) {
        UploadAttach uploadAttach = await AttachDao.upload(path: recordPath);
        infoEnclosureList.add(uploadAttach.id);
      }

      Map<String, dynamic> params = {};
      if (isEdit) {
        params['id'] = model?.id;
      }
      params['title'] = title;
      params['content'] = content;
      params['userOperateType'] = process;
      params['parentNoticeScope'] = infoApproveList;
      if (infoEnclosureList.isNotEmpty) {
        params['attachIds'] = infoEnclosureList.join(",");
      }
      params['status'] = isSave ? 0 : 1;

      var result = await HomeWorkDao.submit(params, isEdit: isEdit);
      var bus = EventNotice2();
      eventBus.fire(bus);
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
