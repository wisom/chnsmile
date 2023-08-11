package com.icefire.chnsmile;

import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.Utils;
import com.drake.tooltip.ToastConfig;
import com.drake.tooltip.interfaces.ToastGravityFactory;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.LibraryInit;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class MainApplication extends Application {
    public static MainApplication application = null;
    public static Context context = null;

    @Override
    public void onCreate() {
        super.onCreate();

        MainApplication.application = this;
        MainApplication.context = this;

        // 初始化
        ConfigurationManager.create(application);
        ARouter.init(application);
        LibraryInit.initAllLibrary(this);
        ToastConfig.initialize(this, new ToastGravityFactory());

        regToWx();
    }

    public static MainApplication getInstance(){
        return application;
    }

   private static IWXAPI api = null;

    /**
     * 微信登录
     */
    private void regToWx() {
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        api = WXAPIFactory.createWXAPI(this, Constants.WX_APP_ID, true);

        // 将应用的appId注册到微信
        api.registerApp(Constants.WX_APP_ID);

        //建议动态监听微信启动广播进行注册到微信
        registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                // 将该app注册到微信
                api.registerApp(Constants.WX_APP_ID);
            }
        }, new IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP));
    }

    public IWXAPI getWxApi() {
        return api;
    }
}
