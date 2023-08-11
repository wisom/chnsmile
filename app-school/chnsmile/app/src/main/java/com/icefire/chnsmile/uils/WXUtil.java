package com.icefire.chnsmile.uils;

import android.util.Log;
import android.widget.Toast;

import com.icefire.chnsmile.MainApplication;
import com.tencent.mm.opensdk.modelmsg.SendAuth;

public class WXUtil {

    public static String TAG_WX_LOGIN = "tag_wx_login";
    public static String TAG_ALIPAY_LOGIN = "tag_alipay_login";
    public static String WX_CODE_ACTION = "wx_code_action";
    public static String EXTRA_WX_CODE = "extra_wx_code";

    public static void sendAuth() {
        if (!MainApplication.getInstance().getWxApi().isWXAppInstalled()) {
            Toast.makeText(MainApplication.context,"请安装微信客户端",Toast.LENGTH_LONG).show();
            return;
        }
        Log.d(TAG_WX_LOGIN, "微信登录 拉起微信");
        SendAuth.Req req = new SendAuth.Req();
        req.scope = "snsapi_userinfo";
        req.state = "wechat_sdk_demo_test";
        MainApplication.getInstance().getWxApi().sendReq(req);
    }
}
