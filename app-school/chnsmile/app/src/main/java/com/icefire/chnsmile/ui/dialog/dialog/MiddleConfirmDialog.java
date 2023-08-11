package com.icefire.chnsmile.ui.dialog.dialog;

import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.ColorInt;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.base.UIMiddleDialog;

public class MiddleConfirmDialog extends UIMiddleDialog implements DialogInterface.OnCancelListener, View.OnClickListener {

    private final MiddleConfirmCallback mCallback;

    private boolean mAutoClickButtonCancel;
    private int mIconRes;
    private String mTitle;
    private String mContent;
    private String mLeftbutton;
    private String mRightButton;
    private int rightColor;
    private boolean isRightBold;
    private int leftColor;
    private boolean isLeftBold;
    private boolean mShowClose;

    /**
     * @param context
     * @param title
     * @param content
     * @param content     如果是空数据 则不显示内容控件
     * @param leftbutton  如果是空数据 则只显示一个确认按钮
     * @param rightButton
     * @param cancelable  是否允许关闭
     * @param callback
     */
    public MiddleConfirmDialog(@NonNull Context context, String title, String content, String leftbutton, String rightButton, boolean cancelable, MiddleConfirmCallback callback) {
        this(context, 0, title, content, leftbutton, rightButton, cancelable, true, false, callback);
    }

    /**
     * @param context
     * @param title
     * @param content               如果是空数据 则不显示内容控件
     * @param leftbutton            如果是空数据 则只显示一个确认按钮
     * @param rightButton
     * @param cancelable            是否允许关闭
     * @param autoClickButtonCancel 点击按钮是否自动关闭dialog
     * @param callback
     */
    public MiddleConfirmDialog(@NonNull Context context, String title, String content, String leftbutton, String rightButton, boolean cancelable, boolean autoClickButtonCancel, MiddleConfirmCallback callback) {
        this(context, 0, title, content, leftbutton, rightButton, cancelable, autoClickButtonCancel, false, callback);
    }

    /**
     * @param context
     * @param iconRes
     * @param title
     * @param content               如果是空数据 则不显示内容控件
     * @param leftbutton            如果是空数据 则只显示一个确认按钮
     * @param rightButton
     * @param cancelable            是否允许关闭
     * @param autoClickButtonCancel 点击按钮是否自动关闭dialog
     * @param callback
     */
    public MiddleConfirmDialog(@NonNull Context context, @DrawableRes int iconRes, String title, String content, String leftbutton, String rightButton,
                               boolean cancelable, boolean autoClickButtonCancel, boolean showClose, MiddleConfirmCallback callback) {
        super(context);
        mIconRes = iconRes;
        mTitle = title;
        mContent = content;
        mLeftbutton = leftbutton;
        mRightButton = rightButton;
        mCallback = callback;
        mAutoClickButtonCancel = autoClickButtonCancel;
        this.mShowClose = showClose;

        setCanceledOnTouchOutside(cancelable);
        setCancelable(cancelable);

        setOnCancelListener(this);
    }

    /**
     * 设置左边按钮颜色
     *
     * @param color 右边按钮颜色
     */
    public void setLeftButtonColor(@ColorInt int color) {
        rightColor = color;
    }

    /**
     * 设置右边按钮颜色
     *
     * @param color 右边按钮颜色
     */
    public void setRightButtonColor(@ColorInt int color) {
        leftColor = color;
    }


    public void setRightBold(boolean rightBold) {
        isRightBold = rightBold;
    }

    public void setLeftBold(boolean leftBold) {
        isLeftBold = leftBold;
    }

    @Override
    protected View createContentView() {
        View root;
        if (mIconRes > 0) {
            root = LayoutInflater.from(mContext).inflate(R.layout.ui_dialog_icon_confirm, null);
        } else {
            root = LayoutInflater.from(mContext).inflate(R.layout.ui_dialog_middle_confirm, null);
        }

        ImageView iconIv = (ImageView) root.findViewById(R.id.cccx_ui_middle_dialog_icon);
        TextView tvTitle = (TextView) root.findViewById(R.id.cccx_ui_middle_dialog_title);
        TextView tvContent = (TextView) root.findViewById(R.id.cccx_ui_middle_dialog_content);
        View ivClose = root.findViewById(R.id.cccx_ui_middle_dialog_close);
        View rlImageContainer = root.findViewById(R.id.rl_image_container);

        ivClose.setVisibility(mShowClose ? View.VISIBLE : View.GONE);
        ivClose.setOnClickListener(this);
        final TextView leftBtn = (TextView) root.findViewById(R.id.cccx_ui_middle_dialog_tv_left);
        final TextView rightBtn = (TextView) root.findViewById(R.id.cccx_ui_middle_dialog_tv_right);
        if (rightColor != 0) {
            rightBtn.setTextColor(rightColor);
            rightBtn.setTypeface(isRightBold ? Typeface.defaultFromStyle(Typeface.BOLD) : Typeface.defaultFromStyle(Typeface.NORMAL));
        }

        if (leftColor != 0) {
            leftBtn.setTextColor(leftColor);
            leftBtn.setTypeface(isLeftBold ? Typeface.defaultFromStyle(Typeface.BOLD) : Typeface.defaultFromStyle(Typeface.NORMAL));
        }

        View bottomDevider = root.findViewById(R.id.cccx_ui_middle_dialog_bottom_divider);


        //设置数据
        if (mIconRes > 0) {
            rlImageContainer.setVisibility(View.VISIBLE);
            iconIv.setVisibility(View.VISIBLE);
            iconIv.setBackgroundResource(mIconRes);
        }

        if (TextUtils.isEmpty(mTitle)) {
            tvTitle.setVisibility(View.GONE);
        } else {
            tvTitle.setText(mTitle);
            tvTitle.setVisibility(View.VISIBLE);
        }


        if (TextUtils.isEmpty(mContent)) {
            tvContent.setVisibility(View.GONE);
        } else {
            tvContent.setText(mContent);
        }

        rightBtn.setBackgroundResource(R.drawable.ui_dialog_right_press_shape);
        if (TextUtils.isEmpty(mLeftbutton)) {
            leftBtn.setVisibility(View.GONE);
            bottomDevider.setVisibility(View.GONE);
            rightBtn.setBackgroundResource(R.drawable.ui_dialog_center_press_shape);
        } else {
            leftBtn.setText(mLeftbutton);
        }

        rightBtn.setText(mRightButton);


        final View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mCallback != null) {
                    if (v == leftBtn) {
                        mCallback.onLeftClick(leftBtn.getText().toString());
                    } else if (v == rightBtn) {
                        mCallback.onRightClick(rightBtn.getText().toString());
                    }
                }

                if (mAutoClickButtonCancel) {
                    dismiss();
                }
            }
        };

        leftBtn.setOnClickListener(listener);
        rightBtn.setOnClickListener(listener);

        return root;
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        if (mCallback != null) {
            mCallback.onCancel();
        }
    }

    @Override
    public void onClick(View v) {
        if (mCallback != null) {
            mCallback.onCancel();
        }
        dismiss();
    }

    public interface MiddleConfirmCallback {
        /**
         * 左边按钮点击回调
         *
         * @param content
         */
        void onLeftClick(String content);

        /**
         * 右边按钮点击回调
         *
         * @param content
         */
        void onRightClick(String content);

        /**
         * 点击后退 或 点击内容外部阴影区域
         */
        void onCancel();
    }

    /**
     * MiddleConfirmCallback 的简单实现抽象类
     */
    public abstract class SimpleMiddleConfirmCallback implements MiddleConfirmCallback {
        @Override
        public void onLeftClick(String content) {

        }

        @Override
        public void onCancel() {

        }
    }
}
