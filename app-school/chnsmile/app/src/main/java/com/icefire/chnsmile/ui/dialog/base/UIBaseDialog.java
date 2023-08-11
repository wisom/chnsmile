package com.icefire.chnsmile.ui.dialog.base;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;

public abstract class UIBaseDialog extends Dialog {

    protected View mContentView;
    protected int mGravity;
    protected Context mContext;

    /**
     * 和activity style 一致的dialog
     *
     * @param context
     * @param gravity
     */
    public UIBaseDialog(@NonNull Context context, int gravity) {
        this(context, android.R.style.Theme_Holo_Dialog, gravity);
    }

    public UIBaseDialog(@NonNull Context context, int themeResId, int gravity) {
        super(context, themeResId);
        mContext = context;
        mGravity = gravity;
    }

    /**
     * 创建dialog 内容view
     *
     * @return
     */
    protected abstract View createContentView();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContentView = createContentView();

        Window window = this.getWindow();
        window.setGravity(mGravity);

        setContentView(mContentView);

        WindowManager.LayoutParams params = window.getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        window.setAttributes(params);


    }


}
