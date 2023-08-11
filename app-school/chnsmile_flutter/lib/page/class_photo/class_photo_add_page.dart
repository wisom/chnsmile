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
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

import '../../model/fund_manager_approve.dart';
import '../../widget/time_picker/model/date_mode.dart';
import '../../widget/time_picker/model/suffix.dart';
import '../../widget/time_picker/pickers.dart';

class ClassPhotoAddPage extends StatefulWidget {
  final Map params;
  String id;

  ClassPhotoAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _ClassPhotoAddPageState createState() => _ClassPhotoAddPageState();
}

class _ClassPhotoAddPageState extends HiState<ClassPhotoAddPage> {
  bool buttonEnable = false;
  int reviewType = 1;
  String cname = ""; // 保修人姓名
  String orgId = ""; // id
  String orgName = ""; // 经费部门
  String content = ""; // 经费内容
  String remark = ""; // 备注
  String budget = ""; // 总预算
  String formId = ""; //
  String status = "0"; //经费状态
  String needDate = ""; //需求时间
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

  @override
  void initState() {
    super.initState();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    orgId = HiCache.getInstance().get(HiConstant.spUserId);
    createTime = currentYearMothAndDay();
    loadDefaultData();
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
          ? Column(
              children: [_buildTopInfo(), box(context), _buildCenterInfo()],
            )
          : Container(),
    );
  }

  _buildCenterInfo() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.fromLTRB(21, 16, 21, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "发布范围",
            style: TextStyle(color: HiColor.color_181717, fontSize: 12),
          ),
          hiSpace(width: 20),
          Text(
            "初一1期-班级群、初一2期-班群..",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: HiColor.color_181717, fontSize: 12),
          )
        ],
      ),
    );
  }

  _buildTopInfo() {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(17, 13, 17, 22),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(
                fontSize: 14,
                color: HiColor.color_181717,
              ),
            ),
            hiSpace(height: 16),
            const TextField(
              style: TextStyle(fontSize: 12, color: HiColor.color_181717),
            ),
            line(context),
            hiSpace(height: 21),
            Row(
              children: [
                const Icon(
                  Icons.add_box_outlined,
                  size: 27,
                  color: HiColor.color_03081A,
                ),
                hiSpace(width: 21),
                const Text(
                  "上传封面",
                  style: TextStyle(
                    fontSize: 12,
                    color: HiColor.color_03081A,
                  ),
                )
              ],
            )
          ],
        ));
  }

  /// 未发出状态
  bool get isUnSend {
    if (model == null) {
      return false;
    }
    return model?.status == 0;
  }

  _buildAppBar() {
    return appBar('新建相册');
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

  timeClick() {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      onConfirm: (p) {
        String time = '${p.year}-${p.month}-${p.day}';
        setState(() {
          needDate = time;
        });
      },
    );
  }
}
