package com.icefire.chnsmile.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ScreenUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.ui.FullScreenPlayerView;

@Route(path = Constants.SP_VIDEO)
public class VideoDetailAcitity extends BaseActivity {
    @Autowired
    String url;

    private FullScreenPlayerView playerView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video_detail);
        playerView = findViewById(R.id.player_view);
        LogUtils.i("url: " + url);
        playerView.post(new Runnable() {
            @Override
            public void run() {

                int width = ScreenUtils.getScreenWidth();
                int height = playerView.getHeight();
                playerView.bindData(width, height, "", url);
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();
        playerView.inActive();
    }

    @Override
    protected void onResume() {
        super.onResume();
        playerView.onActive();
    }
}
