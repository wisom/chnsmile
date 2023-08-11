import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../core/hi_oa_state.dart';
import '../../http/dao/class_photo_dao.dart';
import '../../model/class_photo_dynamic_accessory.dart';
import '../../model/class_photo_dynamic_model.dart';
import '../../model/class_photo_model.dart';
import '../../widget/appbar.dart';
import 'class_photo_dynamic_card.dart';

///班级相册批量管理
class ClassPhotoManagerPage extends StatefulWidget {
  final Map params;
  String id;
  String TAG = "ClassPhotoManagerPage";

  ClassPhotoManagerPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _ClassPhotoManagerPageState createState() => _ClassPhotoManagerPageState();
}

class _ClassPhotoManagerPageState extends HiOAState<ClassPhotoManagerPage> {
  var isLoaded = false;
  ClassPhotoDynamicModel model;

  @override
  void initState() {
    super.initState();
    getData();
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

  // @override
  // get contentChild => dataList.isNotEmpty
  //     ? ListView.builder(
  //         physics: const AlwaysScrollableScrollPhysics(),
  //         padding: const EdgeInsets.only(top: 10),
  //         itemCount: dataList.length,
  //         controller: scrollController,
  //         itemBuilder: (BuildContext context, int index) => isEmpty(widget.id)
  //             ? ClassPhotoDynamicCard(
  //                 item: dataList[index], onCellClick: _onCellClick)
  //             : ClassPhotoDynamicCard(
  //                 item: dataList[index], onCellClick: _onCellClick))
  //     : isLoaded
  //         ? Container()
  //         : EmptyView(onRefreshClick: () {
  //             loadData(loadMore: false);
  //           });

  /// 进入详情
  void _onCellClick(ClassPhotoDynamicAccessory item) {
    BoostNavigator.instance
        .push('fund_detail_page', arguments: {"item": item, "type": widget.id});

    // if (getEditStatus(item.releaseStatus)) {
    //   BoostNavigator.instance.push('info_collection_add_page',
    //       arguments: {"id": item.id});
    // } else {
    //   BoostNavigator.instance
    //       .push(
    //       'fund_manager_detail_page', arguments: {"item": item, "type": widget.type, "reviewStatus": item.releaseStatus});
    // }
  }

  Future<ClassPhotoDynamicModel> getData() async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      LogUtil.d(widget.TAG, "widget.id=" + widget.id);
      var result = await ClassPhotoDao.detail(widget.id);
      LogUtil.d(widget.TAG, "result=" + result.toString());
      setState(() {
        model = result;
      });

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

  // @override
  // List<ClassPhotoDynamic> parseList(ClassPhotoDynamicModel result) {
  //   return result;
  // }

  List<Widget> _items(List<ClassPhoto> items) {
    return items.map((ClassPhoto item) {
      return GestureDetector(
          onTap: () {
            // BoostNavigator.instance.push(item.page,
            //     arguments: {"isFromOA": false},
            //     withContainer: widget.params['isFromNative']);
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

  _buildBody() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: (model?.data?.classAlbumAccessoryList?.length ?? 0) + 1,
        itemBuilder: (BuildContext context, int index) {
          return buildItemWidget(context, index);
        });
  }

// 根据index展示不同的widget
  Widget buildItemWidget(BuildContext context, int index) {
    if (index < 1) {
      return _buildHeaderWidget();
    } else {
      int itemIndex = index - 1;
      return _itemBuildWidget(context, itemIndex);
    }
  }

  Widget _itemBuildWidget(BuildContext context, int index) {
    return Container(
        child: ClassPhotoDynamicCard(
      item: model?.data?.classAlbumAccessoryList[index],
      onCellClick: _onCellClick,
    ));
  }

  Widget _buildHeaderWidget() {
    return _buildBg();
  }

  _buildBg() {
    return Image.network(
      "https://img0.baidu.com/it/u=3425868493,3104015061&fm=253&fmt=auto&app=120&f=JPEG?w=1199&h=800",
      width: double.infinity,
      height: 164,
      fit: BoxFit.cover,
    );
  }

  _buildAppBar() {
    return appBar('批量管理', rightTitle: "新建", rightButtonClick: () async {
      BoostNavigator.instance.push('class_photo_add_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
