import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/news_dao.dart';
import 'package:chnsmile_flutter/model/news_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:chnsmile_flutter/widget/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/string_util.dart' as str;

class NewsPage extends StatefulWidget {
  final Map params;
  int type = 0;

  NewsPage({Key key, this.params}) : super(key: key) {
    type = params["title"] != null ? 1 : 0;
  }

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends HiBaseTabState<NewsModel, News, NewsPage> {
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildNavigationBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: false,
            onRefreshClick: onRefreshClick,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildNavigationBar() {
    bool showBackButton = false;
    if (widget.params["title"] != null) {
      showBackButton = true;
    }
    try {
      if (widget.params["isFromNative"]) {
        showBackButton = false;
      }
    } catch (e) {
      print(e);
    }
    return appBar(str.isNotEmpty(widget.params["title"]) ? widget.params["title"] :"专家论坛",
        showBackButton: showBackButton);
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          itemCount: dataList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              NewsCard(news: dataList[index]))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  @override
  Future<NewsModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      NewsModel result = await NewsDao.newsList(
          type: widget.type, pageIndex: pageIndex, pageSize: 20);
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
  List<News> parseList(NewsModel result) {
    return result != null ? result.rows : [];
  }
}
