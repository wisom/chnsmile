import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/document_dao.dart';
import 'package:chnsmile_flutter/model/document_model.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/document_approve_card.dart';
import 'package:chnsmile_flutter/widget/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DocumentTabPage extends StatefulWidget {
  String type;

  DocumentTabPage({Key key, String type}) : super(key: key) {
    if (type == '收到通知') {
      this.type = '3';
    } else if (type == '公文审批') {
      this.type = '2';
    } else {
      this.type = '1';
    }
  }

  @override
  _DocumentTabPageState createState() =>
      _DocumentTabPageState();
}

class _DocumentTabPageState extends OABaseTabState<
    DocumentModel, Document, DocumentTabPage> {
  var isLoaded = false;

  /// 公文发起
  bool get isSend {
    return widget.type == "1";
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => isSend
              ? DocumentCard(
                  item: dataList[index], onCellClick: _onCellClick)
              : DocumentApproveCard(
                  item: dataList[index],
                  type: widget.type,
                  onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(Document item) {
    if (getEditStatus(item.status)) {
      BoostNavigator.instance.push('document_add_page',
          arguments: {"id": item.id});
    } else {
      BoostNavigator.instance.push('official_document_detail_page',
          arguments: {"id": item.id, "type": widget.type, "reviewStatus" : item.reviewStatus});
    }
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.formId == event.formId) {
            print("命中了....."+element.formId);
            element.reviewStatus = 2;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {
    if (widget.type != '3') {
      super.onPageShow();
    }
  }

  @override
  Future<DocumentModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      DocumentModel result = await DocumentDao.get(type: widget.type,
          pageIndex: pageIndex, pageSize: 10);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return null;
    }
  }

  @override
  List<Document> parseList(DocumentModel result) {
    return result.list;
  }
}
