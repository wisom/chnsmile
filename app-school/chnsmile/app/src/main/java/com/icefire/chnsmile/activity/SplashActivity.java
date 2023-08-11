package com.icefire.chnsmile.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ToastUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.GenerateTestUserSig;
import com.icefire.chnsmile.fragment.SplashFragment;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.uils.TUIUtils;
import com.tencent.imsdk.v2.V2TIMCallback;

public class SplashActivity extends AppCompatActivity {

    @RequiresApi(api = Build.VERSION_CODES.P)
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        new Handler().postDelayed(new Runnable() {
            public void run() {
                if (ConfigurationManager.instance().getBoolean(Constants.PREF_KEY_PROTOCOL_STATUS)) {
                    startAppActivity();
                } else {
                    SplashFragment splashFragment = new SplashFragment();
                    getSupportFragmentManager().beginTransaction().replace(R.id.content, splashFragment).commit();
                }
            }
        }, 2000);
    }

    public void startAppActivity() {
        Uri uri = getIntent().getData();
        if (AccountManager.isLogined() && AccountManager.getUser() != null) {
            startIM();
        } else {
            Intent intent = new Intent(this, LoginActivity.class);
            startActivity(intent);
            finish();
        }
    }

    private void startIM() {
        User user = AccountManager.getUser();
        String userSig = GenerateTestUserSig.genTestUserSig(user.id);
        LogUtils.i("userSig: " + user.imUserSign);
        TUIUtils.login(user.id, user.imUserSign, new V2TIMCallback() {
            @Override
            public void onError(final int code, final String desc) {
                runOnUiThread(new Runnable() {
                    public void run() {
//                        ToastUtils.showShort(R.string.failed_login_tip);
                        ConfigurationManager.instance().setBoolean(Constants.PREF_KEY_IM_ERROR_STATUS, true);
                        startMainUI();
                        finish();
                    }
                });
                LogUtils.e("imLogin errorCode = " + code + ", errorInfo = " + desc);
            }

            @Override
            public void onSuccess() {
                ConfigurationManager.instance().setBoolean(Constants.PREF_KEY_IM_ERROR_STATUS, false);
                startMainUI();
                finish();
            }
        });
    }

    private void startMainUI() {
        ARouter.getInstance().build(Constants.SP_BASE_MAIN).navigation();
    }

    private void startLoginUI() {
        ARouter.getInstance().build(Constants.SP_BASE_LOGIN).navigation();
    }
}
