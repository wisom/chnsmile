import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/wx_login_dao.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

import '../../core/hi_oa_state.dart';
import '../../widget/appbar.dart';
import '../constant/hi_constant.dart';
import '../model/wxunbind_list_model.dart';
import '../utils/view_util.dart';

class WxUnbindPage2 extends StatefulWidget {
  final Map params;
  String TAG = "WxUnbindPage2";

  WxUnbindPage2({Key key, this.params}) : super(key: key) {}

  @override
  _WxUnbindPageState createState() => _WxUnbindPageState();
}

class _WxUnbindPageState extends HiOAState<WxUnbindPage2> {
  var isLoaded = false;
  WxInfoModel model;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void onPageShow() {}

  Future<WxInfoModel> getData() async {
    EasyLoading.show(status: '加载中...');
    isLoaded = true;
    try {
      String account = HiCache.getInstance().get(HiConstant.spUserAccount);
      LogUtil.d(widget.TAG, "WxLoginDao.list= account=" + account);
      var result = await WxLoginDao.list(account);
      LogUtil.d(widget.TAG, "result=" + result.toString());
      setState(() {
        model = result;
      });

      EasyLoading.dismiss(animation: false);
      isLoaded = false;
      return result;
    } catch (e) {
      showToast("WxLoginDao e=" + e.toString());
      LogUtil.d(widget.TAG, "WxLoginDao e=" + e.toString());
      isLoaded = false;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("微信解绑"),
      body: Container(
        color: Colors.white,
        child: _buildList(),
      ),
    );
  }

  _buildList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model?.list?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    LogUtil.d(widget.TAG,
                        "toJson=" + model?.list[index]?.toJson().toString());
                    BoostNavigator.instance.push('wxunbind_detail_page',
                        arguments: model?.list[index]?.toJson());
                  },
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 59,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "微信",
                          style: TextStyle(
                            fontSize: 16,
                            color: HiColor.color_black_A60,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              model?.list[index]?.nickname ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: HiColor.color_black_A25,
                              ),
                            ),
                            hiSpace(width: 18),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: HiColor.color_black_A25,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                line(context)
              ],
            ),
          );
        });
  }
}
