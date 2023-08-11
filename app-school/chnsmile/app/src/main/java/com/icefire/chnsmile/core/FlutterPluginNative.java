package com.icefire.chnsmile.core;

import android.content.Intent;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.alibaba.fastjson.JSON;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ThreadUtils;
import com.drake.tooltip.ToastKt;
import com.icefire.chnsmile.MainApplication;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.core.network.Request;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.manager.DeviceManager;
import com.icefire.chnsmile.manager.UserManager;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.model.UserAgent;
import com.icefire.chnsmile.model.WxAccessInfo;
import com.idlefish.flutterboost.FlutterBoost;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterPluginNative {
    private static final String TAG = "FlutterPluginNative";
    private static final String METHOD_CHANNEL = "com.icefire.chnsmile/api";
    private MethodChannel methodChannel;

    private static final String METHOD_USERAGENT = "getUserAgent";
    private static final String METHOD_USERINFO = "getUserInfo";
    private static final String METHOD_LOGOUT = "logout";
    private static final String METHOD_GETPROXY = "getProxy";
    private static final String TRIGGER_IM = "triggerIM";
    private static final String TRIGGER_UNREAD = "triggerUnRead";
    private static final String SWITCH_TAB = "switchTab";
    //微信解绑
    private static final String METHOD_WX_UNBIND = "WxUnBind";

    public static FlutterPluginNative mInstance;

    private FlutterPluginNative() {
    }

    public static FlutterPluginNative getInstance() {
        if (mInstance == null) {
            mInstance = new FlutterPluginNative();
        }
        return mInstance;
    }

    public void switchTab() {
        FlutterBoost.instance().sendEventToFlutter(SWITCH_TAB, null);
    }

    public void triggerIM(HashMap map) {
        FlutterBoost.instance().sendEventToFlutter(TRIGGER_IM, map);
    }

    public void triggerUnRead(HashMap map) {
        FlutterBoost.instance().sendEventToFlutter(TRIGGER_UNREAD, map);
    }

    public void init(FlutterEngine flutterEngine) {
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                LogUtils.d(TAG, "method = " + call.method + "  arguments=" + call.arguments);
                switch (call.method) {
                    case METHOD_USERAGENT:
                        result.success(getUserAgent());
                        break;
                    case METHOD_USERINFO:
                        result.success(getUserInfoStr());
                        break;
                    case METHOD_LOGOUT:
                        result.success(logout());
                        break;
                    case METHOD_GETPROXY:
                        result.success(getProxy());
                        break;
                    case METHOD_WX_UNBIND:
                        Map<String, String> arguments = (Map<String, String>) call.arguments;
                        String openId = arguments.get("openId");
                        result.success(wxunbind(openId));
                        break;
                }
            }
        });
    }

    public static String getUserAgent() {
        DefaultResponse<UserAgent> response = new DefaultResponse();
        response.data = DeviceManager.getInstance().getUserAgent();
        return JSON.toJSONString(response);
    }

    public static String logout() {
        AccountManager.onLogout();
        Router.open(Constants.SP_BASE_LOGIN, Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        DefaultResponse<String> response = new DefaultResponse();
        response.data = "1";
        return JSON.toJSONString(response);
    }

    public static String getUserInfoStr() {
        DefaultResponse<User> response = new DefaultResponse();
        response.data = UserManager.getInstance().getUserInfo();
        Log.i("xxxxx1", "data: " + JSON.toJSONString(response));
        return JSON.toJSONString(response);
    }

    public static String getProxy() {
        String proxy = System.getProperty("http.proxyHost");
        String port = System.getProperty("http.proxyPort");
        Map<String, Object> setting = new HashMap();
        setting.put("host", proxy);
        setting.put("port", port);
        DefaultResponse<Map<String, Object>> response = new DefaultResponse();
        response.data = setting;
        return JSON.toJSONString(response);
    }

    public static String wxunbind(String openId) {
        DefaultResponse<String> response = new DefaultResponse();
        startWxUnbindReq(openId);
        response.data = openId;
        return JSON.toJSONString(response);
    }

    private static void startWxUnbindReq(String openId) {
        String account = ConfigurationManager.instance().getString(Constants.PREF_KEY_USER_ACCOUNT);
        ApiService.get(Constants.WX_UNBIND)
                .addParam("account", account)
                .addParam("openId", openId)
                .addParam("type", 1)
                .execute(new JsonCallback<Boolean>() {
                    @Override
                    public void onSuccess(ApiResponse<Boolean> response) {
                        if (response.code == Request.CODE_SUCCESS) {
                            if (response.body) {
                                Looper.prepare();
                                Toast.makeText(MainApplication.getInstance(), "微信解绑成功", Toast.LENGTH_SHORT).show();
                                Looper.loop();
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_ACCESSTOKEN, "");
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_OPENID, "");
                                ConfigurationManager.instance().setString(Constants.PREF_KEY_WX_REFRESHTOKEN, "");
                            } else {
                                showToast(response.message);
                            }
                        } else {
                            showToast(response.message);
                        }
                    }

                    @Override
                    public void onError(ApiResponse<Boolean> response) {
                        showToast(response.message);
                    }
                });
    }

    private static void showToast(String message) {

        ThreadUtils.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ToastKt.toast(message);
            }
        });
    }
}
