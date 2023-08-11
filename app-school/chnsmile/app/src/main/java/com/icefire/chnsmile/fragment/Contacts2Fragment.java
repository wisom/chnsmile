package com.icefire.chnsmile.fragment;

import android.Manifest;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.blankj.utilcode.util.AppUtils;
import com.blankj.utilcode.util.LogUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.FlutterPluginNative;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleConfirmDialog;
import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.containers.FlutterBoostFragment;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.imsdk.v2.V2TIMConversationListener;
import com.tencent.imsdk.v2.V2TIMManager;

import java.util.HashMap;
import java.util.List;

import permissions.dispatcher.NeedsPermission;
import permissions.dispatcher.OnNeverAskAgain;
import permissions.dispatcher.OnPermissionDenied;
import permissions.dispatcher.OnShowRationale;
import permissions.dispatcher.PermissionRequest;
import permissions.dispatcher.RuntimePermissions;

@RuntimePermissions
public class Contacts2Fragment extends FlutterBoostFragment {
    private V2TIMConversationListener listener;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 检测权限
        if (!AccountManager.isHuaWei()) {
            Contacts2FragmentPermissionsDispatcher.initPermissionWithPermissionCheck(this);
        }
        listener = new V2TIMConversationListener() {
            //有会话新增
            @Override
            public void onNewConversation(List<V2TIMConversation> conversationList) {
                super.onNewConversation(conversationList);
                LogUtils.d("onNewConversation: " + conversationList.toString());
            }

            // 有会话更新
            @Override
            public void onConversationChanged(List<V2TIMConversation> conversationList) {
                super.onConversationChanged(conversationList);
                LogUtils.d("conversationList: " + conversationList.toString());
            }

            // 会话未读总数变更通知
            @Override
            public void onTotalUnreadMessageCountChanged(long totalUnreadCount) {
                super.onTotalUnreadMessageCountChanged(totalUnreadCount);
                LogUtils.d("onTotalUnreadMessageCountChanged: " + totalUnreadCount);
                FlutterPluginNative.getInstance().triggerIM(new HashMap());
            }
        };
        V2TIMManager.getConversationManager().addConversationListener(listener);
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        LogUtils.e("onHiddenChanged: " + hidden);
        if (hidden) {
            V2TIMManager.getConversationManager().removeConversationListener(listener);
        } else {
            V2TIMManager.getConversationManager().addConversationListener(listener);
        }
    }

    // 权限开始
    @NeedsPermission({Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void initPermission() {
    }

    @OnShowRationale({Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void showPermission(final PermissionRequest request) {
        MiddleConfirmDialog dialog = new MiddleConfirmDialog(getActivity(), getString(R.string.capture_permission_title),
                getString(R.string.capture_permission_message),
                getString(R.string.capture_permission_never_ask_cancel),
                getString(R.string.capture_permission_never_ask_setting),
                false,
                new MiddleConfirmDialog.MiddleConfirmCallback() {
                    @Override
                    public void onLeftClick(String content) {

                    }

                    @Override
                    public void onRightClick(String content) {
                        AppUtils.launchAppDetailsSettings();
                    }

                    @Override
                    public void onCancel() {

                    }
                });
        dialog.show();
    }

    @OnPermissionDenied({Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void deniedPermission() {
        Toast.makeText(getActivity(), getString(R.string.capture_permission_never_ask), Toast.LENGTH_SHORT).show();
    }

    @OnNeverAskAgain({Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void neverAskPermission() {
        MiddleConfirmDialog dialog = new MiddleConfirmDialog(getActivity(), getString(R.string.capture_permission_title),
                getString(R.string.capture_permission_never_ask_message),
                getString(R.string.capture_permission_never_ask_cancel),
                getString(R.string.capture_permission_never_ask_setting),
                false,
                new MiddleConfirmDialog.MiddleConfirmCallback() {
                    @Override
                    public void onLeftClick(String content) {

                    }

                    @Override
                    public void onRightClick(String content) {
                        AppUtils.launchAppDetailsSettings();
                    }

                    @Override
                    public void onCancel() {

                    }
                });
        dialog.show();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Contacts2FragmentPermissionsDispatcher.onRequestPermissionsResult(this, requestCode, grantResults);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        V2TIMManager.getConversationManager().removeConversationListener(listener);
    }
}
