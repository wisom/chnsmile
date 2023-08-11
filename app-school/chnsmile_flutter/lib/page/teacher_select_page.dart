import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_dep_select_card.dart';
import 'package:chnsmile_flutter/widget/contact_user_select_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherSelectPage extends StatefulWidget {
  final Map params;
  String pid = "0";
  String router;
  bool isShowDepCheck = true;
  bool isCleanPeople = true;
  bool isNeedFloor = false;

  TeacherSelectPage({Key key, this.params}) : super(key: key) {
    pid = params.isNotEmpty ? params['pid'] : "0";
    router = params.isNotEmpty ? params['router'] : "";
    isCleanPeople = params.isNotEmpty ? params['isCleanPeople'] ?? true : true;
    isShowDepCheck = params.isNotEmpty ? params['isShowDepCheck'] ?? true : true;
    isNeedFloor = params.isNotEmpty ? params['isNeedFloor'] ?? false : false;
  }

  @override
  _TeacherSelectPageState createState() => _TeacherSelectPageState();
}

class _TeacherSelectPageState extends HiState<TeacherSelectPage>
    with PageVisibilityObserver {
  List<DeptInfo> deptList;
  List<UserInfo> userList;
  var isLoaded = false;

  @override
  void onPageHide() {
    super.onPageHide();
  }

  @override
  void onPageShow() {
    super.onPageShow();
    // 检测里面是否有当前的组织并且已经选择
    checkSelceted();
  }

  checkSelceted() {
    bool currentSelectDep = false;
    ListUtils.selecters.forEach((item) {
      if (item.isDep && item.id == widget.pid) {
        currentSelectDep = true;
      }
    });

    setState(() {
      if (deptList != null && deptList.isNotEmpty) {
        deptList.forEach((item) {
          var e = ContactSelect(item.id, item.title, true, item.parentId, orgName: item.title);
          if (ListUtils.containDep(item.parentId)) {
            item.selected = true;
            ListUtils.addOrRemoveContact(e);
          } else {
            item.selected = ListUtils.selecters.contains(e);
          }
        });
      }
      if (userList != null && userList.isNotEmpty) {
        userList.forEach((item) {
          var e = ContactSelect(item.userId, item.userName, false, item.orgId, teacherId: item.teacherId, orgName: item.orgName);
          // 判断组织里面是否全选了
          if (currentSelectDep) {
            item.selected = true;
            ListUtils.addOrRemoveContact(e);
          } else {
            item.selected = ListUtils.selecters.contains(e);
          }
        });
      }
    });

    print("ListUtils.selecters1: ${ListUtils.selecters}");
  }

  /// 检测数量是否正确
  void checkCount() {
    bool unSelected = false;
    if (deptList != null) {
      deptList.forEach((dep) {
        if (!dep.selected) {
          unSelected = true;
        }
      });
    }
    if (userList != null) {
      userList.forEach((user) {
        if (!user.selected) {
          unSelected = true;
        }
      });
    }

    ListUtils.selecters.removeWhere((item) {
      return unSelected && item.id == widget.pid;
    });

    print("ListUtils.selecters2: ${ListUtils.selecters}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    ///移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("widget: ${widget.isShowDepCheck}");
    if (widget.isCleanPeople && (widget.pid == "0" || widget.pid == null)) {
      ListUtils.cleanSelecter();
    }
    _loadData();
  }

  onSave() {
    if (ListUtils.selecters.isEmpty) {
      showWarnToast("请选择组织或者人员");
      return;
    }
    if (widget.isNeedFloor && !ListUtils.isSelectFloor()) {
      showWarnToast("请选择对应人员层级");
      return;
    }
    print("list: ${ListUtils.selecters} - ${widget.router}");
    BoostNavigator.instance.popUntil(route: widget.router);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("通讯录", rightTitle: "保存", rightButtonClick: onSave),
        body: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: !isEmpty
              ? ListView(children: [_buildUserContact(), _buildDepartContact()])
              : isLoaded
                  ? Container()
                  : const EmptyView(),
        ));
  }

  bool get isEmpty {
    if ((userList == null || userList.isEmpty) &&
        (deptList == null || deptList.isEmpty)) {
      return true;
    }
    return false;
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      isLoaded = true;
      ContactDepartModel result =
          await ContactDao.getTU(pid: widget.pid ?? "0");
      // 检测里面是否有当前的组织并且已经选择
      setState(() {
        deptList = result?.deptInfo ?? [];
        userList = result?.userInfo ?? [];
      });
      checkSelceted();
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildUserContact() {
    return userList != null && userList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                ContactUserSelectCard(item: userList[index],
                    isNeedFloor: widget.isNeedFloor,
                    pid: widget.pid, onItemSelect: (item) {
                  checkCount();
                }))
        : Container();
  }

  _buildDepartContact() {
    return deptList != null && deptList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: deptList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                ContactDepSelectCard(
                    item: deptList[index],
                    router: widget.router,
                    isShowDepCheck: widget.isShowDepCheck,
                    isNeedFloor: widget.isNeedFloor,
                    onItemSelect: (item) {
                      checkCount();
                    }))
        : Container();
  }
}
