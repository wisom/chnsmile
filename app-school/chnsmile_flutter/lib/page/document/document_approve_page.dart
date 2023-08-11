import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/http/dao/document_dao.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/document_pc_model.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/w_pop/w_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class DocumentApprovePage extends StatefulWidget {
  final Map params;
  String id;
  String formId;

  DocumentApprovePage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    formId = params['formId'];
  }

  @override
  _DocumentApprovePageState createState() => _DocumentApprovePageState();
}

class _DocumentApprovePageState extends HiState<DocumentApprovePage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  bool buttonEnable = false;
  int reviewType = 1;
  String content; // 内容

  List<OAPeople> approves = []; // 审批人, 通知人

  List<ProcessInfo> defaultApproves; // 默认审批人
  List<ProcessInfo> defaultNotices; // 默认通知人
  List<ProcessInfo> customerApproves = []; // 自定义审批人
  List<ProcessInfo> customerNotices = []; // 自定义通知人
  DocumentPcModel model;
  bool isLoaded = false;

  final ProcessInfo iconInfo =
      ProcessInfo(avatarImg: "images/contact_add_button.png", userId: "-1");

  List<String> selectApproveList = []; // 通知人员
  List infoApproveList = []; // 通知人员

  @override
  void initState() {
    super.initState();
    loadDefaultData();
  }

  bool get hasPermission {
    return model != null && model.permission == 1;
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  handleApproves(List<SchoolOaDocumentApproveList> approves) {
    int count = 0;
    for (var i = 0; i < approves.length; i++ ) {
      var item = approves[i];
      if ("1" == item.kinds) {
        if (item.agentId != null && item.agentId != "") {
          count++;
        }
        defaultApproves.add(ProcessInfo(
            id: item.id,
            userId: item.approveId,
            agentId: item.agentId,
            floor: item.floor.toString(),
            approveName: item.approveName));
      } else {
        defaultNotices.add(ProcessInfo(
            id: item.id,
            userId: item.approveId,
            agentId: item.agentId,
            floor: item.floor.toString(),
            approveName: item.approveName));
      }
    }
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      DocumentPcModel result = await DocumentDao.approvePc(widget.formId);
      if (result != null) {
        setState(() {
          model = result;
          defaultApproves ??= [];
          defaultNotices ??= [];
          handleApproves(model.approves);

          defaultApproves.insert(defaultApproves.length, _getAddIcon());
          customerApproves.add(_getAddIcon());
          defaultNotices.insert(defaultNotices.length, _getAddIcon());
          customerNotices.add(_getAddIcon());
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
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildContent(),
          hasPermission ? _buildBottom() : Container()
        ],
      ),
    );
  }

  _buildContent() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: 12, left: 12, right: 12, bottom: hasPermission ? 12 : 30),
      child: Stack(
        children: [
          Positioned(
            child: InkWell(
                onTap: () {
                  // 关闭
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close, size: 22, color: Colors.grey)),
            right: 0,
          ),
          Column(
            children: [
              const Text(
                '审批',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              hiSpace(height: 20),
              NormalMultiInput(
                  hint: '请输入审批内容',
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (text) {
                    content = text;
                  }),
              hiSpace(height: 10),
              Row(
                children: [
                  HiButton("同意", bgColor: primary, onPressed: () {
                    if (isEmpty(content)) {
                      showWarnToast('请填写内容');
                      return;
                    }
                    approve(content, 2);
                  }),
                  hiSpace(width: 40),
                  HiButton("拒绝", bgColor: Colors.green, onPressed: () {
                    if (isEmpty(content)) {
                      showWarnToast('请输入审批内容');
                      return;
                    }
                    approve(content, 3);
                  })
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  approve(String content, int status) async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['formId'] = widget.formId;
      params['approveRemark'] = content;
      params['status'] = status;
      var result = await DocumentDao.approve(params);
      PlatformMethod.sentTriggerUnreadToNative();
      BoostNavigator.instance.pop();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  /// 批阅信息
  _buildBottom() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 50),
      color: Colors.white,
      child: Column(
        children: [
          _buildBottomTips(),
          hiSpace(height: 10),
          _buttonBottomContent(0),
          _buttonBottomContent(1),
        ],
      ),
    );
  }

  _buildBottomTips() {
    return Container(
      alignment: Alignment.centerLeft,
      child: const Text('批阅信息',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  /// 是否是默认的批阅信息
  bool get isDefault {
    return reviewType == 1;
  }

  _buttonBottomContent(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(border: BorderTimeLine(index)),
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
    );
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
              ? _buildOAPeople1(lists, processInfo, index, rowIndex)
              : _buildMagio(lists, processInfo, index, rowIndex);
        }).toList());
  }

  Widget _buildMagio(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    if (processInfo.agentId != null && processInfo.agentId != "") { // 不能删除
      return _buildOAPeople1(lists, processInfo, index, rowIndex);
    }
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
        child: _buildOAPeople1(lists, processInfo, index, rowIndex));
  }

  Widget _buildOAPeople1(List<ProcessInfo> lists, ProcessInfo processInfo,
      int index, int rowIndex) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildIcon1(lists, processInfo, index, rowIndex),
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
  _delete(List lists, int index, int rowIndex, int value,
      ProcessInfo processInfo) async {
    if (processInfo.agentId == null || processInfo.agentId == "") {
      var result = await removeApprove(processInfo.id);
      if (!result) {
        return;
      }
    } else {
      showWarnToast("不能删除这个审核人员");
      return;
    }
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

  _buildIcon1(List<ProcessInfo> lists, ProcessInfo processInfo, int index, int rowIndex) {
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
  }

  addApprove(int index) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result;
      ListUtils.selecters.forEach((item) async {
        Map<String, dynamic> params = {};
        params['formId'] = widget.formId;
        params['approveId'] = item.id;
        params['floor'] = index == 0 ? item.floor : defaultNotices.length;
        params['kinds'] = index == 0 ? "1" : "2";
        result = await DocumentDao.addApprove(params);
        if (index == 0) {
          // 审批人
          defaultApproves.forEach((element) {
            if (element.userId == item.id) {
              element.id = result['data'];
            }
          });
        } else {
          // 通知人
          defaultNotices.forEach((element) {
            if (element.userId == item.id) {
              element.id = result['data'];
            }
          });
        }
      });

      EasyLoading.dismiss(animation: false);
      return true;
    } catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
      return false;
    }
  }

  removeApprove(String id) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DocumentDao.removeApprove(id);
      EasyLoading.dismiss(animation: false);
      return true;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
      return false;
    }
  }

  showContact(int index) {
    unFocus();
    BoostNavigator.instance.push("teacher_select_page", arguments: {
      'router': 'document_approve_page',
      'isNeedFloor' : index == 0 ? true : false,
      'isShowDepCheck': false
    }).then((value) async {
      print("list: ${ListUtils.selecters}, index: ${index}");
      if (ListUtils.selecters.isEmpty) {
        return;
      }

      var result = await addApprove(index);
      if (!result) {
        return;
      }

      setState(() {
        ListUtils.selecters.forEach((item) {
          var p = ProcessInfo(
              avatarImg: item.avatorUrl,
              floor: item.floor,
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
