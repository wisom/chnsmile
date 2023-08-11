import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
import 'package:chnsmile_flutter/http/dao/vacation_dao.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
import 'package:chnsmile_flutter/model/vacation_calculation_model.dart';
import 'package:chnsmile_flutter/model/vacation_detail_model.dart';
import 'package:chnsmile_flutter/model/vacation_init_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
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

class VacationAddPage extends StatefulWidget {
  final Map params;
  String id;

  VacationAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _VacationAddPageState createState() => _VacationAddPageState();
}

class _VacationAddPageState extends HiState<VacationAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  int reviewType = 1;
  String cname; // 姓名
  String applyId; // id
  String addDate; // 日期
  KindsInfo applyKinds; // 申请类型
  KindsInfo leaveKinds; // 请假类型
  String leaveName; // 请假人姓名
  String leaveId; // 请假人ID
  String startTime; // 开始日期
  String endTime; // 结束日期
  String leaveHour; // 自动填写时间
  String leaveReason; // 请假事由
  String remark; // 备注
  List<OAPeople> approves = []; // 审批人, 通知人
  bool leaveEnable = false;
  int vacationType = 1;

  List<ProcessInfo> defaultApproves = []; // 默认审批人
  List<ProcessInfo> defaultNotices = []; // 默认通知人
  List<ProcessInfo> customerApproves = []; // 自定义审批人
  List<ProcessInfo> customerNotices = []; // 自定义通知人

  List<KindsInfo> leaveKindsInfo; // 请假类型
  List<KindsInfo> applyKindsInfo; // 申请类型

  VacationDetailModel model;
  bool isLoaded = false;

  final ProcessInfo iconInfo =
      ProcessInfo(avatarImg: "images/contact_add_button.png", userId: "-1");

  @override
  void initState() {
    super.initState();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    applyId = HiCache.getInstance().get(HiConstant.spUserId);
    addDate = currentYearMothAndDay();
    leaveName = cname;
    leaveId = applyId;
    loadDefaultData();
  }

  bool get isEdit {
    return widget.id != null;
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  calculation() async {
    try {
      if (isEmpty(startTime)) {
        showWarnToast('请选择开始时间');
        return;
      }
      if (isEmpty(endTime)) {
        showWarnToast('请选择结束时间');
        return;
      }
      EasyLoading.show(status: '加载中...');
      VacationCalculationModel result =
          await VacationDao.calculation(startTime, endTime);
      setState(() {
        leaveHour = result.hours.toString();
      });

      if (!isEdit) {
        loadDefault2Data(leaveHour);
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  handleApproves(List<ApproveInfoList> approves) {
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

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      VacationInitModel result = await VacationDao.init();
      vacationType = await VacationDao.getType();
      print("type: $vacationType");
      if (vacationType == null || vacationType == 0) {
        showWarnToast('系统的上班时间设置须选择模式');
        BoostNavigator.instance.pop({"success": true});
        return;
      }
      defaultApproves ??= [];
      defaultNotices ??= [];
      // defaultApproves.insert(defaultApproves.length, _getAddIcon());
      // defaultNotices.insert(defaultNotices.length, _getAddIcon());
      // customerApproves.add(_getAddIcon());
      // customerNotices.add(_getAddIcon());
      if (isEdit) {
        var result = await VacationDao.detail(widget.id);
        setState(() {
          model = result;
          applyId = model.applyId;
          leaveId = model.leaveId;
          applyKinds =
              KindsInfo(value: model.applyKinds, code: model.applyKinds);
          leaveKinds = KindsInfo(value: model.kinds, code: model.kinds);
          startTime = model.dateStart;
          endTime = model.dateEnd;
          leaveReason = model.reason;
          leaveHour = model.hours.toString();
          remark = model.remark;
          handleApproves(model.approveInfoList);
        });
        isLoaded = true;
      }

      setState(() {
        defaultApproves.insert(defaultApproves.length, _getAddIcon());
        customerApproves.add(_getAddIcon());
        defaultNotices.insert(defaultNotices.length, _getAddIcon());
        customerNotices.add(_getAddIcon());
        // 请假类型， 申请类型
        leaveKindsInfo = result?.leaveKindsInfo;
        applyKindsInfo = result?.applyKindsInfo;
      });
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    }
  }

  loadDefault2Data(String hour) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DefaultApplyDao.getVacation(hour);
      setState(() {
        defaultApproves = result.defaultApprove?.processMxList;
        defaultApproves.insert(defaultApproves.length, _getAddIcon());
        defaultNotices = result.defaultNotice?.processMxList;
        defaultNotices.insert(defaultNotices.length, _getAddIcon());
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: isLoaded
          ? ListView(
              children: [_buildTop(), hiSpace(height: 12), _buildBottom()],
            )
          : Container(),
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

    return appBar(isEdit ? '请假审批详情' : '新建请假', rightTitle: rightTitle, rightButtonClick: () {
      if (rightTitle == '删除') {
        delete();
      }
    });
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await VacationDao.delete(model.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  showCategoryDialog(String type) {
    unFocus();
    List<KindsInfo> list = type == "1" ? applyKindsInfo : leaveKindsInfo;
    List<String> items = [];
    list.forEach((element) {
      items.add(element.value);
    });
    showListDialog(context, title: '请选择种类', list: items,
        onItemClick: (String s, int index) {
      setState(() {
        if (type == "1") {
          applyKinds = applyKindsInfo[index];
          print("applyKinds: ${applyKinds.value}");
          leaveEnable = applyKinds.value == "代理请假";
        } else {
          leaveKinds = leaveKindsInfo[index];
          print("leaveKinds: ${leaveKinds.value}");
        }
      });
    });
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      const Text('表单编号:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(model != null ? model.formId : '提交生成',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      const Text('申请日期:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(addDate ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  ))
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      const Text('申请人:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(cname ?? '',
                          style: const TextStyle(fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: const [
                      Text('状态:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text('未发出',
                          style: TextStyle(fontSize: 13, color: Colors.black54))
                    ],
                  ))
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('申请类型:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择申请类型",
                  text: applyKinds != null
                      ? applyKinds.value
                      : model != null
                          ? model.applyKinds
                          : "",
                  onSelectPress: () {
                    showCategoryDialog("1");
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('请  假  人:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择请假人员",
                  text: model != null ? model.leaveName : leaveName ?? "",
                  isEnable: leaveEnable,
                  onSelectPress: () {
                    showContact(2);
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('请假时间:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              boxLine(context),
              hiSpace(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      _buildTime(1),
                      hiSpace(height: 10),
                      _buildTime(2),
                    ],
                  )),
                  isTypeEdit() ? InkWell(
                      onTap: isTypeEdit() ? calculation : null,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 50,
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isTypeEdit() ? primary : Colors.grey[200],
                        ),
                        child: const Text('计算',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      )) : Container()
                ],
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('请假小时:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              isTypeEdit()
                  ? Expanded(
                      child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[200], width: 1)),
                          child: Text(
                              model != null
                                  ? model.hours.toString()
                                  : leaveHour ?? "计算自动填写",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54))),
                    )
                  : Expanded(
                      child: NormalInput(
                        hint: "请输入请假时长",
                        focusNode: focusNode3,
                        initialValue:
                            model != null ? model.hours.toString() : '',
                        onChanged: (text) {
                          leaveHour = text;
                          loadDefault2Data(leaveHour);
                        },
                      ),
                    )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('请假类型:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择请假类型",
                  text: leaveKinds != null
                      ? leaveKinds.value
                      : model != null
                          ? model.kinds
                          : "",
                  onSelectPress: () {
                    showCategoryDialog("2");
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Star(),
                  const Text('请假事由:',
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
              hiSpace(height: 8),
              NormalMultiInput(
                  hint: '请输入请假事由',
                  focusNode: focusNode1,
                  initialValue: model != null ? model.reason : '',
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (text) {
                    leaveReason = text;
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
                  focusNode: focusNode2,
                  initialValue: model != null ? model.remark : '',
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (text) {
                    remark = text;
                  })
            ],
          ),
        ],
      ),
    );
  }

  bool isTypeEdit() {
    return vacationType == 1;
  }

  unFocus() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    focusNode3.unfocus();
  }

  _buildTime(int type) {
    return Row(children: [
      Star(),
      type == 1
          ? const Text('开始时间',
              style: TextStyle(fontSize: 13, color: Colors.black))
          : const Text('结束时间',
              style: TextStyle(fontSize: 13, color: Colors.black)),
      Expanded(
          child: InkWell(
              onTap: () {
                timeClick(type);
              },
              child: Container(
                height: 40,
                width: 140,
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey[200], width: 1)),
                child: Text(
                    type == 1
                        ? model != null && model.dateStart != null
                            ? model.dateStart
                            : startTime ?? '请选择日期'
                        : model != null && model.dateEnd != null
                            ? model.dateEnd
                            : endTime ?? '请选择日期',
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ))),
    ]);
  }

  timeClick(int type) {
    FocusManager.instance.primaryFocus?.unfocus();
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMDHM,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day} ${p.hour < 10 ? '0${p.hour}': p.hour}:${p.minute < 10 ? '0${p.minute}': p.minute}';
        setState(() {
          if (type == 1) {
            startTime = '$time:00';
          } else {
            endTime = '$time:00';
          }
        });
      },
    );
  }

  /// 批阅信息
  _buildBottom() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 50),
      color: Colors.white,
      child: Column(
        children: [
          _buildBottomTips(),
          _buttonBottomContent(),
          OASubmitButton(
              onSavePressed: onSavePressed, onSubmitPressed: onSubmitPressed)
        ],
      ),
    );
  }

  List getApproves() {
    List<OAPeople> approves = [];
    if (isDefault) {
      for (var processInfo in defaultApproves) {
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(kinds: "1", approveId: processInfo.userId));
      }

      for (var processInfo in defaultNotices) {
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(kinds: "2", approveId: processInfo.userId));
      }
    } else {
      for (var processInfo in customerApproves) {
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(kinds: "1", approveId: processInfo.userId));
      }

      for (var processInfo in customerNotices) {
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(kinds: "2", approveId: processInfo.userId));
      }
    }

    var list = [];
    for (OAPeople oaPeople in approves) {
      var json = oaPeople.toJson2();
      list.add(json);
    }
    return list;
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (applyKinds == null) {
      showWarnToast("请选择申请类型");
      return;
    }

    if (isEmpty(leaveName)) {
      showWarnToast("请输入姓名");
      return;
    }

    if (isTypeEdit() && isEmpty(startTime)) {
      showWarnToast("请选择开始时间");
      return;
    }

    if (isTypeEdit() && isEmpty(endTime)) {
      showWarnToast("请选择结束时间");
      return;
    }

    if (isEmpty(leaveHour)) {
      showWarnToast("请点击计算按钮计算请假小时数");
      return;
    }

    if (leaveKinds == null) {
      showWarnToast("请选择请假类型");
      return;
    }

    if (isEmpty(leaveReason)) {
      showWarnToast("请填写请假事由");
      return;
    }

    if(getApproves().isEmpty) {
      showWarnToast("请选择审批人员");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = model != null ? model.formId : '';
      params['dateEnd'] = endTime;
      params['dateStart'] = startTime;
      params['hours'] = leaveHour;
      params['kinds'] = leaveKinds.value;
      params['applyId'] = applyId;
      params['leaveId'] = leaveId;
      params['reason'] = leaveReason;
      params['remark'] = remark;
      params['status'] = 0;
      params['applyKinds'] = applyKinds.value;
      params['approveInfoList'] = getApproves();

      var result = await VacationDao.submit(params, isSave: isSave);
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
      children: [
        const Expanded(
            child: Text('批阅信息',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        Row(
          children: [
            const Text('类型:',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  value: 1,
                  groupValue: reviewType,
                  activeColor: Colors.blue,
                  onChanged: (v) {
                    setState(() {
                      reviewType = v;
                    });
                  },
                ),
                const Text("默认",
                    style: TextStyle(fontSize: 13, color: Colors.black87))
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  value: 2,
                  groupValue: reviewType,
                  onChanged: (v) {
                    setState(() {
                      reviewType = v;
                    });
                  },
                ),
                const Text("自定义",
                    style: TextStyle(fontSize: 13, color: Colors.black87))
              ],
            ),
          ],
        )
      ],
    );
  }

  /// 是否是默认的批阅信息
  bool get isDefault {
    return reviewType == 1;
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
        children: [
          Expanded(
              child: Row(
            children: [
              const Text('审批人',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(left: 5),
                decoration: bottomBoxShadow1(context),
                child: const Text('依此审批',
                    style: TextStyle(fontSize: 12, color: primary)),
              ),
              const Text(' *',
                  style: TextStyle(fontSize: 13, color: Colors.red)),
            ],
          )),
          const Text('按图标调整次序',
              style: TextStyle(fontSize: 12, color: Colors.grey))
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
      print("defaultApproves: $defaultApproves");
      // 默认
      lists = index == 0 ? defaultApproves : defaultNotices;
    } else {
      // 自定义
      print("customerApproves: $customerApproves");
      lists = index == 0 ? customerApproves : customerNotices;
    }

    if (lists == null) {
      return Container();
    }

    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: lists.asMap().entries.map((entry) {
          int rowIndex = entry.key; // 里面的列表
          ProcessInfo processInfo = entry.value;
          return lists.length - 1 == rowIndex
              ? _buildOAPeople(processInfo, index)
              : _buildMagio(lists, processInfo, index, rowIndex);
        }).toList());
  }

  Widget _buildMagio(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    List<ProcessInfo> listsTemp = List.from(lists);
    listsTemp.remove(iconInfo);
    double menuWidth = 100;
    if (listsTemp.length == 1) { // 只有1个元素
      menuWidth = 60;
    } else if (listsTemp.length == 2) { // 只有两个元素
      menuWidth = 100;
    } else { // 多个元素
      menuWidth = 140;
    }
    return WPopupMenu(
        onValueChanged: (int value) {
          _onValueChangedClick(listsTemp, index,  rowIndex, value, processInfo);
        },
        backgroundColor: primary,
        menuWidth: menuWidth,
        menuHeight: 36,
        actions: _buildActions(listsTemp, rowIndex),
        pressType: PressType.longPress,
        child: _buildOAPeople(processInfo, index));
  }

  // index=0:第一个 index=1: 第二个
  Widget _buildOAPeople(ProcessInfo processInfo, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildIcon(processInfo, index),
          hiSpace(height: 2),
          Container(
            width: 46,
            alignment: Alignment.center,
            child: Text(processInfo.approveName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          )
        ],
      ),
    );
  }

  /// 前移
  _before(
      List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    setState(() {
      if (isDefault) {
        index == 0
            ? ListUtils.swapList(defaultApproves, rowIndex - 1, rowIndex)
            : ListUtils.swapList(defaultNotices, rowIndex - 1, rowIndex);
      } else {
        index == 0
            ? ListUtils.swapList(customerApproves, rowIndex - 1, rowIndex)
            : ListUtils.swapList(customerNotices, rowIndex - 1, rowIndex);
      }
    });
  }

  /// 后移
  _after(
      List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    // 后移
    setState(() {
      if (isDefault) {
        index == 0
            ? ListUtils.swapList(defaultApproves, rowIndex, rowIndex + 1)
            : ListUtils.swapList(defaultNotices, rowIndex, rowIndex + 1);
      } else {
        index == 0
            ? ListUtils.swapList(customerApproves, rowIndex, rowIndex + 1)
            : ListUtils.swapList(customerNotices, rowIndex, rowIndex + 1);
      }
    });
  }

  /// 删除
  _delete(
      List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    // 删除
    setState(() {
      if (isDefault) {
        index == 0
            ? defaultApproves.remove(processInfo)
            : defaultNotices.remove(processInfo);
      } else {
        index == 0
            ? customerApproves.remove(processInfo)
            : customerNotices.remove(processInfo);
      }
    });
  }

  /**
   * 0 -- 0 --- 2 -- 0
   * 0 -- 1 --- 3 -- 0
   * index : 第一行，第二行  0，1之中选择
   * rowIndex:  里面的列表行数
   */
  _onValueChangedClick(
      List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    print("value: $value -- $index --- ${lists.length} -- ${rowIndex}");
    if (lists.length == 1) {
      // 只有1个元素
      _delete(lists, index, rowIndex, value, processInfo);
    } else if (lists.length == 2) {
      // 只有两个元素
      if (rowIndex == 0) {
        if (value == 0) {
          _after(lists, index, rowIndex, value, processInfo);
        } else {
          _delete(lists, index, rowIndex, value, processInfo);
        }
      } else {
        if (value == 0) {
          _before(lists, index, rowIndex, value, processInfo);
        } else {
          _delete(lists, index, rowIndex, value, processInfo);
        }
      }
    } else {
      // 多个元素，最后一个元素只有两个，前移或者删除
      // '前移', '后移', '删除'
      if (rowIndex == lists.length - 1) {
        if (value == 0) {
          _before(lists, index, rowIndex, value, processInfo);
        } else {
          _delete(lists, index, rowIndex, value, processInfo);
        }
      } else if (rowIndex == 0) {
        if (value == 0) {
          _after(lists, index, rowIndex, value, processInfo);
        } else {
          _delete(lists, index, rowIndex, value, processInfo);
        }
      } else {
        if (value == 0) {
          _before(lists, index, rowIndex, value, processInfo);
        } else if (value == 1) {
          _after(lists, index, rowIndex, value, processInfo);
        } else {
          _delete(lists, index, rowIndex, value, processInfo);
        }
      }
    }
  }

  _buildActions(List lists, int index) {
    if (lists.length == 1) {
      // 只有1个元素
      return ['删除'];
    } else if (lists.length == 2) {
      // 只有两个元素
      if (index == 0) {
        return ['后移', '删除'];
      } else {
        return ['前移', '删除'];
      }
    } else {
      // 多个元素
      if (index == 0) {
        return ['后移', '删除'];
      } else if (index == lists.length - 1) {
        return ['前移', '删除'];
      } else {
        return ['前移', '后移', '删除'];
      }
    }
  }

  _getAddIcon() {
    return iconInfo;
  }

  _buildIcon(ProcessInfo processInfo, int index) {
    double width = 40;
    if (processInfo.userId == "-1") {
      return InkWell(
          onTap: () {
            showContact(index);
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
  showContact(int index) {
    unFocus();
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': 'vacation_add_page',
      'isShowDepCheck': false
    }).then((value) {
      print("list: ${ListUtils.selecters}");
      if (ListUtils.selecters.isEmpty) {
        return;
      }

      setState(() {
        if (index == 2) {
          ContactSelect item = ListUtils.selecters[0];
          leaveName = item.name;
          leaveId = item.id;
        }

        ListUtils.selecters.forEach((item) {
          var p = ProcessInfo(
              avatarImg: item.avatorUrl,
              userId: item.id,
              approveName: item.name);

          if (isDefault) {
            if (index == 0) {
              if (!defaultApproves.contains(p)) {
                defaultApproves.insert(defaultApproves.length - 1, p);
              }
            } else {
              // 通知人
              if (!defaultNotices.contains(p)) {
                defaultNotices.insert(defaultNotices.length - 1, p);
              }
            }
          } else {
            if (index == 0) {
              if (!customerApproves.contains(p)) {
                customerApproves.insert(customerApproves.length - 1, p);
              }
            } else {
              // 通知人
              if (!customerNotices.contains(p)) {
                customerNotices.insert(customerNotices.length - 1, p);
              }
            }
          }
        });
      });
    });
  }
}
