package com.icefire.chnsmile.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.IntentUtils;
import com.blankj.utilcode.util.LogUtils;
import com.bumptech.glide.Glide;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.photoview.PhotoView;
import com.icefire.chnsmile.ui.TitleView;
import com.icefire.chnsmile.uils.SystemUtils;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;

import java.io.File;

@Route(path = Constants.SP_PICTURE)
public class PictureAcitity extends BaseActivity {
    @Autowired
    String url;

    PhotoView photoView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_picture);
        TitleView titleView = findViewById(R.id.title_view);
        if (url != null && url.startsWith("http")) {
            titleView.setRightText(getResources().getString(R.string.share));
            titleView.setOnRightTextClick(new TitleView.RightTextClickCallBack() {
                @Override
                public void onRightClick() {
                    downloadFile(url);
                }
            });
        }
        photoView = findViewById(R.id.photo_view);
        Glide.with(this).load(url).into(photoView);
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
                        SystemUtils.shareFile(PictureAcitity.this, SystemUtils.getDocumentPath(url).getAbsolutePath());
                    }

                    @Override
                    public void onError(Response<File> response) {
                        LogUtils.e("下载出错");
                        dismissLoading();
                    }
                });
    }
}
