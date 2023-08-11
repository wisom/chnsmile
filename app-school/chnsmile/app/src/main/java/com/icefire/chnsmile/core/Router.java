package com.icefire.chnsmile.core;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.alibaba.android.arouter.launcher.ARouter;
import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public final class Router {

    public static void open(String path) {
        open(path, 0);
    }

    public static void open(String path, int flags) {
        ARouter.getInstance().build(Uri.parse(path))
                .addFlags(flags)
                .navigation();
    }

    /**
     * 打开flutter页面
     *
     * @param pageName  页面
     */
    public static void openFlutter(String pageName) {
        openFlutter(pageName, new HashMap<>());
    }

    public static void openFlutter(String pageName, HashMap arguments) {
        FlutterBoost.instance().open(pageName, arguments);
    }

    /**
     * 打开flutter页面并且返回
     *
     * @param activity
     * @param pageName
     * @param REQUEST_CODE
     */
    public static void openFluterForResult(Activity activity, String pageName, int REQUEST_CODE) {
        openFluterForResult(activity, pageName, new HashMap(), REQUEST_CODE);
    }

    public static void openFluterForResult(Activity activity, String pageName, HashMap arguments, int REQUEST_CODE) {
        Intent intent = new FlutterBoostActivity.CachedEngineIntentBuilder(FlutterBoostActivity.class)
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.opaque)
                .destroyEngineWithActivity(false)
                .url(pageName)
                .urlParams(arguments)
                .build(activity);
        activity.startActivityForResult(intent, REQUEST_CODE);
    }

    /**
     * 关闭flutter页面
     *
     * @param uniqueId
     */
    public static void closeFlutter(String uniqueId) {
        FlutterBoost.instance().close(uniqueId);
    }
}
