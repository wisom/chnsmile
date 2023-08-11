package com.icefire.chnsmile.wxapi;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.icefire.chnsmile.MainApplication;
import com.icefire.chnsmile.event.GetWxCodeEvent;
import com.icefire.chnsmile.uils.WXUtil;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;

import org.greenrobot.eventbus.EventBus;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    public static final String TAG = "WXEntryActivity";
    private static final int RETURN_MSG_TYPE_LOGIN = 1;
    private static final int RETURN_MSG_TYPE_SHARE = 2;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MainApplication.getInstance().getWxApi().handleIntent(getIntent(), this);
    }

    @Override
    public void onReq(BaseReq baseReq) {
        Log.d(TAG, "== 微信回调 onReq ==");
        finish();
    }

    @Override
    public void onResp(BaseResp resp) {
        String msg = "";

        switch (resp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
                msg = "用户同意";
                switch (resp.getType()) {
                    case RETURN_MSG_TYPE_LOGIN:
                        //拿到了微信返回的code,立马再去请求access_token
                        String code = ((SendAuth.Resp) resp).code;
                        Log.d(WXUtil.TAG_WX_LOGIN, "登录授权 用户同意 code=" + code);
//                        Intent intent = new Intent(WXUtil.WX_CODE_ACTION);
//                        intent.putExtra(WXUtil.EXTRA_WX_CODE, code);
//                        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                        EventBus.getDefault().post(new GetWxCodeEvent(code));
                        finish();
                        return;
                    case RETURN_MSG_TYPE_SHARE:
                        break;
                    default:
                        break;
                }
                break;
            case BaseResp.ErrCode.ERR_USER_CANCEL:
                msg = "用户取消";
                Log.d(WXUtil.TAG_WX_LOGIN, "登录授权 用户取消");
                break;
            case BaseResp.ErrCode.ERR_AUTH_DENIED:
                msg = "用户拒绝授权";
                Log.d(WXUtil.TAG_WX_LOGIN, "登录授权 用户拒绝授权");
                break;
            default:
                msg = "发送返回";
                Log.d(WXUtil.TAG_WX_LOGIN, "登录授权 发送返回");
                break;
        }
        Intent intent = new Intent(WXUtil.WX_CODE_ACTION);
        intent.putExtra(WXUtil.EXTRA_WX_CODE, "404");
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        finish();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        MainApplication.getInstance().getWxApi().handleIntent(getIntent(), this);
    }

    @org.jetbrains.annotations.Nullable
    public Integer getContentViewId() {
        return null;
    }
}
