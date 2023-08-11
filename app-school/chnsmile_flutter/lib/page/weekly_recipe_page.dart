import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/weekly_recipe_dao.dart';
import 'package:chnsmile_flutter/model/weekly_recipe_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/weekly_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WeeklyRecipePage extends StatefulWidget {
  @override
  _WeeklyRecipePageState createState() => _WeeklyRecipePageState();
}

class _WeeklyRecipePageState
    extends HiBaseTabState<WeeklyRecipeModel, WeeklyRecipe, WeeklyRecipePage> {
  var isLoaded = false;

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
    return appBar("每周食谱");
  }

  /// 进入详情
  void _onCellClick(WeeklyRecipe weeklyRecipe) {
    BoostNavigator.instance.push(HiConstant.webview + weeklyRecipe.pageUrl);
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          itemCount: dataList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => WeeklyRecipeCard(
              onCellClick: _onCellClick, weeklyRecipe: dataList[index]),
        )
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  @override
  Future<WeeklyRecipeModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      WeeklyRecipeModel result =
          await WeeklyRecipeDao.get(pageIndex: pageIndex, pageSize: 20);
      print(result);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<WeeklyRecipe> parseList(WeeklyRecipeModel result) {
    return result.list;
  }
}
