package com.icefire.chnsmile.ui.dialog.base;

import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;


public abstract class UIBottomDialog extends UIBaseDialog {

    public UIBottomDialog(@NonNull Context context) {
        super(context, R.style.ui_dialog, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
    }

    public UIBottomDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.setWindowAnimations(R.style.animstyle_ui_bottom_dialog);
    }

    @Override
    protected void onStart() {
        super.onStart();
        SpringAnimationUtils.startBottomAnim(mContentView);
    }

}
