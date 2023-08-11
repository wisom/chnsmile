package com.icefire.chnsmile.ui.dialog.dialog;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.base.UIMiddleDialog;

import java.io.IOException;

import pl.droidsonroids.gif.GifDrawable;
import pl.droidsonroids.gif.GifImageView;


public class MiddleLoadingDialog extends UIMiddleDialog {

    private String mMessage;

    /**
     * 默认文案加载中的样式
     *
     * @param context
     */
    public MiddleLoadingDialog(@NonNull Context context) {
        this(context, "加载中...");
    }

    /**
     * @param context
     * @param message 文案
     */
    public MiddleLoadingDialog(@NonNull Context context, String message) {
        this(context, message, false);
    }

    /**
     * @param context
     * @param message    文案
     * @param cancelable 是否允许关闭
     */
    public MiddleLoadingDialog(@NonNull Context context, String message, boolean cancelable) {
        super(context, R.style.ui_no_dim_dialog);
        mMessage = message;
        setCancelable(cancelable);
        setCanceledOnTouchOutside(false);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.setWindowAnimations(0);
    }


    @Override
    protected View createContentView() {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.ui_dialog_loading, null);
        GifImageView ivIcon = (GifImageView) rootView.findViewById(R.id.popupview_loading_iv);
        TextView tvMessage = (TextView) rootView.findViewById(R.id.popupview_loading_tv);
        tvMessage.setText(mMessage);

        try {
            GifDrawable gifFromResource = new GifDrawable(getContext().getResources(), R.drawable.common_animaiton_loading);
            gifFromResource.setLoopCount(1000);
            ivIcon.setImageDrawable(gifFromResource);
            gifFromResource.start();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return rootView;
    }


}
