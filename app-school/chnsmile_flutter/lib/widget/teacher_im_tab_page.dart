import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_im_model.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/teacher_im_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherIMTabPage extends StatefulWidget {
  final String type;

  const TeacherIMTabPage({Key key, this.type}) : super(key: key);

  @override
  _TeacherIMTabPageState createState() => _TeacherIMTabPageState();
}

class _TeacherIMTabPageState
    extends OABaseTabState<ContactIMModel, ContactIM, TeacherIMTabPage> {
  var isLoaded = false;
  VoidCallback imListener;

  @override
  void initState() {
    isNeedLoadMore = false;
    super.initState();

    imListener = BoostChannel.instance.addEventListener("triggerIM", (key, arguments) {
      loadData();
      return;
    });
  }

  @override
  void dispose() {
    super.dispose();
    imListener.call();
  }


  @override
  get contentChild => dataList.isNotEmpty
      ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) =>
              TeacherIMCard(item: dataList[index]))
      : isLoaded ? Container() : EmptyView(onRefreshClick: () {
          loadData(loadMore: false);
        });

  @override
  Future<ContactIMModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      isLoaded = true;
      ContactIMModel result =
          await ContactDao.getTeacher(type: widget.type);
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return null;
    }
  }

  @override
  List<ContactIM> parseList(ContactIMModel result) {
    return result.list;
  }
}
