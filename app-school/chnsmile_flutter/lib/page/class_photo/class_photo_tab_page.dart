import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/class_photo_dao.dart';
import '../../model/class_photo_model.dart';
import 'class_photo_card.dart';

class ClassPhotoTabPage extends StatefulWidget {
  final String type; //列表类型 1.我的；2.全部

  const ClassPhotoTabPage({Key key, this.type}) : super(key: key);

  @override
  _ClassPhotoTabPageState createState() => _ClassPhotoTabPageState();
}

class _ClassPhotoTabPageState
    extends OABaseTabState<ClassPhotoModel, ClassPhoto, ClassPhotoTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    // eventBus.on<EventNotice>().listen((event) {
    //   setState(() {
    //     dataList.forEach((element) {
    //       if (element.id == event.formId) {
    //         print("命中了....."+element.id);
    //         element.releaseStatus = 1;
    //       }
    //     });
    //   });
    // });
  }

  @override
  void onPageShow() {
    // if (widget.type == '1') {
    //
    // } else {
    //   super.onPageShow();
    // }
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? widget.type == "1"
          ? ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 10),
              itemCount: dataList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) =>
                  isEmpty(widget.type)
                      ? ClassPhotoCard(
                          item: dataList[index],
                          type: widget.type,
                          onCellClick: _onCellClick)
                      : ClassPhotoCard(
                          item: dataList[index],
                          type: widget.type,
                          onCellClick: _onCellClick))
          : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: _items(dataList),
            )
      : isLoaded
          ? Container()
          : EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            });

  /// 进入详情
  void _onCellClick(ClassPhoto item) {
    BoostNavigator.instance.push('fund_detail_page',
        arguments: {"item": item, "type": widget.type});

    // if (getEditStatus(item.releaseStatus)) {
    //   BoostNavigator.instance.push('info_collection_add_page',
    //       arguments: {"id": item.id});
    // } else {
    //   BoostNavigator.instance
    //       .push(
    //       'fund_manager_detail_page', arguments: {"item": item, "type": widget.type, "reviewStatus": item.releaseStatus});
    // }
  }

  @override
  Future<ClassPhotoModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      var result = await ClassPhotoDao.list(1, widget.type);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      isLoaded = false;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  // read() async {
  //   try {
  //     EasyLoading.show(status: '加载中...');
  //     Map<String, dynamic> params = {};
  //     params['pageNo'] = 1;
  //     params['pageSize'] = 10;
  //     params['listType'] = 1;
  //     var result = await FundManagerDao.approve(params);
  //     return result
  //     // PlatformMethod.sentTriggerUnreadToNative();
  //     // var bus = EventNotice();
  //     // bus.formId = widget.repair.formId;
  //     // eventBus.fire(bus);
  //     EasyLoading.dismiss(animation: false);
  //   } catch (e) {
  //     EasyLoading.dismiss(animation: false);
  //     // showWarnToast(e.message);
  //   }
  // }

  @override
  List<ClassPhoto> parseList(ClassPhotoModel result) {
    return result.list;
  }

  List<Widget> _items(List<ClassPhoto> items) {
    return items.map((ClassPhoto item) {
      return GestureDetector(
          onTap: () {
            BoostNavigator.instance
                .push("class_album_detail_page", arguments: {"id": item.id});
          },
          child: Container(
            decoration: const BoxDecoration(color: HiColor.color_F7F7F7),
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.white),
              child: Column(
                children: [
                  Image.network(
                      "https://img0.baidu.com/it/u=3425868493,3104015061&fm=253&fmt=auto&app=120&f=JPEG?w=1199&h=800"),
                  hiSpace(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Text(
                          item.albumName ?? "",
                          style: const TextStyle(
                              fontSize: 12, color: HiColor.color_181717),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            (item.count ?? 0).toString(),
                            style: const TextStyle(
                                fontSize: 12, color: HiColor.color_181717),
                          ))
                    ],
                  ),
                  hiSpace(height: 8),
                ],
              ),
            ),
          ));
    }).toList();
  }
}
