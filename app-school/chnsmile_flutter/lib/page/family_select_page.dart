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

class FamilySelectPage extends StatefulWidget {
  final Map params;
  String pid = "0";
  String router;

  FamilySelectPage({Key key, this.params}) : super(key: key) {
    pid = params.isNotEmpty ? params['pid'] : "0";
    router = params.isNotEmpty ? params['router'] : "";
  }

  @override
  _FamilySelectPageState createState() => _FamilySelectPageState();
}

class _FamilySelectPageState extends HiState<FamilySelectPage> with PageVisibilityObserver{
  List<DeptInfo> deptList;
  List<UserInfo> userList;

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
          var e = ContactSelect(item.id, item.title, true, item.parentId);
          if(ListUtils.containDep(item.parentId)) {
            item.selected = true;
            ListUtils.addOrRemoveContact(e);
          } else {
            item.selected = ListUtils.selecters.contains(e);
          }
        });
      }
      if (userList != null && userList.isNotEmpty) {
        userList.forEach((item) {
          var e = ContactSelect(item.userId, item.userName, false, item.orgId);
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
    if (widget.pid == "0" || widget.pid == null) {
      ListUtils.cleanSelecter();
    }
    _loadData();
  }

  onSave() {
    if (ListUtils.selecters.isEmpty) {
      showWarnToast("请选择组织或者人员");
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
      ContactDepartModel result =
          await ContactDao.getTU(pid: widget.pid ?? "0");
      // 检测里面是否有当前的组织并且已经选择
      setState(() {
        deptList = result?.deptInfo ?? [];
        userList = result?.userInfo ?? [];
      });
      checkSelceted();
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
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
                ContactUserSelectCard(item: userList[index], pid: widget.pid))
        : Container();
  }

  _buildDepartContact() {
    return deptList != null && deptList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: deptList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                ContactDepSelectCard(item: deptList[index], router: widget.router))
        : Container();
  }
}
