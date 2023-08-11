package com.icefire.chnsmile.manager;

import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.blankj.utilcode.util.LogUtils;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.uils.TUIUtils;
import com.tencent.imsdk.v2.V2TIMCallback;

/**
 *
 */

public class AccountManager {

    private static boolean sIsLogined = false;
    private static User sUser = null;
    private static String sToken = "";

    /**
     * 退出登录
     */
    public static void onLogout() {
        sIsLogined = false;
        ConfigurationManager.instance().remove(Constants.PREF_KEY_SESSION);
        ConfigurationManager.instance().remove(Constants.PREF_KEY_USER);
//        ConfigurationManager.instance().remove(Constants.PREF_KEY_GETUI_CID);
        ConfigurationManager.instance().remove(Constants.PREF_KEY_URL);
        TUIUtils.logout(new V2TIMCallback() {
            @Override
            public void onSuccess() {
            }

            @Override
            public void onError(int i, String s) {
            }
        });
    }

    public static void onAuth(String session) {
        sToken = session;
        LogUtils.i("AccountManager.getToken(): " + sToken);
        ConfigurationManager.instance().setString(Constants.PREF_KEY_SESSION, session);
    }

    public static boolean isHuaWei() {
        return sUser != null ? sUser.account.equals("13136051325") : false;
    }

    public static void onLogin(User user) {
        sIsLogined = true;
        sUser = user;
        sUser.baseUrl = Constants.SERVER_URL_BASE_HOST;
        sUser.lastChildId = ConfigurationManager.instance().getString(Constants.PREF_KEY_USER_ID);
        sToken = "";
        ConfigurationManager.instance().setString(Constants.PREF_KEY_USER, JSON.toJSONString(user));
    }

    public static User getUser() {
        String user = ConfigurationManager.instance().getString(Constants.PREF_KEY_USER);
//        if (!TextUtils.isEmpty(user) && sUser == null) {
        sUser = JSON.parseObject(user, User.class);
        if (sUser == null) return new User();
        sUser.lastChildId = ConfigurationManager.instance().getString(Constants.PREF_KEY_USER_ID);
        sUser.baseUrl = Constants.SERVER_URL_BASE_HOST;
//        }
        return sUser;
    }

    public static String getToken() {
        if (TextUtils.isEmpty(sToken)) {
            sToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_SESSION);
        }
        return sToken;
    }

    /**
     * 是否登陆
     *
     * @return
     */
    public static boolean isLogined() {
        sToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_SESSION);
        if (!TextUtils.isEmpty(sToken)) {
            sIsLogined = true;
            sUser = JSON.parseObject(ConfigurationManager.instance().getString(Constants.PREF_KEY_USER), User.class);
        }
        return sIsLogined;
    }
}
