import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/profile_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/profile_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_cache/hi_cache.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;

  const ProfilePage({Key key, this.studentId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends HiState<ProfilePage>
    with SingleTickerProviderStateMixin, PageVisibilityObserver {
  ProfileModel profileModel;
  bool loading = false;

  var childList;
  var stateList = [true, false];

  @override
  void onPageHide() {
    super.onPageHide();
    print("ProfilePage - onPageHide");
  }

  @override
  void onPageShow() {
    super.onPageShow();
    print("ProfilePage - onPageShow");
    _loadData(false);
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   _loadData(false);
    // });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  bool get isFamily {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "1";
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  @override
  void initState() {
    super.initState();

    childList = const [Text('家长', style: TextStyle(fontSize: 15)), Text('孩子', style: TextStyle(fontSize: 15))];
  }

  @override
  void dispose() {
    ///移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("个人信息"),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          onRefresh: loadData,
          color: primary,
          child: ListView(
            children: [
              isFamily ? _tabBar() : Container(),
              _buildContent()
            ],
          ))
    );
  }

  _tabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: ToggleButtons(
          constraints:const BoxConstraints(minWidth: 140, minHeight: 34),
          borderWidth: 1,
          borderColor: primary,
          fillColor: primary,
          selectedColor: Colors.white,
          color: primary,
          selectedBorderColor: primary,
          disabledBorderColor: primary,
          borderRadius: BorderRadius.circular(6),
          onPressed: (selectedIndex) {
            setState(() {
              for (int i = 0; i < stateList.length; i++) {
                stateList[i] = false;
                if (selectedIndex == i) {
                  stateList[selectedIndex] = !stateList[selectedIndex];
                }
              }
            });
          },
          children: childList, isSelected: stateList),
    );
  }

  _buildContent() {
    if (profileModel == null) return Container();
    return stateList[0] ?
      ProfileTabPage(type: 1, profileModel: profileModel, callback: () {
        _loadData(false);
      }) :
    ProfileTabPage(type: 3, profileModel: profileModel, callback: () {
      _loadData(false);
    });
  }


  Future<void> loadData() {
    return _loadData(true);
  }

  Future<void> _loadData(bool isPull) async {
    if (loading) {
      print("上次加载还没完成...");
      return;
    }
    loading = true;

    if (!isPull) {
      EasyLoading.show(status: '加载中...');
    }
    try {
      ProfileModel result = await ProfileDao.get();
      print(result);
      setState(() {
        profileModel = result;
      });
      loading = false;
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   loading = false;
      // });
      EasyLoading.dismiss(animation: false);
    } on HiNetError catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
      setState(() {
        loading = false;
      });
    }
  }
}
