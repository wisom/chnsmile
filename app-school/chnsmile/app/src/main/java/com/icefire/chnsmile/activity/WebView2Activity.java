package com.icefire.chnsmile.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.tencent.smtt.sdk.WebView;

@Route(path = Constants.SP_WEBVIEW2)
public class WebView2Activity extends BaseActivity {
    @Autowired
    String url;

    private WebView webView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        ARouter.getInstance().inject(this);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview2);


        webView = findViewById(R.id.webView);
        webView.getSettings().setMixedContentMode(webView.getSettings().getMixedContentMode());
        webView.loadUrl("https://www.baidu.com");
//        webView.showDebugView("http://debugx5.qq.com");
    }



}
