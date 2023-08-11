import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/core/platform_response.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/model/home_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/hi_banner.dart';
import 'package:chnsmile_flutter/widget/home_work/home_intro_card.dart';
import 'package:chnsmile_flutter/widget/item_tag.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';

import '../proxy.dart';

class HomePage extends StatefulWidget {
  final Map params;

  const HomePage({Key key, this.params}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage> {
  List<BannerModel> bannerList = [];
  List<CategoryModel> categoryList = [];
  SchoolProfile schoolProfile;
  String campusInfoBackImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    saveData();
  }

  void saveData() {
    print("token: ${widget.params['token']}");
    HiCache.preInit().then((value) {
      String token = pToken;
      if (widget.params['isFromNative'] && isNotEmpty(widget.params['token'])) {
        token = widget.params['token'];
      }
      HiCache.getInstance().setString(HiConstant.spToken, token);
      loadData();
    });
  }

  Future<String> getUA() async {
    PlatformResponse response = await PlatformMethod.getUserAgent();
    if (response == null || response.data == null) {
      return 'Chimse/1.0.0';
    }
    Map ua = response.mapData();
    var result =
        '${ua['model']}/${ua['appType']}_${ua['appVersion']}_${ua['appCode']}';
    return result;
  }

  Future<String> getUserInfo() async {
    print("getUserInfo==== start=");
    PlatformResponse response = await PlatformMethod.getUserInfo();
    if (response == null || response.data == null) {
      HiCache.getInstance().setString(HiConstant.spUserId, pUserId);
      HiCache.getInstance().setString(HiConstant.spStudentId, pStudentId);
      HiCache.getInstance().setString(HiConstant.spUserName, pUserName);
      HiCache.getInstance().setString(HiConstant.spUserAccount, pUserAccount);
      HiCache.getInstance().setString(HiConstant.spIdentity, pIdentity);
      return 'empty';
    }
    Map ua = response.mapData();
    print("ua['baseUrl']: ${ua['baseUrl']}");
    print("ua['lastChildId']: ${ua['lastChildId']}");
    HiConstant.baseUrl = ua['baseUrl'];
    HiCache.getInstance().setString(HiConstant.spUserId, ua['id']);
    HiCache.getInstance()
        .setString(HiConstant.spStudentId, ua['lastChildId'] ?? '');
    HiCache.getInstance().setString(HiConstant.spUserName, ua['name']);
    HiCache.getInstance().setString(HiConstant.spUserAccount, ua['account']);
    HiCache.getInstance()
        .setString(HiConstant.spIdentity, ua['defaultIdentity'].toString());
    print("getUserInfo==== end=");
    return ua.toString();
  }

  Future<String> getWxInfo() async {
    print("getWxInfo==== start=");
    PlatformResponse response = await PlatformMethod.getWxInfo();
    print("getWxInfo==== response="+response.toString());
    if (response != null) {
      Map ua = response.mapData();
      if (ua.containsKey("nickname")) {
        HiCache.getInstance()
            .setString(HiConstant.spWxNickName, ua['nickname']);
      }
      if (ua.containsKey("headimgurl")) {
        HiCache.getInstance()
            .setString(HiConstant.spWxHeadimgurl, ua['headimgurl'] ?? '');
      }
      return ua.toString();
    }
    return "";
  }

  logout() async {
    PlatformResponse response = await PlatformMethod.logout();
    print("data: ${response.data}");
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      getUserInfo();
      getWxInfo();
      String ua = await getUA();
      HiCache.getInstance().setString(HiConstant.spUserAgent, ua);
      HomeModel result = await HomeDao.get();
      print('loadData():$result');
      EasyLoading.dismiss(animation: false);
      setState(() {
        bannerList = result.bannerList ?? [];
        categoryList = result.categoryList ?? [];
        schoolProfile = result.schoolProfile;
        campusInfoBackImage = result.campusInfoBackImage;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
          child: ListView(
            children: [
              _banner(bannerList),
              HomeIntroCard(schoolProfile),
              _bottomBanner(categoryList),
            ],
          ),
          onRefresh: loadData),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      leadingWidth: 90,
      title: const Text("学校风采", style: TextStyle(fontSize: 22)),
    );
  }

  _buildBody() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        _banner(bannerList),
        HomeIntroCard(schoolProfile),
        _bottomBanner(categoryList),
      ],
    );
  }

  _banner(List<BannerModel> bannerList) {
    double height = Utils.width * (6 / 11);
    if (bannerList.isEmpty) {
      return Container(height: height);
    }
    return HiBanner(
      bannerList,
      bannerHeight: height,
    );
  }

  _bottomBanner(List<CategoryModel> categoryList) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                width: 6,
                height: 26,
                decoration: const BoxDecoration(color: primary),
              ),
              hiSpace(width: 10),
              const Text('美丽校园', style: TextStyle(color: primary, fontSize: 18))
            ],
          ),
          hiSpace(height: 10),
          Container(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => ItemTag(
                      url: categoryList[index].pageUrl,
                      image: categoryList[index].topImg,
                      title: categoryList[index].title)),
            ),
          ),
          hiSpace(height: 20),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                width: 6,
                height: 26,
                decoration: const BoxDecoration(color: primary),
              ),
              hiSpace(width: 10),
              const Text('校园资讯', style: TextStyle(color: primary, fontSize: 18))
            ],
          ),
          hiSpace(height: 10),
          InkWell(
              onTap: () {
                BoostNavigator.instance.push('news_page',
                    withContainer: widget.params['isFromNative'] ? true : false,
                    arguments: {
                      "title": "校园资讯",
                      "schoolId": "1000",
                    });
              },
              child: Container(
                  width: Utils.width,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: cachedImage(campusInfoBackImage),
                  ))),
        ],
      ),
    );
  }
}
