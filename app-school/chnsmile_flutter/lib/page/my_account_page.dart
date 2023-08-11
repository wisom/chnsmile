import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/student_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/child_card.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_cache/hi_cache.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState
    extends HiBaseTabState<StudentModel, Student, MyAccountPage> {
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("我的孩子"),
        body: LoadingContainer(
            isLoading: false,
            isEmpty: isEmpty,
            emptyString: '没有设置小孩',
            onRefreshClick: onRefreshClick,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  @override
  get contentChild => dataList != null ? ListView.builder(
          itemCount: dataList?.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => ChildCard(
              isOneChild: dataList?.length == 0 || dataList?.length == 1,
              item: dataList[index])) : Container();

  @override
  Future<StudentModel> getData(int pageIndex) async {
    isLoaded = true;
    EasyLoading.show(status: '加载中...');
    try {
      StudentModel result = await ProfileDao.getStudent(
          HiCache.getInstance().get(HiConstant.spUserAccount));
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<Student> parseList(StudentModel result) {
    return result != null ? result.list : [];
  }
}
