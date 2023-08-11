package com.icefire.chnsmile.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.KeyboardUtils;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ThreadUtils;
import com.drake.tooltip.ToastKt;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.core.network.Request;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.uils.TUIUtils;
import com.tencent.imsdk.v2.V2TIMCallback;

public class WxBindActivity extends BaseActivity {

    public static String EXTRA_ACCESSTOKEN = "EXTRA_ACCESSTOKEN";
    public static String EXTRA_OPENID = "EXTRA_OPENID";
    public static String EXTRA_USERID = "EXTRA_USERID";

    private TextView inputName;
    private TextView inputPassword;
    private Button actionBind;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wx_bind);
        initView();
    }

    private void initView(){
        inputName = findViewById(R.id.input_username);
        inputPassword = findViewById(R.id.input_password);
        actionBind = findViewById(R.id.action_bind);

        actionBind.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String account = inputName.getText().toString();
                String password = inputPassword.getText().toString();
                KeyboardUtils.hideSoftInput(WxBindActivity.this);
                if (TextUtils.isEmpty(account)) {
                    showToast(R.string.login_account_error);
                    return;
                }
                if (TextUtils.isEmpty(password)) {
                    showToast(R.string.login_password_error);
                    return;
                }
                Intent intent = getIntent();
                String accessToken = intent.getStringExtra(EXTRA_ACCESSTOKEN);
                String openId = intent.getStringExtra(EXTRA_OPENID);
                int userIdentity = intent.getIntExtra(EXTRA_USERID,1);
                wxLoginReq(accessToken, openId, account, password, userIdentity);
            }
        });
    }

    private void wxLoginReq(String accessToken, String openId, String account,
                            String password, int userIdentity) {
        ApiService.post(Constants.WX_LOGIN)
                .addParam("accessToken", accessToken)
                .addParam("openId", openId)
                .addParam("account", account)
                .addParam("password", password)
                .addParam("type", 1)
                .addParam("userIdentity", userIdentity)
                .execute(new JsonCallback<String>() {
                    @Override
                    public void onSuccess(ApiResponse<String> response) {
                        if (response.code == Request.CODE_SUCCESS) {
                            if (!TextUtils.isEmpty(response.body)) {
                                AccountManager.onAuth(response.body);
                                // 请求用户
                                loadUser();
                            } else {
                                showToast(R.string.login_token_error);
                            }
                        } else {
                            dismissLoading();
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<String> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    private void loadUser() {
        ApiService.get(Constants.SERVER_URL_USERS_GET).execute(new JsonCallback<User>() {
            @Override
            public void onSuccess(ApiResponse<User> response) {
                dismissLoading();
                if (response.code == Request.CODE_SUCCESS) {
                    AccountManager.onLogin(response.body);
                    startIM(response.body);
                } else {
                    showToast(response.message);
                }
            }

            @Override
            public void onError(ApiResponse<User> response) {
                dismissLoading();
                showToast(response.message);
            }
        });
    }

    private void startIM(User user) {
//        String userSig = GenerateTestUserSig.genTestUserSig(user.id);
        LogUtils.i("userSig: " + user.imUserSign);
        TUIUtils.login(user.id, user.imUserSign, new V2TIMCallback() {
            @Override
            public void onError(final int code, final String desc) {
                runOnUiThread(new Runnable() {
                    public void run() {
                        ConfigurationManager.instance().setBoolean(Constants.PREF_KEY_IM_ERROR_STATUS, true);
//                        ToastUtils.showShort(R.string.failed_login_tip + ":" + desc);
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

    private void showToast(int message) {
        ThreadUtils.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ToastKt.toast(message);
            }
        });
    }

    private void showToast(String message) {

        ThreadUtils.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ToastKt.toast(message);
            }
        });
    }

}