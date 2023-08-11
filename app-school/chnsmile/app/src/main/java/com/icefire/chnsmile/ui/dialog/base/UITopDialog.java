package com.icefire.chnsmile.ui.dialog.base;

import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;


/**
 */
public abstract class UITopDialog extends UIBaseDialog {
    public UITopDialog(@NonNull Context context) {
        super(context, R.style.ui_dialog, Gravity.TOP | Gravity.CENTER_HORIZONTAL);
    }

    public UITopDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId, Gravity.TOP | Gravity.CENTER_HORIZONTAL);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.setWindowAnimations(R.style.animstyle_ui_top_dialog);
    }
}
