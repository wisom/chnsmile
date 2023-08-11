package com.icefire.chnsmile.activity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.text.style.BackgroundColorSpan;
import android.text.style.ForegroundColorSpan;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.KeyboardUtils;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ThreadUtils;
import com.drake.tooltip.ToastKt;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.core.network.Request;
import com.icefire.chnsmile.event.GetWxCodeEvent;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.model.Region;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.model.WxAccessInfo;
import com.icefire.chnsmile.model.WxUserInfo;
import com.icefire.chnsmile.ui.UrlClickSpan;
import com.icefire.chnsmile.uils.TUIUtils;
import com.icefire.chnsmile.uils.WXUtil;
import com.icefire.chnsmile.views.UICheckBox;
import com.tencent.imsdk.v2.V2TIMCallback;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.util.List;

@Route(path = Constants.SP_BASE_LOGIN)
public class LoginActivity extends BaseActivity implements View.OnClickListener {

    private Button buttonLogin;
    private Button buttonLoginWx;
    private LinearLayout llFamily;
    private LinearLayout llTeacher;
    private TextView inputName;
    private TextView inputPassword;
    private ImageView ivFamily;
    private TextView textFamily;
    private ImageView ivTeacher;
    private TextView textTeacher;
    private TextView textForget;
    private TextView textRegister;
    private UICheckBox ckAgreen;
    private TextView tvAgreen;
    private int userIdentity = 1; // 身份类型: 0 游客 1 家长 2 老师

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        EventBus.getDefault().register(this);
        initView();
    }


    private void initView() {
        llFamily = findViewById(R.id.ll_family);
        llTeacher = findViewById(R.id.ll_teacher);
        buttonLogin = findViewById(R.id.action_login);
        buttonLoginWx = findViewById(R.id.wx_login);
        inputName = findViewById(R.id.input_username);
        inputPassword = findViewById(R.id.input_password);
        ivFamily = findViewById(R.id.iv_family);
        textFamily = findViewById(R.id.tv_family);
        ivFamily = findViewById(R.id.iv_family);
        textFamily = findViewById(R.id.tv_family);
        ivTeacher = findViewById(R.id.iv_teacher);
        textTeacher = findViewById(R.id.tv_teacher);
        textForget = findViewById(R.id.tv_forget);
        textRegister = findViewById(R.id.tv_register);
        ckAgreen = findViewById(R.id.ck_agreen);
        tvAgreen = findViewById(R.id.tv_agreen);

        ckAgreen.setChecked(false);
        // 禁掉勾选动画
        ckAgreen.setAnim(false);
        setupText1();

        ivFamily.setSelected(true);
        textFamily.setSelected(true);

        llFamily.setOnClickListener(this);
        llTeacher.setOnClickListener(this);
        textForget.setOnClickListener(this);
        buttonLogin.setOnClickListener(this);
        buttonLoginWx.setOnClickListener(this);
        textRegister.setOnClickListener(this);

        String account = ConfigurationManager.instance().getString(Constants.PREF_KEY_USER_ACCOUNT);
        if (!TextUtils.isEmpty(account)) {
            inputName.setText(account);
        }

        initWxLogin();
    }

    WxUserInfoReceiver mWxReceiver;
    LocalBroadcastManager mLocalBroadcastManager;

    private void initWxLogin() {
        mWxReceiver = new WxUserInfoReceiver();
        IntentFilter filter = new IntentFilter();
        filter.addAction(WXUtil.WX_CODE_ACTION);
        mLocalBroadcastManager = LocalBroadcastManager.getInstance(this);
        mLocalBroadcastManager.registerReceiver(mWxReceiver, filter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
        if (mWxReceiver != null && mLocalBroadcastManager != null)
            mLocalBroadcastManager.unregisterReceiver(mWxReceiver);
    }

    private void setupText1() {
        String content = tvAgreen.getText().toString();
        int firstStart = content.indexOf("《");
        int firstEnd = content.indexOf("》");
        int secondStart = content.indexOf("《", firstEnd + 1);
        int secondEnd = content.indexOf("》", firstEnd + 1);

        SpannableString spannableString = new SpannableString(content);
        ForegroundColorSpan foregroundColorSpan = new ForegroundColorSpan(getResources().getColor(R.color.ui_brand_color));
        UrlClickSpan firstClickSpan = new UrlClickSpan(Constants.PERSONAL_POLICY);
        UrlClickSpan secondClickSpan = new UrlClickSpan(Constants.AGREEMENT);

        spannableString.setSpan(firstClickSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(foregroundColorSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(new BackgroundColorSpan(Color.TRANSPARENT), firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        spannableString.setSpan(secondClickSpan, secondStart, secondEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(foregroundColorSpan, secondStart, secondEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(new BackgroundColorSpan(Color.TRANSPARENT), secondStart, secondEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        tvAgreen.setText(spannableString);
        tvAgreen.setMovementMethod(LinkMovementMethod.getInstance());
    }

    private void login() {
        String userName = inputName.getText().toString();
        String password = inputPassword.getText().toString();
        KeyboardUtils.hideSoftInput(this);
        int userIdentity = this.userIdentity;
        if (TextUtils.isEmpty(userName)) {
            showToast(R.string.login_username_error);
            return;
        }
        if (TextUtils.isEmpty(password)) {
            showToast(R.string.login_password_error);
            return;
        }

        if (!ckAgreen.isChecked()) {
            showToast(R.string.login_private_error);
            return;
        }
//        KeyboardUtils.hideSoftInput(this);
        showLoading(R.string.loading);

        // 获取服务器
        ApiService.get(Constants.SERVER_URL_GET_PLATFORM)
                .addParam("account", userName)
                .addParam("isStaff", userIdentity)
                .execute(new JsonCallback<List<Region>>() {
                    @Override
                    public void onSuccess(ApiResponse<List<Region>> response) {
                        super.onSuccess(response);
                        if (response.code != 200) {
                            dismissLoading();
                            showToast(response.message != null ? response.message : "服务器异常");
                            return;
                        }
                        List<Region> regions = response.body;
                        String url = null;
                        if (regions != null && regions.size() > 0) {
                            Region region = regions.get(0);
                            if (region.onlineState != null && region.onlineState.equals("2")) {
                                dismissLoading();
                                showToast(R.string.service_offline_error);
                                return;
                            }
                            if (!TextUtils.isEmpty(region.account)) {
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_USER_ACCOUNT, region.account);
                            }
                            if (!TextUtils.isEmpty(region.studentId)) {
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_USER_ID, region.studentId);
                            }


                            if (!TextUtils.isEmpty(region.hostUrl)) {
                                url = region.hostUrl;
                            }
                            if (url == null && !TextUtils.isEmpty(region.hostUrl1)) {
                                url = region.hostUrl1;
                            }
                        }

                        if (url == null) {
                            ConfigurationManager.instance().setString(Constants.PREF_KEY_URL, "");
                            url = Constants.SERVER_URL_ORIGIN;
                        }

                        ConfigurationManager.instance().setString(Constants.PREF_KEY_URL, url);
                        Constants.SERVER_URL_BASE_HOST = url;

                        ApiService.init(Constants.SERVER_URL_BASE_HOST);

                        ApiService.post(Constants.SERVER_URL_USERS_LOGIN)
                                .addParam("phone", userName)
                                .addParam("password", password)
                                .addParam("userIdentity", userIdentity)
                                .execute(new JsonCallback<String>() {
                                    @Override
                                    public void onSuccess(ApiResponse<String> response) {
                                        if (response.code == Request.CODE_SUCCESS) {
                                            if (!TextUtils.isEmpty(response.body)) {
                                                Log.d("flutter==", "登录成功 " + response.body);
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

                    @Override
                    public void onError(ApiResponse<List<Region>> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    private void wxLogin() {
        KeyboardUtils.hideSoftInput(this);
        int userIdentity = this.userIdentity;

        if (!ckAgreen.isChecked()) {
            showToast(R.string.login_private_error);
            return;
        }

        String url = Constants.SERVER_URL_ORIGIN;
        ConfigurationManager.instance().setString(Constants.PREF_KEY_URL, url);
        Constants.SERVER_URL_BASE_HOST = url;
        ApiService.init(Constants.SERVER_URL_BASE_HOST);

        String accessToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_WX_ACCESSTOKEN);
        if (TextUtils.isEmpty(accessToken)) {
            WXUtil.sendAuth();
        } else {
            String openId = ConfigurationManager.instance().getString(Constants.PREF_KEY_WX_OPENID);
            verifyToken(accessToken, openId, userIdentity);
        }
    }

    /**
     * 检查微信登录token是否过期
     *
     * @param accessToken
     * @param openId
     * @param type type 无效，0-行政版 1-校园版
     */
    private void verifyToken(String accessToken, String openId, int userIdentity) {
        showLoading();
        ApiService.get(Constants.WX_VERIFY_TOKEN)
                .addParam("accessToken", accessToken)
                .addParam("openId", openId)
                .addParam("type", 1)
                .execute(new JsonCallback<Boolean>() {
                    @Override
                    public void onSuccess(ApiResponse<Boolean> response) {
                        dismissLoading();
                        if (response.code == Request.CODE_SUCCESS) {
                            if (response.body == true) {
                                getWxUserInfo(accessToken, openId, userIdentity);
                            } else {
                                showToast(response.message);
                                String refreshToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_WX_REFRESHTOKEN);
                                refreshWxAccessToken(refreshToken, userIdentity);
                            }
                        } else {
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<Boolean> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    /**
     * 获取access_token
     *
     * @param code 微信授权后返回的code，用于获取access_token
     * @param type type 无效，0-行政版 1-校园版
     */
    private void getWxAccessToken(String code) {
        showLoading();
        ApiService.get(Constants.WX_GET_ACCESS_TOKEN)
                .addParam("code", code)
                .addParam("type", 1)
                .execute(new JsonCallback<WxAccessInfo>() {
                    @Override
                    public void onSuccess(ApiResponse<WxAccessInfo> response) {
                        dismissLoading();
                        if (response.code == Request.CODE_SUCCESS) {
                            if (response.body != null) {
                                WxAccessInfo wxAccessInfo = response.body;
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_ACCESSTOKEN, wxAccessInfo.accessToken);
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_OPENID, wxAccessInfo.openid);
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_REFRESHTOKEN, wxAccessInfo.refreshToken);
                                getWxUserInfo(wxAccessInfo.accessToken, wxAccessInfo.openid, userIdentity);
                            } else {
                                showToast(response.message);
                            }
                        } else {
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<WxAccessInfo> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    /**
     * 刷新access_token
     *
     * @param refreshToken
     * @param type type 无效，0-行政版 1-校园版
     */
    private void refreshWxAccessToken(String refreshToken, int userIdentity) {
        showLoading();
        ApiService.get(Constants.WX_REFRESH_ACCESS_TOKEN)
                .addParam("refreshToken", refreshToken)
                .addParam("type", 1)
                .execute(new JsonCallback<WxAccessInfo>() {
                    @Override
                    public void onSuccess(ApiResponse<WxAccessInfo> response) {
                        dismissLoading();
                        if (response.code == Request.CODE_SUCCESS) {
                            if (response.body != null) {
                                WxAccessInfo wxAccessInfo = response.body;
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_ACCESSTOKEN, wxAccessInfo.accessToken);
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_OPENID, wxAccessInfo.openid);
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_REFRESHTOKEN, wxAccessInfo.refreshToken);
                                getWxUserInfo(wxAccessInfo.accessToken, wxAccessInfo.openid, userIdentity);
                            } else {
                                showToast(response.message);
                            }
                        } else {
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<WxAccessInfo> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    /**
     * 获取微信用户信息
     *
     * @param accessToken
     * @param type type 无效，0-行政版 1-校园版
     */
    private void getWxUserInfo(String accessToken, String openId, int userIdentity) {
        showLoading();
        ApiService.get(Constants.WX_GET_USERINFO)
                .addParam("accessToken", accessToken)
                .addParam("openId", openId)
                .addParam("type", 1)
                .execute(new JsonCallback<WxUserInfo>() {
                    @Override
                    public void onSuccess(ApiResponse<WxUserInfo> response) {
                        dismissLoading();
                        if (response.code == Request.CODE_SUCCESS) {
                            if (response.body != null) {
                                WxUserInfo wxUserInfo = response.body;
                                if (wxUserInfo != null && !TextUtils.isEmpty(wxUserInfo.account)) {
                                    wxLoginReq(accessToken, openId, wxUserInfo.account, "", userIdentity);
                                } else {
                                    Intent intent = new Intent(LoginActivity.this, WxBindActivity.class);
                                    intent.putExtra(WxBindActivity.EXTRA_ACCESSTOKEN, accessToken);
                                    intent.putExtra(WxBindActivity.EXTRA_OPENID, wxUserInfo.openid);
                                    intent.putExtra(WxBindActivity.EXTRA_USERID, userIdentity);
                                    startActivity(intent);
                                }
                            } else {
                                showToast(response.message);
                            }
                        } else {
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<WxUserInfo> response) {
                        dismissLoading();
                        showToast(response.message);
                    }
                });
    }

    /**
     * 微信登录
     *
     * @param accessToken
     * @param openId
     * @param account
     * @param password
     * @param userIdentity
     */
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
                                if (!TextUtils.isEmpty(account)) {
                                    ConfigurationManager.instance().setString(Constants.PREF_KEY_USER_ACCOUNT, account);
                                }
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

    private void startLoginUI() {
        ARouter.getInstance().build(Constants.SP_BASE_LOGIN).navigation();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.action_login:
                login();
                break;
            case R.id.wx_login:
                wxLogin();
                break;
            case R.id.ll_family:
                ivFamily.setSelected(true);
                textFamily.setSelected(true);
                ivTeacher.setSelected(false);
                textTeacher.setSelected(false);
                userIdentity = 1;
                break;
            case R.id.ll_teacher:
                ivFamily.setSelected(false);
                textFamily.setSelected(false);
                ivTeacher.setSelected(true);
                textTeacher.setSelected(true);
                userIdentity = 2;
                break;
            case R.id.tv_forget:
                Router.openFluterForResult(this, "forget_page", 100);
                break;
            case R.id.tv_register:

                break;
        }
    }

    private class WxUserInfoReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String code = ((String) getIntent().getSerializableExtra(WXUtil.EXTRA_WX_CODE));
            getWxAccessToken(code);
        }

//        override fun onReceive(context: Context?, intent: Intent?) {
//            val code = intent?.getSerializableExtra(EXTRA_WX_CODE) as String
//            com.cs.bd.daemon.util.LogUtils.d("MainOperatStatistics","登陆界面微信回调")
//            mHandler?.postDelayed({
//                    //标记进入第三方界面
//                    SheepApp.isInThirdParty = false
//                    com.cs.bd.daemon.util.LogUtils.d("MainOperatStatistics","isInThirdParty:"+SheepApp.isInThirdParty)
//            },2000)
//
//            if(code != "404"){
//                mHandler?.sendMessage(Message.obtain(mHandler, WHAT_WX_CODE, code))
//            }
//        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEvent(GetWxCodeEvent event) {
        if (!TextUtils.isEmpty(event.wxCode))
            getWxAccessToken(event.wxCode);
    }
}
