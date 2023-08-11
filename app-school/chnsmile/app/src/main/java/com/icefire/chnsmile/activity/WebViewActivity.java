package com.icefire.chnsmile.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.IntentUtils;
import com.blankj.utilcode.util.LogUtils;
import com.github.lzyzsd.jsbridge.BridgeHandler;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.jsbridge.OpenMediaJSBridge;
import com.icefire.chnsmile.core.jsbridge.OpenNativeJSBridge;
import com.icefire.chnsmile.core.jsbridge.TestJSBridge;
import com.icefire.chnsmile.ui.TitleView;
import com.icefire.chnsmile.uils.SystemUtils;

@Route(path = Constants.SP_WEBVIEW)
public class WebViewActivity extends BaseWebView {
    @Autowired
    String url;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        ARouter.getInstance().inject(this);
        super.onCreate(savedInstanceState);
        initJsBridge();
        if (url.equals(Constants.AGREEMENT) || url.equals(Constants.PERSONAL_POLICY) || url.equals(Constants.THIRD_SDK_INSTRUCTIONS)) {
            mTitleTextView.setRightText("");
        } else {
            mTitleTextView.setOnRightTextClick(new TitleView.RightTextClickCallBack() {
                @Override
                public void onRightClick() {
                    startActivity(SystemUtils.getShareTextIntent(url));
                }
            });
        }
    }

    // 注册jsbridge
    private void initJsBridge() {
        new TestJSBridge().registHandler(mBridgeWebView);
        new OpenMediaJSBridge().registHandler(mBridgeWebView);
        new OpenNativeJSBridge().registHandler(mBridgeWebView);
    }

    @Override
    public String getUrl() {
        return url;
    }
}
