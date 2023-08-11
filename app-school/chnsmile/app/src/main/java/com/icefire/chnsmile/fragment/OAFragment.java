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
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleConfirmDialog;
import com.idlefish.flutterboost.containers.FlutterBoostFragment;

import permissions.dispatcher.NeedsPermission;
import permissions.dispatcher.OnNeverAskAgain;
import permissions.dispatcher.OnPermissionDenied;
import permissions.dispatcher.OnShowRationale;
import permissions.dispatcher.PermissionRequest;
import permissions.dispatcher.RuntimePermissions;

@RuntimePermissions
public class OAFragment extends FlutterBoostFragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (!AccountManager.isHuaWei()) {
            OAFragmentPermissionsDispatcher.initPermissionWithPermissionCheck(this);
        }
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    // 权限开始
    @NeedsPermission({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void initPermission() {
    }

    @OnShowRationale({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
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

    @OnPermissionDenied({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
    void deniedPermission() {
        Toast.makeText(getActivity(), getString(R.string.capture_permission_never_ask), Toast.LENGTH_SHORT).show();
    }

    @OnNeverAskAgain({Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO})
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
        OAFragmentPermissionsDispatcher.onRequestPermissionsResult(this, requestCode, grantResults);
    }
}
