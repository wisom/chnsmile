import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/class_transfer_dao.dart';
import 'package:chnsmile_flutter/model/class_transfer_model1.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/class_transfer/class_transfer_card1.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class ClassTransferPage extends StatefulWidget {
  final Map params;

  ClassTransferPage({Key key, this.params}) : super(key: key);

  @override
  _ClassTransferPageState createState() => _ClassTransferPageState();
}

class _ClassTransferPageState extends HiBaseTabState<ClassTransferModel1,
    ClassTransfer, ClassTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isLoading: isLoading,
            isEmpty: isEmpty,
            onRefreshClick: onRefreshClick,
            child: Column(children: [
              _buildTop(),
              Expanded(child: super.build(context))
            ])));
  }

  _buildNavigationBar() {
    return appBar("调课计划");
  }

  /// 进入详情
  void _onCellClick(ClassTransfer item) {
    BoostNavigator.instance
        .push('class_transfer_detail_page', arguments: {"id": item.id});
  }

  _buildTip(String tip) {
    return Text(tip,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, color: Colors.black));
  }

  _buildTop() {
    return Container(
      height: 46,
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.only(left: 20),
            child: _buildTip('表单编号'),
          ),
          Expanded(
            flex: 1,
            child: _buildTip('调课原因'),
          ),
          Container(
            width: 100,
            child: _buildTip('建立时间'),
          ),
          Container(
            width: 80,
            child: _buildTip('状态'),
          )
        ],
      ),
    );
  }

  @override
  get contentChild => ListView.builder(
          itemCount: dataList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              ClassTransferCard1(item: dataList[index], onCellClick: _onCellClick,),
        );

  @override
  Future<ClassTransferModel1> getData(int pageIndex) async {
    ClassTransferModel1 result =
        await ClassTransferDao.get(pageIndex: pageIndex, pageSize: 20);
    print(result);
    return result;
  }

  @override
  List<ClassTransfer> parseList(ClassTransferModel1 result) {
    return result.rows;
  }
}
