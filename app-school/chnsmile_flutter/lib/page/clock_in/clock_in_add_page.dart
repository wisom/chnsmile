import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
import 'package:chnsmile_flutter/http/dao/fund_manager_dao.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/fund_manager_detail.dart';
import 'package:chnsmile_flutter/model/fund_manager_item_param.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

import '../../model/fund_manager_approve.dart';
import '../../utils/clockin_utils.dart';
import '../../utils/view_util.dart';
import '../../widget/oa_submit_button.dart';
import '../../widget/select_attach.dart';
import '../../widget/time_picker/model/date_mode.dart';
import '../../widget/time_picker/model/suffix.dart';
import '../../widget/time_picker/pickers.dart';

class ClockInAddPage extends StatefulWidget {
  final Map params;
  String id;

  ClockInAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _ClockInAddPageState createState() => _ClockInAddPageState();
}

class _ClockInAddPageState extends HiState<ClockInAddPage> {
  bool buttonEnable = false;
  int reviewType = 1;
  String timesStr = "无"; //打卡频次
  String title = ""; //标题
  String content = ""; // 内容
  String cname = ""; // 保修人姓名
  String orgId = ""; // id
  String orgName = ""; // 经费部门
  String remark = ""; // 备注
  String budget = ""; // 总预算
  String formId = ""; //
  String status = "0"; //经费状态
  String needDate = ""; //需求时间
  String startDate = ""; //开始时间
  String endDate = ""; //结束时间
  String createTime = ""; //创建时间
  List<Widget> optionsWidget = []; // 明细选项控件
  List<FundManagerItemParam> detailList = []; //明细列表
  List<FundManagerApprove> approves = []; // 审批人, 通知人
  List<SysOrg> sysorgs = [];

  List<ProcessInfo> defaultApproves; // 默认审批人
  List<ProcessInfo> defaultNotices; // 默认通知人
  List<ProcessInfo> customerApproves = []; // 自定义审批人
  List<ProcessInfo> customerNotices = []; // 自定义通知人
  List<LocalFile> files = []; // 选择文件数量

  FundManagerDetail model;
  bool isLoaded = false;
  TextEditingController _titleController;
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    orgId = HiCache.getInstance().get(HiConstant.spUserId);
    createTime = currentYearMothAndDay();
    loadDefaultData();
    timesStr = ClockInUtils.timesStr.isEmpty ? "无" : ClockInUtils.timesStr;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get isEdit {
    return widget.id != null;
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DefaultApplyDao.get();
      defaultApproves ??= [];
      defaultNotices ??= [];
      setState(() {
        if (!isEdit) {
          defaultApproves =
              result != null ? result.defaultApprove.processMxList : [];
        }
        if (!isEdit) {
          defaultNotices =
              result != null ? result.defaultNotice.processMxList : [];
        }
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
      body: isLoaded
          ? SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 120.0,
                  ),
                  child: Column(children: [
                    TextField(
                      onChanged: (text) {
                        title = text;
                      },
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      //键盘类型
                      decoration: const InputDecoration(
                          //文本框样式设置
                          contentPadding: EdgeInsets.all(15.0), //内容边距
                          hintText: "打卡标题",
                          hintStyle: TextStyle(color: HiColor.color_181717_A50),
                          border: InputBorder.none),
                      style: const TextStyle(fontSize: 14),
                      //字体样式
                      autofocus: false,
                      maxLines: 1, //单行文本框
                    ),
                    TextField(
                      onChanged: (text) {
                        content = text;
                      },
                      controller: _contentController,
                      keyboardType: TextInputType.text,
                      //键盘类型
                      decoration: const InputDecoration(
                          //文本框样式设置
                          contentPadding: EdgeInsets.all(15.0), //内容边距
                          hintText: "请输入打卡内容",
                          hintStyle: TextStyle(color: HiColor.color_181717_A50),
                          border: InputBorder.none),
                      style: const TextStyle(fontSize: 12),
                      //字体样式
                      autofocus: false,
                      minLines: 5,
                      maxLines: 10, //单行文本框
                    ),
                    line(context, margin: EdgeInsets.fromLTRB(13, 0, 13, 0)),
                    hiSpace(height: 21),
                    _buildAttach(),
                    hiSpace(height: 21),
                    hiSpaceWithColor(context, height: 8),
                    hiSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "参与范围",
                            style: TextStyle(
                                color: HiColor.color_181717, fontSize: 12),
                          ),
                          Text(
                            "初一1班、初一1班...",
                            style: TextStyle(
                                color: HiColor.color_181717, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    hiSpace(height: 16),
                    hiSpaceWithColor(context, height: 8),
                    hiSpace(height: 16),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          children: [
                            const Text(
                              "打卡时间        ",
                              style: TextStyle(
                                  color: HiColor.color_181717, fontSize: 12),
                            ),
                            Expanded(
                                child: Row(children: [
                              const Text(
                                "开始  ",
                                style: TextStyle(
                                    color: HiColor.color_181717, fontSize: 12),
                              ),
                              InkWell(
                                onTap: () {
                                  startTimeClick();
                                },
                                child: Container(
                                  width: 84,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: HiColor.color_F7F7F7),
                                  child: Center(
                                    child: Text(
                                      startDate.isEmpty ? "选择时间" : startDate,
                                      style: const TextStyle(
                                          color: HiColor.color_181717,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              )
                            ])),
                            Expanded(
                                child: Row(children: [
                              const Text(
                                "   结束  ",
                                style: TextStyle(
                                    color: HiColor.color_181717, fontSize: 12),
                              ),
                              InkWell(
                                onTap: () {
                                  endTimeClick();
                                },
                                child: Container(
                                  width: 84,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: HiColor.color_F7F7F7),
                                  child: Center(
                                    child: Text(
                                      endDate.isEmpty ? "选择时间" : endDate,
                                      style: const TextStyle(
                                          color: HiColor.color_181717,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ]))
                          ],
                        )),
                    hiSpace(height: 16),
                    line(context, margin: EdgeInsets.fromLTRB(13, 0, 13, 0)),
                    hiSpace(height: 16),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: InkWell(
                          onTap: () {
                            BoostNavigator.instance.push(
                                "clockin_timesselect_page",
                                arguments: {}).then((value) {
                              setState(() {
                                timesStr = value;
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "打卡频次    ",
                                style: TextStyle(
                                    color: HiColor.color_181717, fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    (timesStr ?? "") + "    ",
                                    style: const TextStyle(
                                        color: HiColor.color_181717,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 15, color: HiColor.color_5A5A5A)
                                ],
                              )
                            ],
                          ),
                        )),
                    hiSpace(height: 50),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: OASubmitButton(
                            onSavePressed: onSavePressed,
                            onSubmitPressed: onSubmitPressed))
                  ])))
          : Container(),
    );
  }

  /// 添加附件
  _buildAttach() {
    // unFocus();
    return SelectAttach(
        attachs: model?.toAttachList(),
        itemsCallBack: (List<LocalFile> items) {
          print("items: ${items}");
          files = items ?? [];
        });
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  _buildAppBar() {
    return appBar('新建打卡');
  }

  showDepartDialog() {
    FocusManager.instance.primaryFocus?.unfocus();
    List<String> list = [];
    for (var item in sysorgs) {
      list.add(item.name);
    }

    print("list:$list");
    showListDialog(context, title: '请选择经费部门', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        SysOrg item = sysorgs[index];
        orgName = item.name;
        orgId = item.id;
      });
    });
  }

  showStatusDialog() {
    List<String> list = ['未发出', '已备案', '审批中', '已拒绝'];
    showListDialog(context, title: '请选择经费状态', list: list,
        onItemClick: (String type, int index) {
      setState(() {
        status = type;
      });
    });
  }

  checkInput() {
    bool enable;

    if (isNotEmpty(cname) &&
        isNotEmpty(orgName) &&
        isNotEmpty(needDate) &&
        isNotEmpty(content)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      buttonEnable = enable;
    });
  }

  onSavePressed() async {
    onSubmitPressed(isSave: true);
  }

  onSubmitPressed({isSave = false}) async {
    if (isEmpty(orgName)) {
      showWarnToast("部门不能为空");
      return;
    }
    if (isEmpty(needDate)) {
      showWarnToast("需求时间不能为空");
      return;
    }
    if (isEmpty(content)) {
      showWarnToast("用途不能为空");
      return;
    }

    if (isEmpty(budget)) {
      showWarnToast("预计总价不能为空");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      // 先上传文件

      List infoEnclosureList = [];
      if (isEdit &&
          model.fundApplyAccessoryParamList != null &&
          model.fundApplyAccessoryParamList.isNotEmpty) {
        for (var item in model.fundApplyAccessoryParamList) {
          infoEnclosureList.add({"attachId": item.fileId});
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
      params['orgId'] = orgId;
      params['orgName'] = orgName;
      params['content'] = content;
      params['remark'] = remark;
      params['budget'] = budget;
      if (!isSave) {
        params['formId'] = null;
      }
      params['needDate'] = needDate;
      params['status'] = isSave ? "0" : "1";
      params['fundApplyAccessoryParamList'] = infoEnclosureList;

      var result = await FundManagerDao.submit(params, isSave: isSave);
      formId = result['data'];
      showWarnToast(isSave ? '保存成功' : '发布成功');
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop({"success": true});
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  /// 是否是默认的批阅信息
  bool get isDefault {
    return reviewType == 1;
  }

  startTimeClick() {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day}';
        setState(() {
          startDate = time;
        });
      },
    );
  }

  endTimeClick() {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day}';
        setState(() {
          endDate = time;
        });
      },
    );
  }
}
