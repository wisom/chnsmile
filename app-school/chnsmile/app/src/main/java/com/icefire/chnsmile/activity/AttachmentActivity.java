package com.icefire.chnsmile.activity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.util.FileUtils;
import com.blankj.utilcode.util.LogUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;
import com.icefire.chnsmile.ui.TitleView;
import com.icefire.chnsmile.uils.MediaFile;
import com.icefire.chnsmile.uils.SystemUtils;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;
import com.tencent.smtt.sdk.TbsReaderView;

import java.io.File;

@Route(path = Constants.SP_ATTACHMENT)
public class AttachmentActivity extends BaseActivity {

    @Autowired
    String url;

    private FrameLayout container;
    private TextView tvError;
    private TbsReaderView tbsReaderView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_attachment);
        initView();
        loadUI();
    }

    private void loadUI() {
        LogUtils.e("url: " + url + ", " + MediaFile.isImageType(url));
        if (MediaFile.isImageType(url)) {
            Router.open("smile://" + Constants.SP_PICTURE + "?url=" + url);
            finish();
        } else if (MediaFile.isVideoType(url)) {
            Router.open("smile://" + Constants.SP_VIDEO + "?url=" + url);
            finish();
        } else {
            loadFile();
        }
    }

    private void initView() {
        TitleView titleView = findViewById(R.id.title_view);
        if (url.startsWith("http")) {
            titleView.setRightText(getResources().getString(R.string.share));
            titleView.setOnRightTextClick(new TitleView.RightTextClickCallBack() {
                @Override
                public void onRightClick() {
                    File localPath = SystemUtils.getDocumentPath(url);
                    if (!localPath.exists()) {
                        showLoading();
                        downloadFile(url, true);
                    } else {
                        SystemUtils.shareFile(AttachmentActivity.this, localPath.getAbsolutePath());
                    }
//                    startActivity(IntentUtils.getShareTextIntent(url));
                }
            });
        }
        container = findViewById(R.id.container);
        tvError = findViewById(R.id.tv_error);
        tbsReaderView = new TbsReaderView(this, new TbsReaderView.ReaderCallback() {
            @Override
            public void onCallBackAction(Integer integer, Object o, Object o1) {
            }
        });

        container.addView(tbsReaderView, 0, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void loadFile() {
        showLoading();
        if (!TextUtils.isEmpty(url)) {
            if (SystemUtils.isDocumentFileExist(url)) {
                // 直接加载
                loadLocalFile(SystemUtils.getDocumentPath(url));
            } else {
                // 下载
                downloadFile(url, false);
            }
        }
    }

    private void loadLocalFile(File filePah) {
        File file = new File(FileUtils.getFileExtension(url));
        if (file.exists()) {
            file.delete();
        }
        File cacheFile = SystemUtils.getTempDir("TbsReaderTemp");
        LogUtils.i("cacheFile: " + cacheFile.getAbsolutePath());
        LogUtils.i("filePah: " + filePah + ", Extension: " + FileUtils.getFileExtension(filePah));
        Bundle localBundle = new Bundle();
        localBundle.putString("filePath", filePah.getAbsolutePath());
        localBundle.putString("tempPath", cacheFile.getAbsolutePath());

        boolean preOpen = tbsReaderView.preOpen(FileUtils.getFileExtension(url), false);
        if (preOpen) {
            tvError.setVisibility(View.GONE);
            tbsReaderView.openFile(localBundle);
        } else {
            tvError.setVisibility(View.VISIBLE);
            tvError.setText(R.string.oa_cant_open_resource);
        }
        dismissLoading();
    }

    private void downloadFile(String url, boolean isFromShare) {
        LogUtils.i("download: " + url);
        String dir = SystemUtils.getDocumentDir();
        String name = SystemUtils.getDocumentName(url);
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
                        if (isFromShare) {
                            SystemUtils.shareFile(AttachmentActivity.this, SystemUtils.getDocumentPath(url).getAbsolutePath());
                        } else {
                            loadLocalFile(new File(dir, name));
                        }
                    }

                    @Override
                    public void onError(Response<File> response) {
                        LogUtils.e("下载出错");
                        dismissLoading();
                    }
                });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (tbsReaderView != null) {
            tbsReaderView.onStop();
        }
    }
}
