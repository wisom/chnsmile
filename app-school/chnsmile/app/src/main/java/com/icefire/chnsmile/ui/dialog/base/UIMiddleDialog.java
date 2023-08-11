package com.icefire.chnsmile.ui.dialog.base;

import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

import androidx.annotation.NonNull;
import androidx.core.view.animation.PathInterpolatorCompat;

import com.icefire.chnsmile.R;


public abstract class UIMiddleDialog extends UIBaseDialog {
    public UIMiddleDialog(@NonNull Context context) {
        super(context, R.style.ui_dialog, Gravity.CENTER);
    }

    public UIMiddleDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId, Gravity.CENTER);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.setWindowAnimations(R.style.animstyle_ui_middle_dialog);
    }

    @Override
    protected void onStart() {
        super.onStart();
        //满足进场动画需要自定义插值器的需求
        Animation animation = AnimationUtils.loadAnimation(getContext(), R.anim.ui_middle_dialog_anim_in);
        animation.setInterpolator(PathInterpolatorCompat.create(0.25f, 0.1f, 0.25f, 1f));
        mContentView.startAnimation(animation);
    }
}
