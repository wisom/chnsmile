package com.icefire.chnsmile.ui.dialog.dialog;

import android.content.Context;
import android.text.TextPaint;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.base.UIMiddleDialog;
import com.icefire.chnsmile.uils.ViewUtil;


/**
 * 多文字弹窗
 */
public class MuchCharacterDialog extends UIMiddleDialog implements View.OnClickListener {

    private MuchCharacterConfirmCallback mMuchCharacterConfirmCallback;
    /**
     * constant
     */
    private String mContent;
    /**
     * title
     */
    private String mTitle;
    /**
     * 是否水平
     */
    private boolean mIsHorizontal;
    /**
     * 关闭按钮是否显示
     */
    private boolean mShowClose;
    /**
     * 副按钮
     */
    private String mSubButton;
    /**
     * 主按钮
     */
    private String mButton;
    /**
     * 点击是否自动关闭弹窗
     */
    private boolean mAutoDismiss;

    /**
     * 多文字弹窗
     *
     * @param context
     * @param title                        协议标题
     * @param content                      协议内容
     * @param subButton                    副按钮
     * @param button                       主按钮
     * @param isHorizontal                 是否水平
     * @param showClose                    关闭按钮
     * @param muchCharacterConfirmCallback 弹窗的回调
     */

    public MuchCharacterDialog(@NonNull Context context, String title, String content, String subButton, String button,
                               boolean isHorizontal, boolean showClose, boolean autoClose, MuchCharacterConfirmCallback muchCharacterConfirmCallback) {
        super(context);
        this.mTitle = title;
        this.mContent = content;
        this.mMuchCharacterConfirmCallback = muchCharacterConfirmCallback;
        this.mIsHorizontal = isHorizontal;
        this.mShowClose = showClose;
        this.mSubButton = subButton;
        this.mButton = button;
        this.mAutoDismiss = autoClose;
        setCancelable(false);
    }


    @Override
    protected View createContentView() {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.ui_dialog_much_character, null);
        TextView tvTitle = rootView.findViewById(R.id.platform_home_protocol_title);
        View ivRightClose = rootView.findViewById(R.id.iv_right_close);
        TextView tvHorizontalSubTitle = rootView.findViewById(R.id.tv_horizontal_subtitle);
        TextView tvHorizontalTitle = rootView.findViewById(R.id.tv_horizontal_title);
        View vGrayLine = rootView.findViewById(R.id.v_gray_line);

        View llVerticalButtonContainer = rootView.findViewById(R.id.ll_vertical_button_container);
        View llHorizontalButtonContainer = rootView.findViewById(R.id.ll_horizontal_button_container);

        llVerticalButtonContainer.setVisibility(mIsHorizontal ? View.GONE : View.VISIBLE);
        llHorizontalButtonContainer.setVisibility(mIsHorizontal ? View.VISIBLE : View.GONE);

        final TextView tvContent = rootView.findViewById(R.id.platform_home_protocol_content);
        TextView tvReview = rootView.findViewById(R.id.platform_home_protocol_review);
        TextView tvConfirm = rootView.findViewById(R.id.platform_home_protocol_confirm);
        final ScrollView scrollView = rootView.findViewById(R.id.platform_home_protocol_scrollview);
        ivRightClose.setVisibility(mShowClose ? View.VISIBLE : View.GONE);


        int width = ViewUtil.dp2px(222);
        if (mShowClose) {
            width = ViewUtil.dp2px(174);
        }
        //计算字体大小
        tvTitle.setText(mTitle);
        TextPaint textPaint = new TextPaint(tvTitle.getPaint());
        float trySize = textPaint.getTextSize();
        while (textPaint.measureText(tvTitle.getText().toString()) > width) {
            trySize--;
            textPaint.setTextSize(trySize);
        }
        Log.e("TextPaint", textPaint.getTextSize() + "size:" + ViewUtil.px2dp(textPaint.getTextSize()));
        tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_PX, textPaint.getTextSize());

        tvContent.setText(mContent);
        tvContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                tvContent.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                int height = tvContent.getHeight();
                if (ViewUtil.dp2px(200) < height) {
                    //说明高度超过200最高的高度，设置死
                    ViewGroup.LayoutParams layoutParams = scrollView.getLayoutParams();
                    layoutParams.height = ViewUtil.dp2px(224);
                    scrollView.setLayoutParams(layoutParams);
                }
            }
        });
        if (!TextUtils.isEmpty(mSubButton)) {
            tvReview.setVisibility(View.VISIBLE);
            tvReview.setText(mSubButton);
            tvHorizontalSubTitle.setVisibility(View.VISIBLE);
            tvHorizontalSubTitle.setText(mSubButton);
        } else {
            tvReview.setVisibility(View.GONE);
            tvHorizontalSubTitle.setVisibility(View.GONE);
        }

        if (!TextUtils.isEmpty(mButton)) {
            tvConfirm.setVisibility(View.VISIBLE);
            tvHorizontalTitle.setVisibility(View.VISIBLE);
            tvConfirm.setText(mButton);
            tvHorizontalTitle.setText(mButton);
        } else {
            tvConfirm.setVisibility(View.GONE);
            tvHorizontalTitle.setVisibility(View.GONE);
        }
        llVerticalButtonContainer.setVisibility(View.GONE);
        llHorizontalButtonContainer.setVisibility(View.GONE);

        if (mIsHorizontal) {
            if (tvHorizontalSubTitle.getVisibility() == View.GONE) {
                tvHorizontalTitle.setBackgroundResource(R.drawable.ui_dialog_center_press_shape);
            } else if (tvHorizontalTitle.getVisibility() == View.GONE) {
                tvHorizontalSubTitle.setBackgroundResource(R.drawable.ui_dialog_center_press_shape);
            }
            if (tvHorizontalTitle.getVisibility() == View.GONE &&
                    tvHorizontalSubTitle.getVisibility() == View.GONE) {
                vGrayLine.setVisibility(View.GONE);
                llHorizontalButtonContainer.setVisibility(View.GONE);
            } else {
                llHorizontalButtonContainer.setVisibility(View.VISIBLE);
            }

        } else {
            if (tvConfirm.getVisibility() == View.VISIBLE && tvReview.getVisibility() == View.VISIBLE) {
                tvConfirm.getLayoutParams().height = ViewUtil.dp2px(44);
                tvReview.getLayoutParams().height = ViewUtil.dp2px(44);
            } else {
                tvConfirm.getLayoutParams().height = ViewUtil.dp2px(50);
                tvReview.getLayoutParams().height = ViewUtil.dp2px(50);
            }

            if (tvConfirm.getVisibility() == View.GONE) {
                tvReview.setBackgroundResource(R.drawable.ui_dialog_center_press_shape);
            }

            if (tvConfirm.getVisibility() == View.GONE &&
                    tvReview.getVisibility() == View.GONE) {
                vGrayLine.setVisibility(View.GONE);
                llVerticalButtonContainer.setVisibility(View.GONE);
            } else {
                llVerticalButtonContainer.setVisibility(View.VISIBLE);
            }
        }
        tvReview.setOnClickListener(this);
        ivRightClose.setOnClickListener(this);
        tvConfirm.setOnClickListener(this);
        tvHorizontalSubTitle.setOnClickListener(this);
        tvHorizontalTitle.setOnClickListener(this);

//        setOnDismissListener(new DialogInterface.OnDismissListener() {
//            @Override
//            public void onDismiss(DialogInterface dialog) {
//                if (mMuchCharacterConfirmCallback != null) {
//                    mMuchCharacterConfirmCallback.onDismiss();
//                }
//            }
//        });
        return rootView;
    }


    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.platform_home_protocol_confirm ||
                v.getId() == R.id.tv_horizontal_title) {
            if (mMuchCharacterConfirmCallback != null) {
                mMuchCharacterConfirmCallback.onRightClick(mButton);
            }
            if (mAutoDismiss) {
                dismiss();
            }
        } else if (v.getId() == R.id.platform_home_protocol_review ||
                v.getId() == R.id.tv_horizontal_subtitle) {
            if (mMuchCharacterConfirmCallback != null) {
                mMuchCharacterConfirmCallback.onLeftClick(mSubButton);
            }
            if (mAutoDismiss) {
                dismiss();
            }
        } else if (v.getId() == R.id.iv_right_close) {
            if (mMuchCharacterConfirmCallback != null) {
                mMuchCharacterConfirmCallback.onCancel();
            }
            if (mAutoDismiss) {
                dismiss();
            }
        }
    }

    public interface MuchCharacterConfirmCallback {
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


//        /**
//         * 弹窗消失的回调，如果重写setOnDismissListener将被覆盖
//         */
//        void onDismiss();
    }

    /**
     * 设置是否自动关闭
     *
     * @param mAutoDismiss 自动关闭
     */
    public void setAutoDismiss(boolean mAutoDismiss) {
        this.mAutoDismiss = mAutoDismiss;
    }
}
