import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/notice_dao.dart';
import 'package:chnsmile_flutter/model/notice_read_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/confirm_alert.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_notice_read_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';

class TeacherNoticeReadTabPage extends StatefulWidget {
  String id;
  String classId;
  String typeText;
  int type;
  int status;

  TeacherNoticeReadTabPage({Key key, this.id, this.classId, this.type, this.typeText, this.status})
      : super(key: key);

  @override
  _TeacherNoticeReadTabPageState createState() =>
      _TeacherNoticeReadTabPageState();
}

class _TeacherNoticeReadTabPageState
    extends OABaseTabState<NoticeReadModel, Read, TeacherNoticeReadTabPage> {
  var isLoaded = false;

  @override
  void initState() {
    needLoadMore(false);
    super.initState();
  }

  bool get isRevoke {
    return widget.status == 3;
  }

  @override
  get contentChild => dataList.isNotEmpty
      ? Column(
          children: [
            Expanded(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: dataList.length,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) =>
                        TeacherNoticeReadCard(item: dataList[index]))),
            !isRevoke ? _buildUnRead() : Container()
          ],
        )
      : isLoaded
          ? Container()
          : EmptyView();

  _buildUnRead() {
    return widget.type == 1 ? InkWell(
        onTap: showRemindDialog,
        child: Container(
          alignment: Alignment.center,
          height: 46,
          color: Colors.grey[200],
          child: Text('提醒未${widget.typeText}家长',
              style: const TextStyle(fontSize: 15, color: primary)),
        )) : Container();
  }

  void showRemindDialog() {
    confirmAlert(
      context,
          (bool) {
        if (bool) {
          remind();
        }
      },
      tips: '将再次发送此通知，提醒未${widget.typeText}家长？',
      okBtn: '发送',
      isWarm: false,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  remind() async {
    try {
      EasyLoading.show(status: '加载中...');
      Map<String, dynamic> params = {};
      params['id'] = widget.id;

      var result = await NoticeDao.teacherRemind(params);
      showWarnToast('已提醒');
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }

  @override
  Future<NoticeReadModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    NoticeReadModel result =
        await NoticeDao.readList(widget.id, widget.classId);
    EasyLoading.dismiss(animation: false);
    isLoaded = false;
    return result;
  }

  @override
  List<Read> parseList(NoticeReadModel result) {
    return widget.type == 0 ? result.readList : result.unReadList;
  }
}
