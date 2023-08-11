package com.icefire.chnsmile.core;

import android.text.TextUtils;

public class Constants {

    // url
//    public static final String SERVER_URL_ORIGIN = "https://www.csmiledu.com/"; // 获取域名
//    public static final String SERVER_URL_ORIGIN = "http://121.199.18.201/"; // 获取域名
//    public static final String SERVER_URL_ORIGIN = "http://47.98.251.192/"; // 获取域名
    public static final String SERVER_URL_ORIGIN = "http://yun3.csmiledu.com/"; // 获取域名
    public static final String SERVER_URL_ORIGIN_2 = "http://121.199.18.201/"; // 二期接口域名
    public static final String SERVER_URL_GET_PLATFORM = SERVER_URL_ORIGIN + "platformRegionUser/default/list"; // 获取域名
//    public static String SERVER_URL_BASE_HOST = TextUtils.isEmpty(ConfigurationManager.instance().getString(Constants.PREF_KEY_URL)) ? "https://www.csmiledu.com/" : ConfigurationManager.instance().getString(Constants.PREF_KEY_URL); // online
//    public static String SERVER_URL_BASE_HOST = TextUtils.isEmpty(ConfigurationManager.instance().getString(Constants.PREF_KEY_URL)) ? "http://121.199.18.201/" : ConfigurationManager.instance().getString(Constants.PREF_KEY_URL); // online
//    public static String SERVER_URL_BASE_HOST = TextUtils.isEmpty(ConfigurationManager.instance().getString(Constants.PREF_KEY_URL)) ? "http://47.98.251.192/" : ConfigurationManager.instance().getString(Constants.PREF_KEY_URL); // online
    public static String SERVER_URL_BASE_HOST = TextUtils.isEmpty(ConfigurationManager.instance().getString(Constants.PREF_KEY_URL)) ? "http://yun3.csmiledu.com/" : ConfigurationManager.instance().getString(Constants.PREF_KEY_URL); // online
    public static final String SERVER_URL_USERS_LOGIN = "app-api/mobileLogin";
    //微信登录
    public static final String WX_LOGIN = "api/wx-auth/wxLogin";
    //校验accessToken
    public static final String WX_VERIFY_TOKEN = "api/wx-auth/verifyAccessToken";
    //获取用户信息
    public static final String WX_GET_USERINFO = "api/wx-auth/getWxUserInfo";
    //获取access_token
    public static final String WX_GET_ACCESS_TOKEN = "api/wx-auth/getAccessToken";

    //刷新access_token
    public static final String WX_REFRESH_ACCESS_TOKEN = "api/wx-auth/refreshToken";
    //微信解绑
    public static final String WX_UNBIND = "api/wx-auth/unbindingWx";

    // 微信
    public static final String WX_APP_ID = "wx0ea0d374ca33b2d9";
    public static final String WX_APP_SECRET = "782cbc50274a1a18ab8660f6efc81bd2";
    public static final String SERVER_URL_BINDCID = "app-api/app/user/push/bindCidAndAlias";
    public static final String SERVER_URL_USERS_GET = "app-api/getLoginUser";
    public static final String SERVER_URL_TEACHER_CONTACT = "app-api/app/school/student/class/teacherContact";
    public static final String SERVER_URL_UNREADNUM_CONTACT = "app-api/app/user/tab/unReadNum";

    public static final String PERSONAL_POLICY = SERVER_URL_ORIGIN + "app-api/app/school/page/platform/WX_USER_PRIVACY";
    public static final String AGREEMENT = SERVER_URL_ORIGIN + "app-api/app/school/page/platform/WX_USER_AGREEMENT";
    public static final String THIRD_SDK_INSTRUCTIONS = SERVER_URL_ORIGIN + "app-api/app/school/page/platform/WX_APP_SDK_EXPLAIN";

    // preferences
    public static final String PREF_KEY_STORAGE_PATH = "chnsmile.prefs.storage.path";
    public static final String PREF_KEY_USER = "chnsmile.prefs.user";
    public static final String PREF_KEY_URL = "chnsmile.prefs.url";
    public static final String PREF_KEY_IM_ERROR_STATUS = "chnsmile.prefs.im.error.status";
    public static final String PREF_KEY_SESSION = "chnsmile.prefs.user.session";
    public static final String PREF_KEY_USER_ACCOUNT = "chnsmile.prefs.user.account";

    //微信accessToken
    public static final String PREF_KEY_WX_ACCESSTOKEN = "chnsmile.prefs.wechat.accesstoken";
    public static final String PREF_KEY_WX_OPENID = "chnsmile.prefs.wechat.openid";

    public static final String PREF_KEY_WX_REFRESHTOKEN = "chnsmile.prefs.wechat.refreshtoken";
    public static final String PREF_KEY_USER_ID = "chnsmile.prefs.user.id";
    public static final String PREF_KEY_PROTOCOL_STATUS = "chnsmile.prefs.protocol.status";
    public static final String PREF_KEY_FIRST_ENTER = "chnsmile.prefs.first.enter";
    public static final String PREF_KEY_GETUI_CID = "chnsmile.prefs.getui.cid";

    // fragment type
    public static final String FRAGMENT_TYPE_KEY = "fragment_key";

    // router 页面
    public static final String SP_BASE_LOGIN = "/sp/login"; // 登录页面
    public static final String SP_BASE_FORGET = "/sp/forget"; // 忘记密码页面
    public static final String SP_BASE_MAIN = "/sp/main"; // 首页
    public static final String SP_WEBVIEW = "/sp/webview"; // webview
    public static final String SP_WEBVIEW2 = "/sp/webview2"; // webview
    public static final String SP_MEDIA = "/sp/media"; // 媒体查看器
    public static final String SP_PICTURE = "/sp/picture"; // 图片查看器
    public static final String SP_VIDEO = "/sp/video"; // 视频查看器
    public static final String SP_ATTACHMENT = "/sp/attachment"; // 附件查看器
    public static final String SP_CHAT = "/sp/chat"; // 聊天页面

    // jsbridge
    public static final String JSBRIDGE_TEST = "submitFromWeb"; // 测试bridge
    public static final String JSBRIDGE_OPEN_MEDIA = "openMedia"; // 打开多媒体(视频，图片, 参数:url)
    public static final String JSBRIDGE_OPEN_NATIVE = "openNative"; // 打开Native页面(参数url)

    // type
    public static final byte FILE_TYPE_AUDIO = 0x00;
    public static final byte FILE_TYPE_PICTURES = 0x01;
    public static final byte FILE_TYPE_VIDEOS = 0x02;
    public static final byte FILE_TYPE_DOCUMENTS = 0x03;
    public static final byte FILE_TYPE_APPLICATIONS = 0x04;
    public static final byte FILE_TYPE_RINGTONES = 0x05;

    // IM APPID
    public static final int SDKAPPID = 1400627286;


}

