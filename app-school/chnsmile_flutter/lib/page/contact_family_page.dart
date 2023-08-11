import 'dart:collection';

import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_family.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_family_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';

class ContactFamilyPage extends StatefulWidget {
  final Map params;
  List<ContactFamily> selectApproveList = [];

  ContactFamilyPage({Key key, this.params}) : super(key: key) {
    selectApproveList = params['selects'] as List<ContactFamily>;
  }

  @override
  _ContactFamilyPageState createState() => _ContactFamilyPageState();
}

class _ContactFamilyPageState extends HiState<ContactFamilyPage> {
  List<ClassInfo> classInfo;
  Map<String, List<StudentParentInfo>> studentParentInfo;
  bool allSelected = false;
  int selectedCount = 0;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('通讯录', rightTitle: '确定', rightButtonClick: () {
        var selects = ContactFamilyModel();
        List<StudentParentInfo> resultData = [];
        List<ClassInfo> resultData2 = [];
        classInfo.forEach((item) {
          if (item.selected != null && item.selected) {
            resultData2.add(item);
          }
        });
        selects.classInfo = resultData2;
        selects.allSelected = allSelected;

        studentParentInfo.forEach((key, value) {
          for (var item in value) {
            if (item.selected != null && item.selected && !resultData2.contains(ClassInfo(classId: item.classId))) {
              resultData.add(item);
            }
          }
        });
        selects.studentParentInfo = resultData;
        selects.selectedCount = selectedCount;
        print("selects: $selects");
        BoostNavigator.instance.pop({"selects": selects});
      }),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: !isEmpty ? ListView(
          children: [_buildTop(), _buildDepartContact()],
        ) : const EmptyView(),
      ),
    );
  }

  // bool get isEmpty {
  //   if ((userList == null || userList.isEmpty) &&
  //       (deptList == null || deptList.isEmpty)) {
  //     return true;
  //   }
  //   return false;
  // }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      ContactFamilyModel result = await ContactDao.getFamily();

      // 获取classid对应的学生
      List<ClassInfo> classInfoList = result?.classInfo ?? [];
      Map<String, List<StudentParentInfo>> studentParentInfoList = {};
      bool isAllSelected = true;

      for (ClassInfo item1 in classInfoList) {
        List<StudentParentInfo> list = [];
        if (widget.selectApproveList.contains(ContactFamily(item1.classId, "", ""))) {
          item1.selected = true;
          for (StudentParentInfo item2 in result.studentParentInfo) {
            if (item1.classId == item2.classId) {
              item2.selected = true;
              list.add(item2);
              studentParentInfoList[item1.classId] = list;
            }
          }
        } else {
          bool isClassSelected = false;
          if (result.studentParentInfo.isEmpty) {
            isAllSelected = false;
          } else {
            for (StudentParentInfo item2 in result.studentParentInfo) {
              if (item1.classId == item2.classId) {
                list.add(item2);
                studentParentInfoList[item1.classId] = list;
                // 设置selected
                if (widget.selectApproveList.contains(ContactFamily(item2.classId, item2.userId, item2.studentId))) {
                  item2.selected = true;
                } else {
                  isAllSelected = false;
                  item2.selected = false;
                  isClassSelected = false;
                }
              }
            }
          }

          item1.selected = isClassSelected;
        }
      }

      setState(() {
        classInfo = classInfoList;
        studentParentInfo = studentParentInfoList;
        isEmpty = classInfo.isEmpty && studentParentInfo.isEmpty;
        countPeople();
        allSelected = isAllSelected;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      isEmpty = true;
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
      classInfo.forEach((item) {
        if (item.classId == classId) {
          item.selected = selected;
        }
      });
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
          if (item.studentId == studentId && item.userId == userId) {
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
        if (item != null && studentParentInfo != null && studentParentInfo[item.classId] != null) {
          for (var item2 in studentParentInfo[item.classId]) {
            item2.selected = selected;
          }
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
