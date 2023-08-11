package com.icefire.chnsmile.activity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.arch.core.executor.ArchTaskExecutor;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.util.AppUtils;
import com.blankj.utilcode.util.DeviceUtils;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ToastUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.adapters.ContactsAdapter;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.FlutterPluginNative;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.fragment.Contacts2Fragment;
import com.icefire.chnsmile.fragment.ContactsFragment;
import com.icefire.chnsmile.fragment.HomeFragment;
import com.icefire.chnsmile.fragment.MessageFragment;
import com.icefire.chnsmile.fragment.MineFragment;
import com.icefire.chnsmile.fragment.NewsFragment;
import com.icefire.chnsmile.fragment.OAFragment;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.manager.UserManager;
import com.icefire.chnsmile.model.Client;
import com.icefire.chnsmile.model.Contact;
import com.icefire.chnsmile.model.UnReadNotice;
import com.icefire.chnsmile.model.UnReadNum;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleConfirmDialog;
import com.icefire.chnsmile.uils.MyFragmentManager;
import com.icefire.chnsmile.uils.SystemUtils;
import com.icefire.chnsmile.views.BadgeTextView;
import com.idlefish.flutterboost.EventListener;
import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.ListenerRemover;
import com.igexin.sdk.PushManager;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.imsdk.v2.V2TIMConversationListener;
import com.tencent.imsdk.v2.V2TIMManager;
import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;
import com.tencent.smtt.sdk.TbsDownloader;
import com.tencent.smtt.sdk.TbsListener;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import permissions.dispatcher.NeedsPermission;
import permissions.dispatcher.OnNeverAskAgain;
import permissions.dispatcher.OnPermissionDenied;
import permissions.dispatcher.OnShowRationale;
import permissions.dispatcher.PermissionRequest;
import permissions.dispatcher.RuntimePermissions;

//@RuntimePermissions
@Route(path = Constants.SP_BASE_MAIN)
public class MainActivity extends BaseActivity implements View.OnClickListener {

    private static final int HOME_FRATMENT = 0;
    private static final int NEWS_FRATMENT = 1;
    private static final int MESSAGE_FRATMENT = 2;
    private static final int OA_FRATMENT = 2;
    private static final int CONTACTS_FRATMENT = 3;
    private static final int MINE_FRATMENT = 4;

    private HomeFragment homeFragment;
    private NewsFragment newsFragment;
    private MessageFragment messageFragment;
    private OAFragment oaFragment;
    private Contacts2Fragment contactsFragment;
    private Contacts2Fragment teacherContactFragment;
    private MineFragment mineFragment;

    private static final int TAB_COUNT = 5;
    private View[] mTabBars = new View[TAB_COUNT];

    private int mFragmentId = HOME_FRATMENT;
    private long mExtTime;
    private MyFragmentManager mFragmentManager;
    private HashMap urlParams;

    private BadgeTextView mHomeBadge;
    private BadgeTextView mNewsBadge;
    private BadgeTextView mMessageBadge;
    private BadgeTextView mContactBadge;
    private BadgeTextView mMineBadge;
    private Handler mHandler = new Handler(Looper.getMainLooper()); // 全局变量
    private Runnable runnable;
    private ListenerRemover remover;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        urlParams = new HashMap();
        urlParams.put("isFromNative", true);
        urlParams.put("token", AccountManager.getToken());

        mFragmentManager = new MyFragmentManager(this);
        initBottomTab();
        initFragments();
        switchFragment(HOME_FRATMENT);
        initData();
        SystemUtils.initX5(this);
        EventBus.getDefault().register(this);
        remover = FlutterBoost.instance().addEventListener("triggerUnRead", new EventListener() {
            @Override
            public void onEvent(String key, Map<Object, Object> args) {
                getUnReadNum();
            }
        });
    }

    private void getPolling() {
        runnable = new Runnable() {
            @Override
            public void run() {
                mHandler.postDelayed(this, 5 * 1000);
                //需要做轮询的方法
                getUnReadNum();
            }
        };
        mHandler.postDelayed(runnable, 5 * 1000);
    }

    @Subscribe
    public void onUnRead(UnReadNotice unReadNotice) {
        getUnReadNum();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (remover != null) {
            remover.remove();
        }
        EventBus.getDefault().unregister(this);
    }

//    @Override
//    protected void onStart() {
//        super.onStart();
//        // 检测权限
//        MainActivityPermissionsDispatcher.initPermissionWithPermissionCheck(this);
//    }


    @Override
    protected void onPause() {
        super.onPause();
        //关闭定时任务
        mHandler.removeCallbacks(runnable);
    }

    @Override
    protected void onResume() {
        super.onResume();
        getUnReadNum();
        getPolling();
    }

    private void getUnReadNum() {
        ApiService.get(Constants.SERVER_URL_UNREADNUM_CONTACT).execute(new JsonCallback<UnReadNum>() {
            @SuppressLint("RestrictedApi")
            @Override
            public void onSuccess(ApiResponse<UnReadNum> response) {
                ArchTaskExecutor.getMainThreadExecutor().execute(new Runnable() {
                    @Override
                    public void run() {
                        if (response.body != null ){
                            UnReadNum unReadNum = response.body;
                            try {
                                PushManager.getInstance().setBadgeNum(MainActivity.this, Integer.parseInt(unReadNum.app));
                                mHomeBadge.setSmallBadge(Integer.parseInt(unReadNum.home));
                                mNewsBadge.setSmallBadge(Integer.parseInt(unReadNum.zjlt));
                                mMessageBadge.setSmallBadge(Integer.parseInt(UserManager.getInstance().isTeacher() ? unReadNum.ydbg : unReadNum.xx));
                                mContactBadge.setSmallBadge(Integer.parseInt(unReadNum.txl));
                                mMineBadge.setSmallBadge(Integer.parseInt(unReadNum.more));
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }

                    }
                });
            }

            @Override
            public void onError(ApiResponse<UnReadNum> response) {
                super.onError(response);
            }
        });
    }

    private void initData() {
        bindClientId();
        V2TIMManager.getConversationManager().addConversationListener(new V2TIMConversationListener() {
            // 会话未读总数变更通知
            @Override
            public void onTotalUnreadMessageCountChanged(long totalUnreadCount) {
                super.onTotalUnreadMessageCountChanged(totalUnreadCount);
                getUnReadNum();
            }
        });
    }

    private void initFragments() {
        homeFragment = new HomeFragment
                .CachedEngineFragmentBuilder(HomeFragment.class)
                .url("home_page")
                .urlParams(urlParams)
                .build();
        newsFragment = new NewsFragment
                .CachedEngineFragmentBuilder(NewsFragment.class)
                .url("news_page")
                .urlParams(urlParams)
                .build();
        messageFragment = new MessageFragment
                .CachedEngineFragmentBuilder(MessageFragment.class)
                .url("message_page")
                .urlParams(urlParams)
                .build();
        oaFragment = new OAFragment
                .CachedEngineFragmentBuilder(OAFragment.class)
                .url("oa_page")
                .urlParams(urlParams)
                .build();
        contactsFragment = new Contacts2Fragment
                .CachedEngineFragmentBuilder(Contacts2Fragment.class)
                .url("contact_page")
                .urlParams(urlParams)
                .build();
        teacherContactFragment = new Contacts2Fragment
                .CachedEngineFragmentBuilder(Contacts2Fragment.class)
                .url("teacher_contact_page")
                .urlParams(urlParams)
                .build();
        mineFragment = new MineFragment
                .CachedEngineFragmentBuilder(MineFragment.class)
                .url("mine_page")
                .urlParams(urlParams)
                .build();
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onMessageEvent(Client event) {
        LogUtils.d("event:=======" + event.getClientId());
//        bindClientId();
    }

    int count = 0;
    private void bindClientId() {
        count++;
        String clientid = ConfigurationManager.instance().getString(Constants.PREF_KEY_GETUI_CID);
//        if (!TextUtils.isEmpty(clientid)) {
//            LogUtils.i("已经绑定过，不需要绑了：" + clientid);
//            return;
//        }
        ApiService.post(Constants.SERVER_URL_BINDCID)
                .addParam("cid", clientid)
                .addParam("brand", DeviceUtils.getManufacturer())
                .execute(new JsonCallback<String>() {
                    @Override
                    public void onSuccess(ApiResponse<String> response) {
                        LogUtils.i("绑定成功:" + response.message);
                        if (response.code != 200) {
//                            ConfigurationManager.instance().remove(Constants.PREF_KEY_GETUI_CID);
                        }
                        if (count <= 1 && response.code == 500) {
                            bindClientId();
                        }
                    }

                    @Override
                    public void onError(ApiResponse<String> response) {
                        LogUtils.e("绑定失败:" + response.message);
//                        ConfigurationManager.instance().remove(Constants.PREF_KEY_GETUI_CID);
                    }
                });
    }


    private void switchFragment(int type) {
        mFragmentId = type;

        changeTab(type);
        Bundle extras = getIntent().getExtras();
        switch (type) {
            case HOME_FRATMENT:
                mFragmentManager.switchFragment(homeFragment);
                break;
            case NEWS_FRATMENT:
                mFragmentManager.switchFragment(newsFragment);
                break;
            case MESSAGE_FRATMENT:
                if (UserManager.getInstance().isTeacher()) {
                    mFragmentManager.switchFragment(oaFragment);
                } else {
                    mFragmentManager.switchFragment(messageFragment);
                }
                break;
            case CONTACTS_FRATMENT:
                if (UserManager.getInstance().isTeacher()) {
                    mFragmentManager.switchFragment(teacherContactFragment);
                } else {
                    mFragmentManager.switchFragment(contactsFragment);
                }
                break;
            case MINE_FRATMENT:
                mFragmentManager.switchFragment(mineFragment);
                break;
        }
    }

    private void changeTab(int type) {
        for (int i = 0; i < TAB_COUNT; i++) {
            if (i == type) {
                mTabBars[i].setSelected(true);
            } else {
                mTabBars[i].setSelected(false);
            }
        }
    }

    private void initBottomTab() {
        mHomeBadge = findViewById(R.id.tv_badge_home);
        mNewsBadge = findViewById(R.id.tv_badge_news);
        mMessageBadge = findViewById(R.id.tv_badge_message);
        mContactBadge = findViewById(R.id.tv_badge_contact);
        mMineBadge = findViewById(R.id.tv_badge_mine);

        ImageView messageIcon = findViewById(R.id.tab_message_icon);
        TextView messageText = findViewById(R.id.tab_message_text);
        if (UserManager.getInstance().isTeacher()) {
            messageIcon.setImageDrawable(getResources().getDrawable(R.drawable.selector_oa));
            messageText.setText(getResources().getString(R.string.tab_oa));
        } else {
            messageIcon.setImageDrawable(getResources().getDrawable(R.drawable.selector_message));
            messageText.setText(getResources().getString(R.string.tab_message));
        }
        mTabBars[0] = findViewById(R.id.tab_home);
        mTabBars[1] = findViewById(R.id.tab_news);
        mTabBars[2] = findViewById(R.id.tab_message);
        mTabBars[3] = findViewById(R.id.tab_contacts);
        mTabBars[4] = findViewById(R.id.tab_mine);

        for (int i = 0; i < TAB_COUNT; i++) {
            mTabBars[i].setOnClickListener(this);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tab_home:
                if (mFragmentId != HOME_FRATMENT) {
                    switchFragment(HOME_FRATMENT);
                }
                break;
            case R.id.tab_news:
                if (mFragmentId != NEWS_FRATMENT) {
                    switchFragment(NEWS_FRATMENT);
                }
                break;
            case R.id.tab_message:
                if (mFragmentId != MESSAGE_FRATMENT) {
                    switchFragment(MESSAGE_FRATMENT);
                }
                break;
            case R.id.tab_contacts:
                if (mFragmentId != CONTACTS_FRATMENT) {
                    switchFragment(CONTACTS_FRATMENT);
                }
                FlutterPluginNative.getInstance().switchTab();
                break;
            case R.id.tab_mine:
                if (mFragmentId != MINE_FRATMENT) {
                    switchFragment(MINE_FRATMENT);
                }
                break;
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if ((System.currentTimeMillis() - mExtTime) > 2000) {
                ToastUtils.showShort(R.string.press_back_twice);
                mExtTime = System.currentTimeMillis();
            } else {
                if (!isFinishing()) {
                    Process.killProcess(Process.myPid());
                }
            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    // 权限开始
//    @NeedsPermission({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE})
//    void initPermission() {
//    }
//
//    @OnShowRationale({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE})
//    void showPermission(final PermissionRequest request) {
//        MiddleConfirmDialog dialog = new MiddleConfirmDialog(this, getString(R.string.capture_permission_title),
//                getString(R.string.capture_permission_message),
//                getString(R.string.capture_permission_never_ask_cancel),
//                getString(R.string.capture_permission_never_ask_setting),
//                false,
//                new MiddleConfirmDialog.MiddleConfirmCallback() {
//                    @Override
//                    public void onLeftClick(String content) {
//
//                    }
//
//                    @Override
//                    public void onRightClick(String content) {
//                        AppUtils.launchAppDetailsSettings();
//                    }
//
//                    @Override
//                    public void onCancel() {
//
//                    }
//                });
//        dialog.show();
//    }
//
//    @OnPermissionDenied({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE})
//    void deniedPermission() {
//        Toast.makeText(this, getString(R.string.capture_permission_never_ask), Toast.LENGTH_SHORT).show();
//    }
//
//    @OnNeverAskAgain({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE})
//    void neverAskPermission() {
//        MiddleConfirmDialog dialog = new MiddleConfirmDialog(this, getString(R.string.capture_permission_title),
//                getString(R.string.capture_permission_never_ask_message),
//                getString(R.string.capture_permission_never_ask_cancel),
//                getString(R.string.capture_permission_never_ask_setting),
//                false,
//                new MiddleConfirmDialog.MiddleConfirmCallback() {
//                    @Override
//                    public void onLeftClick(String content) {
//
//                    }
//
//                    @Override
//                    public void onRightClick(String content) {
//                        AppUtils.launchAppDetailsSettings();
//                    }
//
//                    @Override
//                    public void onCancel() {
//
//                    }
//                });
//        dialog.show();
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//        MainActivityPermissionsDispatcher.onRequestPermissionsResult(this, requestCode, grantResults);
//    }
}