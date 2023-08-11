
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_family.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/model/vote_school_class_model.dart';
import 'package:chnsmile_flutter/model/vote_school_detail_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/dotted_border.dart';
import 'package:chnsmile_flutter/widget/hi_radio.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
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

class SchoolVoteAddPage extends StatefulWidget {
  final Map params;
  String voteId;

  SchoolVoteAddPage({Key key, this.params}) : super(key: key) {
    voteId = params['voteId'];
  }

  @override
  _SchoolVoteAddPageState createState() => _SchoolVoteAddPageState();
}

class _SchoolVoteAddPageState extends HiState<SchoolVoteAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  String title; // 标题
  String content; // 内容
  int voteType = 0; // 选择类型
  String startTime; // 开始时间
  String endTime; // 结束时间
  bool isHiddenAddOption = false;
  int initLength = 1;

  List<ContactSelect> teacherContacts = []; // 教师
  List<ContactSelect> familyContacts = []; // 家长
  List<ContactFamily> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员
  var letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  int maxLength = 6;
  List<Widget> optionsWidget = []; // 投票选项控件
  List<String> options = List.filled(6, ''); // 投票选项
  bool isTeacherAllSelect = false;
  bool isFamilyAllSelect = false;

  VoteSchoolDetailModel model;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  unFocus() {
    focusNode1.unfocus();
    focusNode2.unfocus();
  }

  bool get isEdit {
    return widget.voteId != null;
  }

  // voteStatus 0 未发布 1 已发布 3 已撤回
  bool get isUnPublished {
    if (model == null) return false;
    return model.voteStatus == 0;
  }

  // voteStatus 0 未发布 1 已发布 3 已撤回
  bool get isPublished {
    if (model == null) return false;
    return model.voteStatus == 1;
  }

  // voteStatus 0 未发布 1 已发布 3 已撤回
  bool get isRevoke {
    if (model == null) return false;
    return model.voteStatus == 3;
  }

  loadData() async {
    if (isEdit) {
      try {
        EasyLoading.show(status: '加载中...');
        var result = await VoteDao.voteSchoolDetail(widget.voteId);
        initAddButton();
        setState(() {
          model = result;
          title = model.voteTitle;
          content = model.voteDesc;
          voteType = model.voteType;
          startTime = model.startTime;
          endTime = model.endTime;
          isTeacherAllSelect = model.hasTeacherAll == 1;
          isFamilyAllSelect = model.hasStudentAll == 1;
          if (model.voteOptions != null && model.voteOptions.isNotEmpty) {
            initLength = model.voteOptions.length;
            for (var i = 0; i < model.voteOptions.length; i++) {
              var item = model.voteOptions[i];
              options[i] = item.voteName;
            }
          }
          // 选择的人员
          model.teacherLabels.forEach((item) {
            var i = ContactSelect(item.id, item.name, item.type == 0, null);
            teacherContacts.add(i);
            ListUtils.selecters.add(i);
          });
          model.parentLabels.forEach((item) {
            familyContacts
                .add(ContactSelect(item.id, item.name, item.type == 0, null));
            selectApproveList.add(ContactFamily(item.id, "", ""));
          });
          infoApproveList = model.parentVoteScope;
        });
        isLoaded = true;
        initOptions();
        EasyLoading.dismiss(animation: false);
      } on HiNetError catch (e) {
        print(e);
        isLoaded = true;
        showWarnToast(e.message);
        EasyLoading.dismiss(animation: false);
      }
    } else {
      isLoaded = true;
      initOptions();
      initAddButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: ListView(
          children: [
            isLoaded ? _buildContent() : Container(),
            hiSpace(height: 20),
            isLoaded ? _buildButton() : Container(),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    var rightTitle = '';
    if (isRevoke) {
      rightTitle = '查看结果';
    } else if (isPublished) {
      rightTitle = '撤回';
    }
    return appBar(isEdit ? '投票详情' : '新建投票', rightTitle: rightTitle,
        rightButtonClick: () {
      if (rightTitle == '查看结果') {
        showResult();
      } else if (rightTitle == '撤回') {
        revoke();
      }
    });
  }

  showResult() {
    BoostNavigator.instance
        .push('school_vote_result_page', arguments: {"voteId": widget.voteId});
  }

  revoke() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await VoteDao.revoke(widget.voteId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  initAddButton() {
    teacherContacts.add(ContactSelect("-1", "添加", false, "-1"));
    familyContacts.add(ContactSelect("-1", "添加", false, "-1"));
  }

  initOptions() {
    for (var i = 0; i < initLength; i++) {
      optionsWidget.add(_buildOptions(i, letters[i]));
    }
  }

  _getInitOptionValue(int option) {
    if (model != null && model.voteOptions.isNotEmpty) {
      if (option > model.voteOptions.length - 1) return '';
      return model.voteOptions[option].voteName;
    }
    return '';
  }

  bool get isEnabled {
    return !(isEdit && !isUnPublished);
  }

  _buildOptions(int option, var letter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('选项$letter:',
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          Expanded(
            child: NormalInput(
              hint: "请输入选项",
              enabled: isEnabled,
              initialValue: _getInitOptionValue(option),
              onChanged: (text) {
                setState(() {
                  options[option] = text;
                });
              },
            ),
          ),
          optionsWidget.length >= 1
              ? InkWell(
                  onTap: () {
                    if (!isEnabled) {
                      return;
                    }
                    setState(() {
                      optionsWidget.removeAt(option > optionsWidget.length - 1
                          ? optionsWidget.length - 1
                          : option);
                      if (isNotEmpty(options[option])) {
                        options[option] = '';
                      }
                      setIsHidden();
                    });
                  },
                  child: isEnabled
                      ? const Icon(Icons.delete_forever_rounded,
                          size: 20, color: Colors.grey)
                      : Container(),
                )
              : Container()
        ],
      ),
    );
  }

  _buildContent() {
    return Column(
      children: [
        Row(
          children: [
            Star(),
            const Text('标题:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            Expanded(
              child: NormalInput(
                hint: "请输入标题",
                focusNode: focusNode1,
                initialValue: model != null ? model.voteTitle : '',
                onChanged: (text) {
                  title = text;
                },
              ),
            )
          ],
        ),
        hiSpace(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Star(),
                const Text('内容:',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
            hiSpace(height: 8),
            NormalMultiInput(
                hint: '请输入内容',
                focusNode: focusNode2,
                initialValue:
                    model != null ? removeHtmlTag(model.voteDesc) : '',
                margin: 0,
                minLines: 5,
                maxLines: 5,
                onChanged: (text) {
                  content = text;
                })
          ],
        ),
        hiSpace(height: 10),
        Column(
          children: optionsWidget.map((e) => e).toList(),
        ),
        hiSpace(height: 10),
        !isHiddenAddOption
            ? InkWell(
                onTap: () {
                  if (!isEnabled) {
                    return;
                  }
                  setState(() {
                    optionsWidget.add(_buildOptions(
                        optionsWidget.length, letters[optionsWidget.length]));
                    setIsHidden();
                  });
                },
                child: isEnabled
                    ? DottedBorder(
                        dashPattern: [8, 4],
                        color: Colors.grey[200],
                        strokeWidth: 1,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 36,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 24, color: Colors.grey),
                              Text('添加选项',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13))
                            ],
                          ),
                          // color: Colors.black26,
                        ),
                      )
                    : Container(),
              )
            : Container(),
        hiSpace(height: 10),
        Row(
          children: [
            const Text('方式:',
                style: TextStyle(fontSize: 13, color: Colors.black)),
            _buildType(0, '单选', Colors.black),
            _buildType(1, '多选', Colors.black),
          ],
        ),
        hiSpace(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Star(),
                const Text('投票时间:',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
            hiSpace(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!isEnabled) {
                        return;
                      }
                      unFocus();
                      timeClick(1);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color:
                              isEnabled ? Colors.transparent : Colors.grey[100],
                          border:
                              Border.all(color: Colors.grey[200], width: 1)),
                      child: Text(startTime ?? '开始时间',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ),
                  ),
                ),
                const Icon(Icons.swap_horiz, color: Colors.grey, size: 20),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        if (!isEnabled) {
                          return;
                        }
                        timeClick(2);
                        unFocus();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: isEnabled
                                ? Colors.transparent
                                : Colors.grey[100],
                            border:
                                Border.all(color: Colors.grey[200], width: 1)),
                        child: Text(endTime ?? '结束时间',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54)),
                      )),
                ),
              ],
            ),
          ],
        ),
        hiSpace(height: 10),
        _buildSelectContact()
      ],
    );
  }

  timeClick(int type) {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMDHM,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        FocusManager.instance.primaryFocus?.unfocus();
        String time = '${p.year}-${p.month}-${p.day} ${p.hour}:${p.minute}';
        setState(() {
          if (type == 1) {
            startTime = time;
          } else {
            endTime = time;
          }
        });
      },
      // onChanged: (p) => print(p),
    );
  }

  _buildType(int type, String typeName, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: type,
          groupValue: voteType,
          activeColor: isEnabled ? primary : Colors.grey[300],
          onChanged: (v) {
            if (!isEnabled) return;
            setState(() {
              voteType = v;
            });
          },
        ),
        Text(typeName, style: TextStyle(fontSize: 13, color: color))
      ],
    );
  }

  showContact(int type) {
    unFocus();
    if (type == 1) {
      BoostNavigator.instance.push("teacher_select_page", arguments: {
        'router': "school_vote_add_page",
        'isCleanPeople': false
      }).then((value) {
        // 比较两个是否有相同的
        List<ContactSelect> mergedList = [];
        mergedList.addAll(teacherContacts);
        for (ContactSelect contact in ListUtils.selecters) {
          bool isDuplicate = false;
          for (ContactSelect mergedContact in mergedList) {
            if (contact.name == mergedContact.name) {
              isDuplicate = true;
              break;
            }
          }
          if (!isDuplicate) {
            mergedList.add(contact);
          }
        }

        print("intersection: $mergedList");
        teacherContacts = mergedList;
        // teacherContacts.removeRange(1, teacherContacts.length);
        // teacherContacts.addAll(union);
        bool allDep = true;
        ListUtils.selecters.forEach((item) {
          if (item.parentId != "0") {
            allDep = false;
          }
        });
        setState(() {
          isTeacherAllSelect = allDep;
        });
      });
    } else {
      BoostNavigator.instance.push('contact_family_page',
          arguments: {'selects': selectApproveList}).then((value) {
        var result = value as Map<String, ContactFamilyModel>;
        if (result == null) {
          return;
        }
        // familyContacts.removeRange(1, familyContacts.length);
        List<ContactFamily> sApproveList = [];
        var iApproveList = [];
        var selects = result['selects'];

        List<ContactSelect> contacts = [];
        for (var item in selects.classInfo) {
          sApproveList.add(ContactFamily(item.classId, "", ""));
          iApproveList.add(item.classId);
          contacts.add(ContactSelect(
              item.classId, item.classGradeName + item.className, true, null));
        }
        for (var item in selects.studentParentInfo) {
          sApproveList
              .add(ContactFamily(item.classId, item.userId, item.studentId));
          iApproveList.add('${item.userId}-${item.studentId}-${item.classId}');
          contacts.add(ContactSelect(
              item.userId, item.studentName ?? item.className, false, null));
        }

        // 合并
        List<ContactSelect> mergedList = [];
        mergedList.addAll(familyContacts);
        for (ContactSelect contact in contacts) {
          bool isDuplicate = false;
          for (ContactSelect mergedContact in mergedList) {
            if (contact.name == mergedContact.name) {
              isDuplicate = true;
              break;
            }
          }
          if (!isDuplicate) {
            mergedList.add(contact);
          }
        }

        // 合并
        List<ContactFamily> mergedList2 = [];
        mergedList2.addAll(selectApproveList);
        for (ContactFamily contact in sApproveList) {
          bool isDuplicate = false;
          for (ContactFamily mergedContact in mergedList2) {
            if ((contact.classId == mergedContact.classId) &&
                (contact.studentId == mergedContact.studentId)) {
              isDuplicate = true;
              break;
            }
          }
          if (!isDuplicate) {
            mergedList2.add(contact);
          }
        }

        // 合并
        List mergedList3 = [];
        mergedList3.addAll(infoApproveList);
        for (String contact in iApproveList) {
          if (!mergedList3.contains(contact)) {
            mergedList3.add(contact);
          }
        }

        setState(() {
          selectApproveList = mergedList2;
          infoApproveList = mergedList3;
          familyContacts = mergedList;
          isFamilyAllSelect = selects.allSelected;
        });
      });
    }
  }

  _buildButton() {
    return !isRevoke
        ? Container(
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
            child: OASubmitButton(
                leftEnabled: isEnabled,
                onSavePressed: onSavePressed,
                onSubmitPressed: onSubmitPressed),
          )
        : Container();
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

    if (options.length < 3) {
      showWarnToast("请输入至少2个选项");
      return;
    }

    if (isEmpty(startTime)) {
      showWarnToast("请选择开始时间");
      return;
    }

    if (isEmpty(endTime)) {
      showWarnToast("请选择结束时间");
      return;
    }

    List voteOptions = [];
    for (var option in options) {
      if (isEmpty(option)) {
        continue;
      }
      voteOptions.add({"voteName": option});
    }

    List teacherVoteScope = [];
    for (var item in teacherContacts) {
      if (item.id == "-1") {
        continue;
      }
      if (item.isDep) {
        teacherVoteScope.add(item.id + "-0");
      } else {
        teacherVoteScope.add(item.id);
      }
    }

    try {
      EasyLoading.show(status: '加载中...');

      Map<String, dynamic> params = {};
      params['id'] = widget.voteId;
      params['voteTitle'] = title;
      params['voteDesc'] = content;
      params['voteType'] = voteType.toString(); //  投票类型： 单选还是多选
      params['voteStatus'] = isSave ? 0 : 1; // 保存 是 0  发布是1
      params['voteOptions'] = voteOptions;
      params['teacherVoteScope'] = teacherVoteScope;
      params['parentVoteScope'] = infoApproveList;
      params['startTime'] = startTime;
      params['endTime'] = endTime;
      params['hasTeacherAll'] = isTeacherAllSelect ? 1 : 0;
      params['hasStudentAll'] = isFamilyAllSelect ? 1 : 0;

      var result;
      if (isEdit) {
        // 合并
        List mergedList = [];
        mergedList.addAll(infoApproveList);
        for (String contact in model.parentVoteScope) {
          if (!mergedList.contains(contact)) {
            mergedList.add(contact);
          }
        }

        params['teacherVoteScope'] = teacherVoteScope;
        params['parentVoteScope'] = mergedList;
        result = await VoteDao.schoolEdit(params);
      } else {
        result = await VoteDao.schoolAdd(params, isSave: isSave);
      }
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  /// 选择家长或者学生
  _buildSelectContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('投票范围:',
            style: TextStyle(fontSize: 13, color: Colors.black)),
        hiSpace(height: 8),
        Container(
          height: 40,
          child: Row(
            children: [
              const Text('教师',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              HiRadio(
                  title: '全选',
                  enabled: isEnabled,
                  selected: isTeacherAllSelect,
                  onCheckPress: () {
                    if (!isEnabled) return;
                    setState(() {
                      isTeacherAllSelect = !isTeacherAllSelect;
                      allSelect(1);
                    });
                  }),
              hiSpace(width: 10),
              _buildSelectWrap(1)
            ],
          ),
        ),
        hiSpace(height: 10),
        Container(
          height: 40,
          child: Row(
            children: [
              const Text('学生',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              HiRadio(
                  title: '全选',
                  enabled: isEnabled,
                  selected: isFamilyAllSelect,
                  onCheckPress: () {
                    if (!isEnabled) return;
                    setState(() {
                      isFamilyAllSelect = !isFamilyAllSelect;
                      allSelect(2);
                    });
                  }),
              hiSpace(width: 10),
              _buildSelectWrap(2)
            ],
          ),
        )
      ],
    );
  }

  /// type 2:学生 1:教师
  allSelect(int type) async {
    if (type == 1) {
      if (!isTeacherAllSelect) {
        setState(() {
          teacherContacts.removeRange(1, teacherContacts.length);
        });
      } else {
        try {
          EasyLoading.show(status: '加载中...');
          ContactDepartModel result = await ContactDao.getTU(pid: "0");
          setState(() {
            // 选择的人员
            result.deptInfo.forEach((item) {
              var i = ContactSelect(item.id, item.title, true, item.parentId);
              teacherContacts.add(i);
              ListUtils.selecters.add(i);
            });
          });
          EasyLoading.dismiss(animation: false);
        } on HiNetError catch (e) {
          print(e);
          showWarnToast(e.message);
          EasyLoading.dismiss(animation: false);
        }
      }
    }

    if (type == 2) {
      if (!isFamilyAllSelect) {
        setState(() {
          familyContacts.removeRange(1, familyContacts.length);
        });
      } else {
        try {
          EasyLoading.show(status: '加载中...');
          VoteSchoolClassModel result = await VoteDao.classDetail();
          setState(() {
            // 选择的人员
            result.classInfo.forEach((item) {
              familyContacts
                  .add(ContactSelect(item.classId, item.className, true, null));
              selectApproveList.add(ContactFamily(item.classId, "", ""));
              infoApproveList.add(item.classId);
            });
          });
          EasyLoading.dismiss(animation: false);
        } on HiNetError catch (e) {
          print(e);
          showWarnToast(e.message);
          EasyLoading.dismiss(animation: false);
        }
      }
    }
  }

  _buildSelectWrap(int type) {
    List<ContactSelect> items = type == 1 ? teacherContacts : familyContacts;
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.grey[200], width: 1)),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: items[index].id != "-1"
                  ? Chip(
                      label: Text(items[index].name,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87)),
                      onDeleted: () {
                        if (!isEnabled) return;
                        setState(() {
                          ContactSelect item = items[index];
                          items.remove(item);
                          if (type == 1) {
                            teacherContacts.remove(item);
                            ListUtils.selecters.remove(item);
                          } else {
                            familyContacts.remove(item);
                            infoApproveList.removeWhere((element) => element.contains(item.id));
                            selectApproveList
                                .remove(ContactFamily(item.id, "", ""));
                          }
                        });
                      },
                    )
                  : ActionChip(
                      backgroundColor:
                          isEnabled ? Colors.lightBlueAccent : Colors.grey[400],
                      label: Text(items[index].name,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                      onPressed: () {
                        if (!isEnabled) return;
                        unFocus();
                        showContact(type);
                      },
                    ),
            );
          }),
    ));
  }

  void setIsHidden() {
    if (optionsWidget.length >= maxLength) {
      isHiddenAddOption = true;
      return;
    } else {
      isHiddenAddOption = false;
    }
  }
}
