import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';

class ContactTeacherPage extends StatefulWidget {
  final Map params;
  List<String> selectApproveList = [];

  ContactTeacherPage({Key key, this.params}) : super(key: key) {
    selectApproveList = params['selects'] as List<String>;
  }

  @override
  _ContactTeacherPageState createState() => _ContactTeacherPageState();
}

class _ContactTeacherPageState extends HiState<ContactTeacherPage> {
  List<ClassInfo> classInfo;
  Map<String, List<StudentParentInfo>> studentParentInfo;
  bool allSelected = false;
  int selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('通讯录', rightTitle: '确定', rightButtonClick: () {
        List<StudentParentInfo> resultData = [];
        studentParentInfo.forEach((key, value) {
          for (var item in value) {
            if (item.selected != null && item.selected) {
              resultData.add(item);
            }
          }
        });
        BoostNavigator.instance.pop({"selects": resultData});
      }),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: ListView(
          children: [_buildTop(), _buildDepartContact()],
        ),
      ),
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      ContactDepartModel result = await ContactDao.getTeacher();

      // 获取classid对应的学生
      List<DeptInfo> deptInfoList = result?.deptInfo ?? [];
      Map<String, List<StudentParentInfo>> studentParentInfoList = {};
      bool isAllSelected = true;

      for (DeptInfo item1 in deptInfoList) {
        List<StudentParentInfo> list = [];
        bool isClassSelected = true;

        // for (StudentParentInfo item2 in result.studentParentInfo) {
        //   if (item1.classId == item2.classId) {
        //     list.add(item2);
        //     studentParentInfoList[item1.classId] = list;
        //     // 设置selected
        //     if (widget.selectApproveList.contains(item2.userId)) {
        //       item2.selected = true;
        //     } else {
        //       isAllSelected = false;
        //       item2.selected = false;
        //       isClassSelected = false;
        //     }
        //   }
        // }
        // item1.selected = isClassSelected;

      }

      setState(() {
        studentParentInfo = studentParentInfoList;
        selectedCount = widget.selectApproveList.length;
        allSelected = isAllSelected;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildDepartContact() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: classInfo?.length ?? 0,
        itemBuilder: (BuildContext context, int index) => ContactFamilyCard(
            itemPress: (classId, userId, studentId, checked) {
              select(userId, studentId, selected: checked, classId: classId);
            },
            item: classInfo[index],
            subItems: studentParentInfo[classInfo[index].classId]));
  }

  countPeople() {
    int count = 0;
    studentParentInfo.forEach((key, value) {
      for (var item in value) {
        if (item.selected != null && item.selected) {
          count++;
        }
      }
    });
    setState(() {
      selectedCount = count;
    });
  }

  select(String userId, String studentId, {bool selected = false, String classId}) {
    if (isNotEmpty(classId)) {
      // 选择了班级
      studentParentInfo.forEach((key, value) {
        for (var item in value) {
          if (item.classId == classId) {
            item.selected = selected;
          }
        }
      });
    } else {
      // 选择了家长
      studentParentInfo.forEach((key, value) {
        for (var item in value) {
          if (item.userId == userId) {
            item.selected = selected;
          }
        }
      });
    }
    countPeople();
  }

  allSelect(bool selected) {
    setState(() {
      allSelected = selected;
      for (var item in classInfo) {
        item.selected = allSelected;
        for (var item2 in studentParentInfo[item.classId]) {
          item2.selected = selected;
        }
      }
    });
    countPeople();
  }

  Widget _buildTop() {
    return Container(
        color: Colors.white,
        child: Row(children: [
          GestureDetector(
              onTap: () {
                allSelect(!allSelected);
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      allSelect(value);
                    }),
                const Text('全选',
                    style: TextStyle(color: Colors.black, fontSize: 13)),
              ])),
          Expanded(child: Container()),
          Text('已选$selectedCount人',
              style: const TextStyle(color: primary, fontSize: 13))
        ]));
  }
}
