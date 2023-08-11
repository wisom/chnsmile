import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_course_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_detail_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_head_model.dart';
import 'package:chnsmile_flutter/model/class_transfer_item.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/class_transfer_widget.dart';
import 'package:chnsmile_flutter/widget/hi_checkbox.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/star.dart';
import 'package:chnsmile_flutter/widget/time_picker/model/date_mode.dart';
import 'package:chnsmile_flutter/widget/time_picker/model/suffix.dart';
import 'package:chnsmile_flutter/widget/time_picker/pickers.dart';
import 'package:chnsmile_flutter/widget/w_pop/w_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class ClassTransferAddPage extends StatefulWidget {
  final Map params;
  String id;

  ClassTransferAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _ClassTransferAddPageState createState() => _ClassTransferAddPageState();
}

class _ClassTransferAddPageState extends HiState<ClassTransferAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  String cname; // 保修人姓名
  String addDate; // 日期
  String content; // 内容
  String remark; // 备注

  List<OAPeople> approves = []; // 审批人, 通知人
  List<ProcessInfo> defaultApproves = []; // 默认审批人
  List<ProcessInfo> defaultNotices = []; // 默认通知人

  // 课程里面的内容
  String tealAvator;
  String teacherUserId;
  String tealId;
  String tealName;
  String noticeAvator;
  String userId;
  String noticeName;
  String clazzId;
  String clazzName;
  String courseId;
  String courseName;
  CourseNumberList oldClassPlan;
  CourseNumberList newClassPlan;
  String oldDate;
  String newDate;
  bool headerMasterChecked = false; // 班主任确认

  bool isHiddenAddOption = false;
  int maxLength = 5;
  List<Widget> optionsWidget = []; // 调课选项控件
  List<ClassTransferItem> options = []; // 调课选项

  ClassTransferCourseModel courseModel;

  ClassTransferDetailModel model;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    addDate = currentYearMothAndDay();
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

  handleApproves(List<ChangeInfo> approves) {
    for (var item in approves) {
      if ("1" == item.kinds) {
        defaultApproves.add(ProcessInfo(
            avatarImg: item.avatarImg,
            userId: item.approveId,
            approveName: item.approveName));
      } else {
        defaultNotices.add(ProcessInfo(
            avatarImg: item.avatarImg,
            userId: item.approveId,
            approveName: item.approveName));
      }
    }
  }

  handleOption(List<ChangeInfo> approves) {
    for (var item in approves) {
      var item2 = ClassTransferItem(
          approveId: item.approveId,
          kinds: item.kinds,
          clazz: item.clazz,
          clazzName: item.clazzName,
          type: model.status == 0 ? 1 : 2,
          course: item.course,
          courseName: item.courseName,
          status: item.status,
          newDate: item.newDate,
          newNo: item.newNo,
          newNoName: item.newNo,
          oldDate: item.oldDate,
          oldNo: item.oldNo,
          oldNoName: item.oldNo,
          tealId: item.tealId,
          tealName: item.tealName,
          approveName: item.approveName,
          approveRemark: item.approveRemark
      );

      addOption(item2);
    }
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ClassTransferDao.getClassAndCourse();
      setState(() {
        courseModel = result;
      });
      if (isEdit) {
        var result = await ClassTransferDao.detail(widget.id);
        setState(() {
          model = result;
          content = model.reason;
          addDate = model.dDate;
          remark = model.remark;

          handleApproves(model.detailChangeApproveInfoList);
          handleOption(model.detailChangeApproveInfoList);
        });
      }
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: isLoaded ? ListView(
        children: [
          _buildTop(),
          _buildMiddle(context),
          hiSpace(height: 12),
          _buildBottom()
        ],
      ) : Container(),
    );
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  _buildAppBar() {
    var rightTitle = '';
    if (isUnSend) {
      rightTitle = '删除';
    }

    return appBar(isEdit ? '调课详情' : '新建计划', rightTitle: rightTitle, rightButtonClick: () {
      if (rightTitle == '删除') {
        delete();
      }
    });
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ClassTransferDao.delete(model?.id);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  showPlanDialog(int type) async {
    // type = 0 老课程，新课程
    try {
      if (isEmpty(clazzId)) {
        showWarnToast('请选择班级');
        return;
      }
      if (isEmpty(courseId)) {
        showWarnToast('请选择学科');
        return;
      }
      if (type == 0 && isEmpty(oldDate)) {
        showWarnToast('请选择原课程日期');
        return;
      }
      if (type == 1 && isEmpty(newDate)) {
        showWarnToast('请选择新课程日期');
        return;
      }

      if (courseModel.courseNumberList == null || courseModel.courseNumberList.isEmpty) {
        showWarnToast('当前无课程，请联系管理员添加');
        return;
      }
      List<String> items = [];
      courseModel.courseNumberList.forEach((element) {
        items.add(element.value);
      });

      showListDialog(context, title: '请选择课程', list: items,
          onItemClick: (String type1, int index) {
        var item = courseModel.courseNumberList[index];
        setState(() {
          if (type == 0) {
            oldClassPlan = item;
          } else {
            newClassPlan = item;
          }
        });
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
      showWarnToast('当前无课程，请联系管理员');
    }
  }

  showClassDialog() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    if (courseModel == null || courseModel.classInfoList.isEmpty) {
      showWarnToast('获取班级失败，请退出重试');
      return;
    }
    var list = courseModel.classInfoList;
    List<String> items = [];
    list.forEach((element) {
      items.add(element.classGradeName + element.clzz);
    });
    showListDialog(context, title: '请选择班级', list: items,
        onItemClick: (String type, int index) {
      setState(() {
        clazzId = list[index].classId;
        clazzName = list[index].classGradeName + list[index].clzz;
      });
    });
  }

  showCourseDialog() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    if (courseModel == null || courseModel.courseInfoList.isEmpty) {
      showWarnToast('获取学科失败，请退出重试');
      return;
    }
    var list = courseModel.courseInfoList;
    List<String> items = [];
    list.forEach((element) {
      items.add(element.course);
    });
    showListDialog(context, title: '请选择学科', list: items, height: 160,
        onItemClick: (String type, int index) {
      setState(() {
        courseId = list[index].courseId;
        courseName = list[index].course;
      });
    });
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      const Text('表单编号:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                       Text(model != null ? model.formId :'提交生成',
                          style: const TextStyle(fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      const Text('建立日期:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(dateYearMothAndDay(addDate.replaceAll(".000", "")),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  ))
            ],
          ),
          hiSpace(height: 15),
          Container(
            height: 40,
            child: Row(
              children: [
                const Text('计划状态:',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
                hiSpace(width: 5),
                const Text('未发出',
                    style: TextStyle(fontSize: 13, color: Colors.black54))
              ],
            ),
          ),
          hiSpace(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Star(),
                  const Text('调课原因:',
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
              hiSpace(height: 8),
              NormalMultiInput(
                  hint: '请输入调课原因',
                  minLines: 5,
                  maxLines: 5,
                  initialValue: model != null ? model.reason : '',
                  focusNode: focusNode1,
                  onChanged: (text) {
                    content = text;
                  })
            ],
          ),
          hiSpace(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('备注:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              hiSpace(height: 8),
              NormalMultiInput(
                  hint: '请输入备注',
                  minLines: 5,
                  maxLines: 5,
                  initialValue: model != null ? model.remark : '',
                  focusNode: focusNode2,
                  onChanged: (text) {
                    remark = text;
                  })
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('教师:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择教师",
                  text: tealName ?? "",
                  onSelectPress: showContact,
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('班级:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择班级",
                  text: clazzName ?? "",
                  onSelectPress: showClassDialog,
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('学科:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择学科",
                  text: courseName ?? "",
                  onSelectPress: showCourseDialog,
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('原课程:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        timeClick(1);
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[200], width: 1)),
                        child: Text(oldDate ?? '请选择日期',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54)),
                      ))),
              Expanded(
                  child: NormalSelect(
                hint: "请选择课程",
                text: oldClassPlan?.value ?? "",
                onSelectPress: () {
                  showPlanDialog(0);
                },
              ))
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('调   至:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        timeClick(2);
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[200], width: 1)),
                        child: Text(newDate ?? '请选择日期',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54)),
                      ))),
              Expanded(
                  child: NormalSelect(
                hint: "请选择课程",
                text: newClassPlan?.value ?? "",
                onSelectPress: () {
                  showPlanDialog(1);
                },
              ))
            ],
          ),
          hiSpace(height: 15),
          !isHiddenAddOption
              ? Row(
                  children: [
                    Expanded(
                        child: HiCheckBox(
                            title: '班主任需确认',
                            selected: headerMasterChecked,
                            onCheckPress: () {
                              setState(() {
                                headerMasterChecked = !headerMasterChecked;
                              });
                            })),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: buildSmallButton('添加', primary, onClick: add),
                    )
                  ],
                )
              : Container(),
          boxLine(context)
        ],
      ),
    );
  }

  timeClick(int type) {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day}';
        setState(() {
          if (type == 1) {
            oldDate = time;
          } else {
            newDate = time;
          }
        });
      },
    );
  }

  _buildOptions(int option) {
    var item = options[option];
    return ClassTransferWidget(
      item: item,
      delete: () {
        setState(() {
          if (defaultApproves.isNotEmpty) {
            defaultApproves.removeWhere((value) {
              return value.userId == item.approveId;
            });
          }

          if (defaultNotices.isNotEmpty) {
            defaultNotices.removeWhere((value) {
              return value.userId == item.approveId;
            });
          }
          options.remove(item);
          ClassTransferWidget findWidget;
          for (ClassTransferWidget widget in optionsWidget) {
            if (widget.item == item) {
              findWidget = widget;
            }
          }
          if (findWidget != null) {
            optionsWidget.remove(findWidget);
          }
        });
      },
    );
  }

  _buildMiddle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        children: optionsWidget.map((e) => e).toList(),
      ),
    );
  }

  /// 批阅信息
  _buildBottom() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 50),
      color: Colors.white,
      child: Column(
        children: [
          // _buildBottomTips(),
          // hiSpace(height: 10),
          // _buttonBottomContent(),
          OASubmitButton(
              onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
        ],
      ),
    );
  }

  add() async {
    // 添加
    if (isEmpty(tealId) ||
        isEmpty(clazzId) ||
        isEmpty(courseId) ||
        isEmpty(oldDate) ||
        oldClassPlan == null ||
        isEmpty(newDate) ||
        newClassPlan == null) {
      showWarnToast('调课信息不能为空');
      return;
    }

    defaultApproves.clear();
    defaultNotices.clear();

    try {
      EasyLoading.show(status: '加载中...');
      ClassHeadModel result = await ClassTransferDao.classHead(clazzId);
      if (result == null || result.userId == null) {
        EasyLoading.dismiss(animation: false);
        showWarnToast('您所选班级的班主任为空，请联系管理员');
        return;
      }
      var p1 = ProcessInfo(
          avatarImg: tealAvator, userId: teacherUserId, id: tealId, approveName: tealName);
      if (isDefault && !defaultApproves.contains(p1)) {
        defaultApproves.add(p1);
      }
      setState(() {
        noticeAvator = result.avatarImg;
        userId = result.userId; // user id
        tealId = result.id; // teacher id
        noticeName = result.userName;
        if (tealId != null) {
          if (!headerMasterChecked) {
            // 设置人员
            var p = ProcessInfo(
                avatarImg: noticeAvator,
                userId: userId,
                id:tealId,
                isHeadMaster: true,
                approveName: noticeName);
            // if (!defaultNotices.contains(p)) {
              defaultNotices.add(p);
            // }
          } else {
            var p = ProcessInfo(
                avatarImg: noticeAvator,
                userId: userId,
                id:tealId,
                isHeadMaster: true,
                approveName: noticeName);
            // if (!defaultApproves.contains(p)) {
              defaultApproves.add(p);
            // }
          }
        }
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }


    for (var p in defaultApproves) {
      var item = ClassTransferItem(
          clazz: clazzId,
          clazzName: clazzName,
          course: courseId,
          kinds: "1",
          type: 0,
          courseName: courseName,
          newDate: newDate,
          newNo: newClassPlan?.code,
          newNoName: newClassPlan?.value,
          oldDate: oldDate,
          oldNo: oldClassPlan?.code,
          oldNoName: oldClassPlan?.value,
          tealId: p.id,
          tealName: p.approveName,
          approveName: p.approveName,
          approveId: p.userId,
          approveRemark: p.isHeadMaster ? '班主任确认' : ''
      );

      // item.approveId = p.userId;
      // item.approveRemark = p.isHeadMaster ? '班主任确认' : '';
      addOption(item);
    }

    for (var p in defaultNotices) {
      var item = ClassTransferItem(
          clazz: clazzId,
          clazzName: clazzName,
          course: courseId,
          courseName: courseName,
          newDate: newDate,
          kinds: "2",
          type: 0,
          approveName: p.approveName,
          newNo: newClassPlan?.code,
          newNoName: newClassPlan?.value,
          oldDate: oldDate,
          oldNo: oldClassPlan?.code,
          oldNoName: oldClassPlan?.value,
          tealId: p.id,
          tealName: p.approveName
      );
      item.approveId = p.userId;
      item.approveRemark = p.isHeadMaster ? '通知班主任' : '';
      addOption(item);
    }

    setState(() {
      //清空上次的
      tealId = "";
      userId = "";
      clazzId = "";
      clazzName = "";
      courseId = "";
      courseName = "";
      newDate = "";
      newClassPlan = null;
      oldDate = "";
      oldClassPlan = null;
      tealId = "";
      tealName = "";
    });
  }

  addOption(var item) {
    setState(() {
      options.add(item);

      optionsWidget.add(_buildOptions(optionsWidget.length));
      if (optionsWidget.length >= maxLength) {
        isHiddenAddOption = true;
        return;
      } else {
        isHiddenAddOption = false;
      }
    });
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (isEmpty(cname)) {
      showWarnToast("调课人不能为空");
      return;
    }

    if (isEmpty(content)) {
      showWarnToast("请输入内容");
      return;
    }

    var list = [];
    for (var option in options) {
      var json = option.toJson();
      list.add(json);
    }

    if (list.isEmpty) {
      showWarnToast("请添加至少一个调课信息");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['id'] = model != null ? model.id : '0';
      params['formId'] = model != null ? model.formId : '0';
      params['cname'] = cname;
      params['dDate'] = addDate;
      params['reason'] = content;
      params['remark'] = remark;
      params['status'] = 0;
      params['changeApproveInfoList'] = list;

      var result = await ClassTransferDao.submit(params, isSave: isSave);
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop({"success": true});
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildBottomTips() {
    return Row(
      children: const [
        Expanded(
            child: Text('批阅信息',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)))
      ],
    );
  }

  /// 是否是默认的批阅信息
  bool get isDefault {
    return true;
  }

  _buttonBottomContent() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
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
                children: [
                  _buildApproveTips(index),
                  hiSpace(height: 10),
                  _buildApproveList(index),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildApproveTips(int index) {
    if (index == 0) {
      return Row(
        children: const [
          Expanded(
              child: Text('审批人',
                  style: TextStyle(fontSize: 13, color: Colors.grey))),
        ],
      );
    } else {
      return const Text('通知人',
          style: TextStyle(fontSize: 13, color: Colors.grey));
    }
  }

  _buildApproveList(int index) {
    List<ProcessInfo> lists;
    if (isDefault) {
      // 默认
      lists = index == 0 ? defaultApproves : defaultNotices;
    }

    if (lists == null) {
      return Container();
    }

    return Row(
      children: lists.asMap().entries.map((entry) {
        int rowIndex = entry.key; // 里面的列表
        ProcessInfo processInfo = entry.value;
        return lists.length - 1 == rowIndex
            ? _buildOAPeople(processInfo, index)
            : _buildMagio(lists, processInfo, index, rowIndex);
        // return lists.length == 1 ? _buildOAPeople(processInfo) : _buildMagio(lists, processInfo, index, rowIndex);
      }).toList(),
    );
  }

  Widget _buildMagio(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    List<ProcessInfo> listsTemp = List.from(lists);
    double menuWidth = 100;
    if (listsTemp.length == 1) {
      // 只有1个元素
      menuWidth = 60;
    } else if (listsTemp.length == 2) {
      // 只有两个元素
      menuWidth = 100;
    } else {
      // 多个元素
      menuWidth = 140;
    }
    return WPopupMenu(
        backgroundColor: primary,
        menuWidth: menuWidth,
        menuHeight: 36,
        pressType: PressType.longPress,
        child: _buildOAPeople(processInfo, index));
  }

  // index=0:第一个 index=1: 第二个
  Widget _buildOAPeople(ProcessInfo processInfo, int index) {
    return Row(
      children: [
        Column(
          children: [
            _buildIcon(processInfo, index),
            hiSpace(height: 4),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(processInfo.approveName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black)),
            )
          ],
        ),
        hiSpace(width: 20),
      ],
    );
  }

  _buildIcon(ProcessInfo processInfo, int index) {
    double width = 40;
    if (processInfo.userId == "-1") {
      return InkWell(
          onTap: () {
            showContact();
          },
          child: Image(
              image: AssetImage(processInfo.avatarImg),
              width: width,
              height: width));
    } else {
      return showAvatorIcon(
          avatarImg: processInfo.avatarImg, name: processInfo.approveName);
    }
  }

  // 添加联系人
  showContact() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': "class_transfer_add_page",
      'isShowDepCheck': false
    }).then((value) {
      print("list: ${ListUtils.selecters}");

      List<ProcessInfo> lists = [];
      // 审批人
      ListUtils.selecters.forEach((item) {
        lists.add(ProcessInfo(
            avatarImg: item.avatorUrl,
            userId: item.id,
            approveName: item.name));
        setState(() {
          tealName = item.name;
          teacherUserId = item.id;
          tealId = item.teacherId;
          tealAvator = item.avatorUrl;
        });
      });
    });
  }
}
