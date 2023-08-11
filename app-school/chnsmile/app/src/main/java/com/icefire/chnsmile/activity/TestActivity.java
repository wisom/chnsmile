package com.icefire.chnsmile.activity;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;

@Route(path = "/sp/test")
public class TestActivity extends BaseActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);

        findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Router.open("smile://" + Constants.SP_PICTURE + "?url=https://t7.baidu.com%2Fit%2Fu%3D2077212613%2C1695106851%26fm%3D193%26f%3DGIF");
            }
        });
        findViewById(R.id.button2).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Router.open("smile://" + Constants.SP_VIDEO + "?url=https://vd4.bdstatic.com//mda-na44qhn9bcb0jvw3//cae_h264//1641355090850420063//mda-na44qhn9bcb0jvw3.mp4%3Fv_from_s%3Dhkapp-haokan-suzhou%26auth_key%3D1641905042-0-0-04da2a11cce9a4e2621803cc71f945fe%26bcevod_channel%3Dsearchbox_feed%26pd%3D1%26vt%3D1%26cd%3D0%26watermark%3D0%26did%3D%26logid%3D0842444964%26vid%3D4399913349580711775%26pt%3D0%26appver%3D%26model%3D%26cr%3D0%26abtest%3Dpeav_l52%26sle%3D1%26sl%3D510%26split%3D447628");
            }
        });
        findViewById(R.id.button3).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = "file:///android_asset/demo.html";
                Router.open("smile://" + Constants.SP_WEBVIEW + "?url=" + url);
            }
        });
        findViewById(R.id.button4).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = "https://11lang.oss-cn-hangzhou.aliyuncs.com/wxxcx/xue.xlsx";
                Router.open("smile://" + Constants.SP_ATTACHMENT + "?url=" + url);
            }
        });
    }
}
