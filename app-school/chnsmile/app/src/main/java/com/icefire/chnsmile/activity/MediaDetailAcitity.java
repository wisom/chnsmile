package com.icefire.chnsmile.activity;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.IntentUtils;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ScreenUtils;
import com.bumptech.glide.Glide;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;
import com.icefire.chnsmile.photoview.PhotoView;
import com.icefire.chnsmile.ui.FullScreenPlayerView;
import com.icefire.chnsmile.ui.TitleView;
import com.icefire.chnsmile.uils.MediaFile;
import com.icefire.chnsmile.uils.SystemUtils;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;

import java.io.File;

@Route(path = Constants.SP_MEDIA)
public class MediaDetailAcitity extends BaseActivity {
    @Autowired
    String url;

    private FullScreenPlayerView playerView;
    private TitleView titleView;
    private PhotoView photoView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (!(MediaFile.isImageType(url) || MediaFile.isVideoType(url))) {
            Router.open("smile://" + Constants.SP_ATTACHMENT + "?url=" + url);
            finish();
            return;
        }
        setContentView(R.layout.activity_media_detail);
        titleView = findViewById(R.id.title_view);
        photoView = findViewById(R.id.photo_view);
        playerView = findViewById(R.id.player_view);
        initData();

    }

    private void downloadFile(String url) {
        LogUtils.i("download: " + url);
        String dir = SystemUtils.getDocumentDir();
        String name = SystemUtils.getDocumentName(url);
        showLoading(R.string.downloading);
        OkGo.<File>get(url)
                .tag(this)
                .execute(new FileCallback(dir, name) {

                    @Override
                    public void onStart(Request<File, ? extends Request> request) {
                        LogUtils.i("正在下载中");
                    }

                    @Override
                    public void onSuccess(Response<File> response) {
                        LogUtils.i("下载完成");
                        dismissLoading();
                        SystemUtils.shareFile(MediaDetailAcitity.this, SystemUtils.getDocumentPath(url).getAbsolutePath());
                    }

                    @Override
                    public void onError(Response<File> response) {
                        LogUtils.e("下载出错");
                        dismissLoading();
                    }
                });
    }

    private void initData() {
        LogUtils.i("url: " + url);
        if (url.startsWith("http")) {
            titleView.setRightText(getResources().getString(R.string.share));
            titleView.setOnRightTextClick(new TitleView.RightTextClickCallBack() {
                @Override
                public void onRightClick() {
                    downloadFile(url);
                }
            });
        }
        titleView.setTitle(MediaFile.isVideoFileType(url) ? getResources().getString(R.string.video_title) : getResources().getString(R.string.picture_title));
        if (MediaFile.isVideoFileType(url)) {
            photoView.setVisibility(View.GONE);
            playerView.setVisibility(View.VISIBLE);
            // 显示视频
            playerView.post(new Runnable() {
                @Override
                public void run() {

                    int width = ScreenUtils.getScreenWidth();
                    int height = playerView.getHeight();
                    playerView.bindData(width, height, "", url);
                }
            });
        } else {
            photoView.setVisibility(View.VISIBLE);
            playerView.setVisibility(View.GONE);
            Glide.with(this).load(url).into(photoView);
        }
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
