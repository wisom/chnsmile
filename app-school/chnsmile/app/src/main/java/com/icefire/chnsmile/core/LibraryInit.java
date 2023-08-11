package com.icefire.chnsmile.core;

import android.app.Application;
import android.content.Intent;
import android.util.Log;

import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ProcessUtils;
import com.blankj.utilcode.util.Utils;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.uils.SystemUtils;
import com.icefire.chnsmile.uils.TUIUtils;
import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostDelegate;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;
import com.igexin.sdk.PushManager;
import com.tencent.bugly.crashreport.CrashReport;
import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;
import com.tencent.smtt.sdk.TbsDownloader;
import com.tencent.smtt.sdk.TbsListener;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class LibraryInit {
    private static boolean isInit;

    public static void initAllLibrary(Application application) {
        try {
            if (ConfigurationManager.instance().getBoolean(Constants.PREF_KEY_PROTOCOL_STATUS)) {
                if (!isInit) {
                    isInit = true;
                    // 工具
                    Utils.init(application);
                    // bulgy
                    CrashReport.initCrashReport(application, "1a8985a86b", false);
                    // router
                    ARouter.init(application);
                    // boost
                    initBoost(application);
                    // 接口
                    ApiService.init(Constants.SERVER_URL_BASE_HOST);
                    if (ProcessUtils.isMainProcess()) {
                        // 推送
                        PushManager.getInstance().initialize(application);
                    }
                    // im初始化
                    initIM(application);
                    // x5 webview
//                    new Thread(new Runnable() {
//                        @Override
//                        public void run() {
//                            SystemUtils.initX5(application);
//                        }
//                    }).start();
                }
            }
        } catch (Throwable e) {
            String stacktrace = Log.getStackTraceString(e);
            throw new RuntimeException("MainApplication Create exception: " + stacktrace, e);
        }
    }

    private static void initIM(Application application) {
        TUIUtils.init(application, Constants.SDKAPPID, null, null);
    }

    private static void initBoost(Application application) {
        FlutterBoost.instance().setup(application, new FlutterBoostDelegate() {
            @Override
            public void pushNativeRoute(FlutterBoostRouteOptions options) {
                //这里根据options.pageName来判断你想跳转哪个页面，这里简单给一个
                String url = options.pageName();
                LogUtils.i("url: " + url);
                Router.open(url);
            }

            @Override
            public void pushFlutterRoute(FlutterBoostRouteOptions options) {
                Intent intent = new FlutterBoostActivity.CachedEngineIntentBuilder(FlutterBoostActivity.class)
                        .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                        .destroyEngineWithActivity(false)
                        .uniqueId(options.uniqueId())
                        .url(options.pageName())
                        .urlParams(options.arguments())
                        .build(FlutterBoost.instance().currentActivity());
                FlutterBoost.instance().currentActivity().startActivity(intent);
            }
        }, engine -> {
        });

        FlutterPluginNative.getInstance().init(FlutterBoost.instance().getEngine());
    }
}
