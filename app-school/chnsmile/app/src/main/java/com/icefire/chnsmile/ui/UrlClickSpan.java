package com.icefire.chnsmile.ui;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.text.TextPaint;
import android.text.style.ClickableSpan;
import android.view.View;

import com.blankj.utilcode.util.ActivityUtils;
import com.blankj.utilcode.util.ColorUtils;
import com.blankj.utilcode.util.Utils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.activity.LoginActivity;
import com.icefire.chnsmile.activity.WebViewActivity;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;

public class UrlClickSpan extends ClickableSpan {

    private long clickTime;
    private String url;

    public UrlClickSpan(String url) {
        this.url = url;
    }


    @Override
    public void updateDrawState(TextPaint ds) {
        ds.setColor(ColorUtils.getColor(R.color.ui_brand_color));
        ds.bgColor = Color.parseColor("#FFFFFF");
    }

    @Override
    public void onClick(View widget) {
        //点击打开协议url
        //唤起外部浏览器 打开协议页面
        long timeDiff = System.currentTimeMillis() - clickTime;
        if (timeDiff < 400) {
            //如果两次点击的时间少于400毫秒，不让多次触发
            return;
        }

        clickTime = System.currentTimeMillis();

        Router.open("smile://" + Constants.SP_WEBVIEW + "?url=" + url);

//        try {
//            Uri uri = Uri.parse(url);
//            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            Utils.getApp().startActivity(intent);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}
