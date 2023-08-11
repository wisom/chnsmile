import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../core/platform_method.dart';
import '../flutter_sound/public/util/LogUtil.dart';
import '../utils/common.dart';

class WxUnbindDetailPage extends StatelessWidget {
  final Map<String,dynamic> params;
  String openId;
  String headimgurl;
  String nickname;
  String TAG="WxUnbindDetailPage==";

  WxUnbindDetailPage({Key key, this.params}) : super(key: key) {
    LogUtil.d(TAG,"params="+params.toString());
    openId = (params.isNotEmpty && params.containsKey("openid"))
        ? params['openid']
        : "";
    headimgurl = (params.isNotEmpty && params.containsKey("headimgurl"))
        ? params['headimgurl']
        : "";
    nickname = (params.isNotEmpty && params.containsKey("nickname"))
        ? params['nickname']
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("微信解绑", rightTitle: "解绑", rightButtonClick: () {
        _showConfirmDialog(context);
      }),
      body: Container(
        color: Colors.white,
        child: _buildContent(),
      ),
    );
  }

  _showConfirmDialog(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    List<String> list = ['解绑微信'];
    showListDialog(context, title: '确认解绑微信吗？', list: list,
        onItemClick: (String type, int index) {
      if (index == 0) {
        wxUnbind(openId);
      }
    });
  }

  Future<void> wxUnbind(String openId) async {
    LogUtil.d(TAG, "wxUnbind openId="+openId);
    await PlatformMethod.WxUnBind(openId ?? "");
  }

  _buildContent() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          hiSpace(height: 100),
          ClipOval(
              child: Image.network(
            headimgurl ?? "",
            width: 102,
            height: 102,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stackTrace) => ClipOval(
                child: Image.asset('images/ic_wechat_logo_big.png', //默认显示图片
                    height: 102,
                    width: 102)),
          )),
          hiSpace(height: 40),
          Text(
            "绑定微信：${nickname ?? ""}",
            style: TextStyle(
                fontSize: 16,
                color: HiColor.color_181717,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
