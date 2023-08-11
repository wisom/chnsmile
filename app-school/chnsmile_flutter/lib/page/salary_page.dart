import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/salary_dao.dart';
import 'package:chnsmile_flutter/model/salary_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/salary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_cache/hi_cache.dart';

class SalaryPage extends StatefulWidget {
  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends HiBaseTabState<SalaryModel, Salary, SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: false,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    return appBar("工资",
        rightTitle: HiCache.getInstance().get(HiConstant.spUserName),
        rightButtonClick: onAddClick());
  }

  onAddClick() {}

  @override
  get contentChild => ListView.builder(
        itemCount: dataList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) =>
            SalaryCard(salary: dataList[index]),
      );

  @override
  Future<SalaryModel> getData(int pageIndex) async {
    try {
      EasyLoading.show(status: '加载中...');
      SalaryModel result = await SalaryDao.get(
          pageIndex: pageIndex, pageSize: 20);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<Salary> parseList(SalaryModel result) {
    return result.rows;
  }
}
