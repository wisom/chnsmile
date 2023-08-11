package com.icefire.chnsmile.activity;

import android.os.Bundle;
import android.os.Looper;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.alibaba.android.arouter.launcher.ARouter;
import com.gyf.immersionbar.ImmersionBar;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.LoadingDialog;

public class BaseActivity extends AppCompatActivity {

    private LoadingDialog mLoadingDialog = null;
    private boolean paused;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        ImmersionBar.with(this).statusBarColor(R.color.colorPrimary).init();
        ARouter.getInstance().inject(this);
        super.onCreate(savedInstanceState);
        this.paused = false;
    }

    @Override
    protected void onResume() {
        this.paused = false;
        super.onResume();
    }

    @Override
    protected void onPause() {
        this.paused = true;
        super.onPause();
    }

    public boolean isPaused() {
        return paused;
    }

    public void showLoading() {
        if (!isFinishing()) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    showLoading(0);
                }
            });
        }
    }

    public void showLoading(int resId) {
        if (mLoadingDialog == null) {
            mLoadingDialog = new LoadingDialog(this);
            if (resId != 0) {
                mLoadingDialog.setLoadingText(getString(resId));
            }
        }
        mLoadingDialog.show();
    }

    public void dismissLoading() {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            if (mLoadingDialog != null) {
                mLoadingDialog.dismiss();
                mLoadingDialog = null;
            }
        } else {
            runOnUiThread(() -> {
                if (mLoadingDialog != null) {
                    mLoadingDialog.dismiss();
                    mLoadingDialog = null;
                }
            });
        }
    }

}
