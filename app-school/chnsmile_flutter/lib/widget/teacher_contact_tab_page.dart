import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_family2_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_dep_contact_card.dart';
import 'package:chnsmile_flutter/widget/teacher_user_contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherContactTabPage extends StatefulWidget {
  final Map params;
  final String type;
  String pid = "0";

  TeacherContactTabPage({Key key, this.type, this.params}) : super(key: key) {
    pid = params != null ? params['pid'] : "0";
  }

  @override
  _TeacherContactTabPageState createState() => _TeacherContactTabPageState();
}

class _TeacherContactTabPageState extends HiState<TeacherContactTabPage> {
  List<DeptInfo> deptList;
  List<UserInfo> userList;
  List<ClassInfo> classInfo;
  Map<String, List<StudentParentInfo>> studentParentInfo;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool get isRootPage {
    return widget.pid == null || widget.pid == "0";
  }

  @override
  Widget build(BuildContext context) {
    print("widget.pid: ${widget.pid}");
    return isRootPage ? getTabContent() : getPageContent();
  }

  Widget getTabContent() {
    return Container(
      color: Colors.white,
      child: !isEmpty
          ? ListView(children: [
              _buildUserContact(),
              _buildDepartContact(),
              _buildFamily()
            ])
          : isLoaded ? Container() :  const EmptyView(),
    );
  }

  _buildFamily() {
    if (!isRootPage) return Container();

    return Column(
      children: [
        Container(
          height: 20,
          color: Colors.grey[200],
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classInfo?.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                ContactFamily2Card(
                    item: classInfo[index],
                    subItems: studentParentInfo[classInfo[index].classId]))
      ],
    );
  }

  Widget getPageContent() {
    return Scaffold(appBar: appBar("通讯录"), body: getTabContent());
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
      if (isRootPage) {
        ContactFamilyModel result = await ContactDao.getFamily();
        // 获取classid对应的学生
        List<ClassInfo> classInfoList = result?.classInfo ?? [];
        Map<String, List<StudentParentInfo>> studentParentInfoList = {};

        for (ClassInfo item1 in classInfoList) {
          List<StudentParentInfo> list = [];

          for (StudentParentInfo item2 in result.studentParentInfo) {
            if (item1.classId == item2.classId) {
              list.add(item2);
              studentParentInfoList[item1.classId] = list;
            }
          }
        }
        setState(() {
          classInfo = classInfoList;
          studentParentInfo = studentParentInfoList;
        });
      }
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
            TeacherUserContactCard(
                item: userList[index], pid: widget.pid))
        : Container();
  }

  _buildDepartContact() {
    return deptList != null && deptList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: deptList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                TeacherDepContactCard(item: deptList[index]))
        : Container();
  }
}
