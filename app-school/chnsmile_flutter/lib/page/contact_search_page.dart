import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_depart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactSearchPage extends StatefulWidget {

  @override
  _ContactSearchPageState createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends HiState<ContactSearchPage> {

  List<DeptInfo> deptList;
  List<UserInfo> userList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('通讯录'),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: ListView(
          children: [
            _buildUserContact(),
            _buildDepartContact()
          ],
        ),
      ),
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      ContactDepartModel result = await ContactDao.getTeacher();
      setState(() {
        deptList = result?.deptInfo ?? [];
        userList = result?.userInfo ?? [];
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildUserContact() {
    return Container();
  }

  _buildDepartContact() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: deptList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) =>
            ContactDepartCard(item: deptList[index]));
  }
}
