import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
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
import 'package:chnsmile_flutter/widget/select_attach.dart';
import 'package:chnsmile_flutter/widget/star.dart';
import 'package:chnsmile_flutter/widget/w_pop/w_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class RepairAddPage extends StatefulWidget {
  final Map params;
  String id;

  RepairAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _RepairAddPageState createState() => _RepairAddPageState();
}

class _RepairAddPageState extends HiState<RepairAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();

  bool buttonEnable = false;
  int reviewType = 1;
  String cname; // 保修人姓名
  String userId; // 保修人id
  String repairDate; // 报修日期
  String repairStatus; // 报修状态
  String deptName; // 报修部门
  String deptId; // 报修部门
  String repairKinds; // 报修种类
  String repairMer; // 报修物品
  String tel; // 联系方式
  String email; // email
  String repairAddress; // 报修地址
  String content; // 报修内容
  List<OAPeople> approves = []; // 审批人, 通知人
  List<SysOrg> sysorgs = [];

  List<ProcessInfo> defaultApproves; // 默认审批人
  List<ProcessInfo> defaultNotices; // 默认通知人
  List<ProcessInfo> customerApproves = []; // 自定义审批人
  List<ProcessInfo> customerNotices = []; // 自定义通知人
  List<LocalFile> files = []; // 选择文件数量

  final ProcessInfo iconInfo = ProcessInfo(avatarImg: "images/contact_add_button.png", userId: "-1");

  RepairDetailModel model;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    userId = HiCache.getInstance().get(HiConstant.spUserId);
    repairDate = currentYearMothAndDay();
    loadDefaultData();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    super.dispose();
  }

  unFocus() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    focusNode3.unfocus();
    focusNode4.unfocus();
    focusNode5.unfocus();
  }

  bool get isEdit {
    return widget.id != null;
  }

  handleApproves(List<SchoolOaRepairApproveList> approves) {
    for (var item in approves) {
      if ("1" == item.kinds) {
        defaultApproves.add(ProcessInfo(
            avatarImg: item.approveImg,
            userId: item.approveId,
            approveName: item.approveName));
      } else {
        defaultNotices.add(ProcessInfo(
            avatarImg: item.approveImg,
            userId: item.approveId,
            approveName: item.approveName));
      }
    }
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DefaultApplyDao.get();
      defaultApproves ??= [];
      defaultNotices ??= [];
      if (isEdit) {
        var result1 = await RepairDao.detail(widget.id);
        setState(() {
          model = result1;
          var repair = model?.schoolOaRepair;
          deptId = repair.deptId;
          deptName = repair.deptName;
          repairKinds = repair.repairKinds;
          repairMer = repair.repairMer;
          tel = repair.tel;
          email = repair.email;
          repairAddress = repair.repairAddress;
          content = repair.content;
          // reviewType = repair.type;

          handleApproves(model.schoolOaRepairApproveList);
        });
        isLoaded = true;
      }
      setState(() {
        if (!isEdit) {
          defaultApproves = result != null ? result.defaultApprove.processMxList : [];
        }
        defaultApproves.add(_getAddIcon());

        customerApproves.add(_getAddIcon());

        if (!isEdit) {
          defaultNotices = result != null ? result.defaultNotice.processMxList : [];
        }
        defaultNotices.add(_getAddIcon());

        customerNotices.add(_getAddIcon());
      });
      SysOrgModel rs = await RepairDao.getSysOrg();
      setState(() {
        if (rs == null || rs.list.isEmpty) {
          showWarnToast("部门数据为空，请联系管理员添加");
        }
        sysorgs = rs.list;
      });
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      isLoaded = true;
      print(e);
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
          hiSpace(height: 12),
          _buildAttach(),
          hiSpace(height: 12),
          _buildBottom()
        ],
      ) : Container(),
    );
  }

  /// 未发出状态
  bool get isUnSend {
    if (model?.schoolOaRepair == null) {
      return false;
    }
    return model?.schoolOaRepair?.status == 0;
  }

  _buildAppBar() {
    var rightTitle = '';
    if (isUnSend) {
      rightTitle = '删除';
    }

    return appBar(isEdit ? '报修审批详情' : '报修申请', rightTitle: rightTitle, rightButtonClick: () {
      if (rightTitle == '删除') {
        delete();
      }
    });
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await RepairDao.delete(widget.id);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  showDepartDialog() {
    // unFocus();
    FocusManager.instance.primaryFocus?.unfocus();
    List<String> list = [];
    for (var item in sysorgs) {
      list.add(item.name);
    }

    print("list:$list");
    showListDialog(context, title: '请选择报修部门', list: list,
        onItemClick: (String type, int index) {
          setState(() {
            SysOrg item = sysorgs[index];
            deptName = item.name;
            if (model != null && model.schoolOaRepair != null) {
              model.schoolOaRepair.deptName = deptName;
            }
            deptId = item.id;
          });
        });
  }

  showCategoryDialog() {
    // unFocus();
    FocusManager.instance.primaryFocus?.unfocus();
    List<String> list = ['一般报修申请', '特殊报修申请'];
    showListDialog(context, title: '请选择报修种类', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        if (model != null && model.schoolOaRepair != null) {
          model.schoolOaRepair.repairKinds = type;
        }
        repairKinds = type;
      });
    });
  }

  showStatusDialog() {
    List<String> list = ['未发出', '已备案', '审批中', '已拒绝'];
    showListDialog(context, title: '请选择报修状态', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        repairStatus = type;
      });
    });
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
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
                       Text(model != null && model.schoolOaRepair != null ? model.schoolOaRepair.formId : '提交后生成',
                          style: const TextStyle(fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      const Text('报修日期:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(repairDate ?? '',
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
                  flex: 5,
                  child: Row(
                    children: [
                      const Text('报  修  人:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      hiSpace(width: 5),
                      Text(cname,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      const Text('报修状态:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      hiSpace(width: 5),
                      Text('未发出',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  ))
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('报修部门:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择报修部门",
                  text: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.deptName : deptName ?? "",
                  onSelectPress: showDepartDialog,
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('报修种类:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalSelect(
                  hint: "请选择报修种类",
                  text: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.repairKinds : repairKinds ?? "",
                  onSelectPress: showCategoryDialog,
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('报修物品:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入报修物品",
                  initialValue: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.repairMer : '',
                  // focusNode: focusNode1,
                  onChanged: (text) {
                    repairMer = text;
                    checkInput();
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('联系方式:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入联系方式",
                  initialValue: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.tel : '',
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    tel = text;
                    checkInput();
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              const Text(' E-MAIL:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入邮箱地址",
                  focusNode: focusNode3,
                  initialValue: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.email : '',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    email = text;
                    checkInput();
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('报修地址:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入报修地址",
                  focusNode: focusNode4,
                  initialValue: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.repairAddress : '',
                  onChanged: (text) {
                    repairAddress = text;
                    checkInput();
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
                  const Text('故障描述:',
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
              hiSpace(height: 8),
              NormalMultiInput(
                  hint: '请输入故障描述',
                  focusNode: focusNode5,
                  initialValue: model != null && model.schoolOaRepair != null ? model.schoolOaRepair.content : '',
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (text) {
                    content = text;
                  })
            ],
          ),
        ],
      ),
    );
  }

  /// 添加附件
  _buildAttach() {
    // unFocus();
    return SelectAttach(attachs: model?.schoolOaRepairEnclosureList, itemsCallBack: (List<LocalFile> items) {
      print("items: ${items}");
      files = items ?? [];
    });
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

  checkInput() {
    bool enable;

    if (isNotEmpty(cname) &&
        isNotEmpty(repairDate) &&
        isNotEmpty(deptName) &&
        isNotEmpty(repairKinds) &&
        isNotEmpty(repairMer) &&
        isNotEmpty(tel) &&
        isNotEmpty(email) &&
        isNotEmpty(content)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      buttonEnable = enable;
    });
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
      var json = oaPeople.toJson();
      list.add(json);
    }
    return list;
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (isEmpty(cname)) {
      showWarnToast("报修人不能为空");
      return;
    }

    if (isEmpty(deptName)) {
      showWarnToast("报修部门不能为空");
      return;
    }

    if (isEmpty(repairKinds)) {
      showWarnToast("请选择报修种类");
      return;
    }

    if (isEmpty(repairMer)) {
      showWarnToast("报修物品不能为空");
      return;
    }

    if (isEmpty(tel)) {
      showWarnToast("联系方式不能为空");
      return;
    }

    if (isEmpty(repairAddress)) {
      showWarnToast("报修地址不能为空");
      return;
    }

    if (isEmpty(content)) {
      showWarnToast("故障描述不能为空");
      return;
    }

    if(getApproves().isEmpty) {
      showWarnToast("请选择审批人员");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      // 先上传文件

      List infoEnclosureList = [];
      if (isEdit && model.schoolOaRepairEnclosureList != null && model.schoolOaRepairEnclosureList.isNotEmpty) {
        for (var item in model.schoolOaRepairEnclosureList) {
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
      params['id'] = widget.id;
      params['workId'] = userId;
      params['dDate'] = repairDate;
      params['deptId'] = deptId;
      params['repairKinds'] = repairKinds;
      params['repairMer'] = repairMer;
      params['tel'] = tel;
      params['email'] = email;
      params['repairAddress'] = repairAddress;
      params['content'] = content;
      params['schoolOaRepairApproveList'] = getApproves();
      params['schoolOaRepairEnclosureList'] = infoEnclosureList;
      params['type'] = reviewType;

      var result = await RepairDao.submit(params, isSave: isSave);
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
                  const Text('审批人', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.only(left: 5),
                    decoration: bottomBoxShadow1(context),
                    child: const Text('依此审批', style: TextStyle(fontSize: 12, color: primary)),
                  ),
                  const Text(' *', style: TextStyle(fontSize: 13, color: Colors.red)),
                ],
              )),
          const Text('按图标调整次序', style: TextStyle(fontSize: 12, color: Colors.grey))
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
    } else {
      // 自定义
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
  _before(List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    setState(() {
      if (isDefault) {
        index == 0
            ? ListUtils.swapList(
            defaultApproves, rowIndex -1, rowIndex)
            : ListUtils.swapList(
            defaultNotices, rowIndex - 1, rowIndex);
      } else {
        index == 0
            ? ListUtils.swapList(
            customerApproves, rowIndex - 1, rowIndex)
            : ListUtils.swapList(
            customerNotices, rowIndex - 1, rowIndex);
      }
    });
  }

  /// 后移
  _after(List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    // 后移
    setState(() {
      if (isDefault) {
        index == 0
            ? ListUtils.swapList(
            defaultApproves, rowIndex, rowIndex + 1)
            : ListUtils.swapList(
            defaultNotices, rowIndex, rowIndex + 1);
      } else {
        index == 0
            ? ListUtils.swapList(
            customerApproves, rowIndex, rowIndex + 1)
            : ListUtils.swapList(
            customerNotices, rowIndex, rowIndex + 1);
      }
    });
  }

  /// 删除
  _delete(List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
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
  _onValueChangedClick(List lists, int index, int rowIndex, int value, ProcessInfo processInfo) {
    print("value: $value -- $index --- ${lists.length} -- ${rowIndex}");
    if (lists.length == 1) { // 只有1个元素
      _delete(lists, index, rowIndex, value, processInfo);
    } else if (lists.length == 2) { // 只有两个元素
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
    } else { // 多个元素
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
    if (lists.length == 1) { // 只有1个元素
      return ['删除'];
    } else if (lists.length == 2) { // 只有两个元素
      if (index == 0) {
        return ['后移', '删除'];
      } else {
        return ['前移', '删除'];
      }
    } else { // 多个元素
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
    FocusManager.instance.primaryFocus?.unfocus();
    BoostNavigator.instance.push("teacher_select_page", arguments: {'router': "repair_add_page", 'isShowDepCheck': false}).then((value){
      print("list: ${ListUtils.selecters}");

      setState(() {
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
