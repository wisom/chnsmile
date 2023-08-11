import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/contact_dao.dart';
import 'package:chnsmile_flutter/model/contact_model.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/contact_card.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactTabPage extends StatefulWidget {
  final Map params;

  const ContactTabPage({Key key, this.params}) : super(key: key);

  @override
  _ContactTabPageState createState() => _ContactTabPageState();
}

class _ContactTabPageState
    extends HiBaseTabState<ContactModel, Contact, ContactTabPage> {

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
  Widget build(BuildContext context) {
    return LoadingContainer(
        isEmpty: isEmpty,
        isLoading: false,
        child: Column(children: [Expanded(child: super.build(context))]));

  }

  _buildNavigationBar() {
    bool showBackButton = true;
    try {
      if (widget.params["isFromNative"]) {
        showBackButton = false;
      }
    } catch (e) {
      print(e);
    }
    return appBar("通讯录", showBackButton: showBackButton);
  }

  @override
  get contentChild => ListView.builder(
      itemCount: dataList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) =>
          ContactCard(item: dataList[index]));

  @override
  Future<ContactModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      ContactModel result = await ContactDao.get();
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      return null;
    }
  }

  @override
  List<Contact> parseList(ContactModel result) {
    return result.list;
  }
}
