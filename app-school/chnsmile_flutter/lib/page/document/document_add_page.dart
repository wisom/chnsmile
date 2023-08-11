import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
import 'package:chnsmile_flutter/http/dao/document_dao.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/document_detail_model.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
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

class DocumentAddPage extends StatefulWidget {
  final Map params;
  String id;

  DocumentAddPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _DocumentAddPageState createState() => _DocumentAddPageState();
}

class _DocumentAddPageState extends HiState<DocumentAddPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();

  bool buttonEnable = false;
  int reviewType = 1;
  String cname; // 姓名
  String documentDate; // 日期
  String documentId; // 文件编号
  String documentTitle; // 文件标题
  String content; // 内容
  String remark; // 备注

  List<OAPeople> approves = []; // 审批人, 通知人

  List<ProcessInfo> defaultApproves; // 默认审批人
  List<ProcessInfo> defaultNotices; // 默认通知人
  List<ProcessInfo> customerApproves = []; // 自定义审批人
  List<ProcessInfo> customerNotices = []; // 自定义通知人
  List<LocalFile> files = []; // 选择文件数量
  DocumentDetailModel model;
  bool isLoaded = false;

  final ProcessInfo iconInfo =
      ProcessInfo(avatarImg: "images/contact_add_button.png", userId: "-1");

  List<String> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员

  @override
  void initState() {
    super.initState();
    cname = HiCache.getInstance().get(HiConstant.spUserName);
    documentDate = currentYearMothAndDay();
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
    focusNode4.dispose();
    super.dispose();
  }

  handleApproves(List<DocumentApproveInfoList> approves) {
    for (var i = 0; i < approves.length; i++ ) {
      var item = approves[i];
      if ("1" == item.kinds) {
        defaultApproves.add(ProcessInfo(
            avatarImg: item.avatarImg,
            userId: item.approveId,
            floor: item.floor.toString(),
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
      var result = await DefaultApplyDao.getDocument();
      defaultApproves ??= [];
      defaultNotices ??= [];
      if (isEdit) {
        var result = await DocumentDao.detail(widget.id);
        setState(() {
          model = result;
          documentId = model.docId;
          documentTitle = model.title;
          content = model.content;
          remark = model.remark;
          handleApproves(model.approves);
        });
        isLoaded = true;
      }
      setState(() {
        defaultApproves = defaultApproves.isEmpty
            ? (result != null && result.defaultApprove != null) ? result.defaultApprove.processMxList : defaultApproves
            : defaultApproves;
        defaultApproves.insert(defaultApproves.length, _getAddIcon());

        customerApproves.add(_getAddIcon());

        defaultNotices = defaultNotices.isEmpty
            ? (result != null && result.defaultNotice != null) ? result.defaultNotice.processMxList : defaultNotices
            : defaultNotices;
        defaultNotices.insert(defaultNotices.length, _getAddIcon());

        customerNotices.add(_getAddIcon());

      });
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
      body: isLoaded
          ? ListView(
              children: [
                _buildTop(),
                hiSpace(height: 12),
                _buildAttach(),
                hiSpace(height: 12),
                _buildBottom()
              ],
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

    return appBar(isEdit ? '公文流转详情' : '公文新建', rightTitle: rightTitle, rightButtonClick: () {
      if (rightTitle == '删除') {
        delete();
      }
    });
  }

  delete() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DocumentDao.delete(model.formId);
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
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
                  flex: 6,
                  child: Row(
                    children: [
                      const Text('表单编号:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(model != null ? model.formId : '提交后生成',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      const Text('发起日期:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(documentDate ?? '',
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
                      const Text('发  起  人:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(cname,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: const [
                      Text('公文状态:',
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
              const Text('文件编号:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入文件编号",
                  focusNode: focusNode1,
                  initialValue: model != null ? model.docId : '',
                  onChanged: (text) {
                    documentId = text;
                    // checkInput();
                  },
                ),
              )
            ],
          ),
          hiSpace(height: 15),
          Row(
            children: [
              Star(),
              const Text('文件标题:',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              Expanded(
                child: NormalInput(
                  hint: "请输入文件标题",
                  focusNode: focusNode2,
                  initialValue: model != null ? model.title : '',
                  onChanged: (text) {
                    documentTitle = text;
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
                  const Text('文件内容:',
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
              hiSpace(height: 8),
              NormalMultiInput(
                  hint: '请输入文件内容',
                  focusNode: focusNode3,
                  initialValue: model != null ? model.content : '',
                  margin: 0,
                  minLines: 5,
                  maxLines: 5,
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
                  focusNode: focusNode4,
                  initialValue: model != null ? model.remark : '',
                  margin: 0,
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

  /// 添加附件
  _buildAttach() {
    return SelectAttach(
        attachs: model?.attachs,
        itemsCallBack: (List<LocalFile> items) {
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
        isNotEmpty(documentDate) &&
        isNotEmpty(documentId) &&
        isNotEmpty(documentTitle) &&
        isNotEmpty(remark) &&
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
      for (var i = 0; i < defaultApproves.length; i++) {
        var processInfo = defaultApproves[i];
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(
            kinds: "1",
            approveId: processInfo.userId,
            floor: processInfo.floor));
      }

      for (var i = 0; i < defaultNotices.length; i++) {
        var processInfo = defaultNotices[i];
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(kinds: "2", approveId: processInfo.userId));
      }
    } else {
      for (var i = 0; i < customerApproves.length; i++) {
        var processInfo = customerApproves[i];
        if (processInfo.userId == "-1") {
          continue;
        }
        approves.add(OAPeople(
            kinds: "1",
            approveId: processInfo.userId,
            floor:processInfo.floor));
      }

      for (var i = 0; i < customerNotices.length; i++) {
        var processInfo = customerNotices[i];
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
      showWarnToast("发起人不能为空");
      return;
    }

    if (isEmpty(documentId)) {
      showWarnToast("文件编号不能为空");
      return;
    }

    if (isEmpty(documentTitle)) {
      showWarnToast("文件标题不能为空");
      return;
    }

    if (isEmpty(content)) {
      showWarnToast("内容不能为空");
      return;
    }

    if (getApproves().isEmpty) {
      showWarnToast("请选择审批人员");
      return;
    }

    try {
      EasyLoading.show(status: '加载中...');
      // 先上传文件

      List infoEnclosureList = [];
      if (isEdit && model.attachs != null && model.attachs.isNotEmpty) {
        for (var item in model.attachs) {
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
      params['remark'] = remark ?? "";
      params['title'] = documentTitle;
      params['content'] = content;
      params['docId'] = documentId;
      params['documentApproveInfoList'] = getApproves();
      params['documentEnclosureInfoList'] = infoEnclosureList;

      var result = await DocumentDao.submit(params, isSave: isSave);
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
                child: const Text('依层级审批',
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
              ? _buildOAPeople(lists, processInfo, index, rowIndex)
              : _buildMagio(lists, processInfo, index, rowIndex);
        }).toList());
  }

  Widget _buildMagio(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    List<ProcessInfo> listsTemp = List.from(lists);
    listsTemp.remove(iconInfo);
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
        onValueChanged: (int value) {
          _onValueChangedClick(listsTemp, index, rowIndex, value, processInfo);
        },
        backgroundColor: primary,
        menuWidth: menuWidth,
        menuHeight: 36,
        actions: _buildActions(listsTemp, rowIndex),
        pressType: PressType.longPress,
        child: _buildOAPeople(lists, processInfo, index, rowIndex));
  }

  Widget _buildOAPeople(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildIcon(lists, processInfo, index, rowIndex),
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
   * index : 第一行，第二行 审批人或者通知人那一栏  0，1之中选择
   * rowIndex:  里面的列表行数
   * value: 前移，后移，删除的位置
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

  _buildIcon(List<ProcessInfo> lists, ProcessInfo processInfo, int index,
      int rowIndex) {
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
      return index == 0
          ? Stack(
        children: [
          showAvatorIcon(
              avatarImg: processInfo.avatarImg,
              name: processInfo.approveName),
          Positioned(
              top: 0,
              right: 3,
              child: Container(
                alignment: Alignment.center,
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(processInfo.floor.toString(), style: const TextStyle(fontSize: 10, color: Colors.white)),
              )
          )
        ],
      )
          : showAvatorIcon(
          avatarImg: processInfo.avatarImg, name: processInfo.approveName);
    }
  }

  unFocus() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    focusNode3.unfocus();
    focusNode4.unfocus();
  }

  showContact(int index) {
    unFocus();
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': 'document_add_page',
      'isNeedFloor' : index == 0 ? true : false,
      'isShowDepCheck': false
    }).then((value) {
      print("list: ${ListUtils.selecters}, index: ${index}");
      if (ListUtils.selecters.isEmpty) {
        return;
      }

      setState(() {
        ListUtils.selecters.forEach((item) {
          var p = ProcessInfo(
              avatarImg: item.avatorUrl,
              userId: item.id,
              floor: item.floor,
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
