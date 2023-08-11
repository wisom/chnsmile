import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

///通用底层带分页和刷新的页面框架
///M为Dao返回数据模型，L为列表数据模型，T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  bool isEmpty = false;
  bool isNeedLoadMore = true;

  @override
  void initState() {
    super.initState();
    if (isNeedLoadMore) {
      scrollController.addListener(() {
        var dis = scrollController.position.maxScrollExtent -
            scrollController.position.pixels;
        //当距离底部不足300时加载更多
        if (dis < 300 &&
            !loading &&
            //fix 当列表高度不满屏幕高度时不执行加载更多
            scrollController.position.maxScrollExtent != 0) {
          print('------_loadData---');
          if (isNeedLoadMore) {
            loadData(loadMore: true);
          }
        }
      });
    }
    loadData();
  }

  void needLoadMore(bool loadMore) {
    isNeedLoadMore = loadMore;
  }

  onRefreshClick() {
    loadData(loadMore: false);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        onRefresh: loadData,
        color: primary,
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Container(
              color: Colors.white,
              child: contentChild,
            )));
  }

  ///获取对应页码的数据
  Future<M> getData(int pageIndex);

  ///从MO中解析出list数据
  List<L> parseList(M result);

  ///获取当前widget
  get contentChild;

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print("上次加载还没完成...");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');
    try {
      var result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          //合成一个新数组
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).length != 0) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
        if (dataList != null && dataList.isNotEmpty) {
          isEmpty = false;
        } else {
          isEmpty = true;
        }
      });
      isLoading = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      setState(() {
        loading = false;
        isLoading = false;
        isEmpty = true;
      });

      print(e);
    } on HiNetError catch (e) {
      setState(() {
        loading = false;
        isLoading = false;
        isEmpty = true;
      });
      print(e);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
