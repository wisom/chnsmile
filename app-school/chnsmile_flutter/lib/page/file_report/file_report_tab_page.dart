import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/document_dao.dart';
import 'package:chnsmile_flutter/model/document_model.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/file_report_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/document_approve_card.dart';
import 'package:chnsmile_flutter/widget/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../http/dao/file_report_dao.dart';
import 'file_report_approve_card.dart';
import 'file_report_card.dart';

class FileReportTabPage extends StatefulWidget {
  String type;

  FileReportTabPage({Key key, String type}) : super(key: key) {
    if (type == '我的通知') {
      this.type = '3';
    } else if (type == '文件审批') {
      this.type = '2';
    } else {
      this.type = '1';
    }
  }

  @override
  _FileReportTabPageState createState() => _FileReportTabPageState();
}

class _FileReportTabPageState extends OABaseTabState<
    FileReportModel, FileReport, FileReportTabPage> {
  var isLoaded = false;

  /// 文件发起
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
              ? FileReportCard(
                  item: dataList[index], onCellClick: _onCellClick)
              : FileReportApproveCard(
                  item: dataList[index],
                  type: widget.type,
                  onCellClick: _onCellClick))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  /// 进入详情
  void _onCellClick(FileReport item) {
    if (getEditStatus(item.status)) {
      BoostNavigator.instance.push('file_report_add_page',
          arguments: {"id": item.id,"formId":item.formId});
    } else {
      BoostNavigator.instance.push('file_report_detail_page',
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
  Future<FileReportModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      FileReportModel result = await FileReportDao.get(type: widget.type,
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
  List<FileReport> parseList(FileReportModel result) {
    return result.list;
  }
}
