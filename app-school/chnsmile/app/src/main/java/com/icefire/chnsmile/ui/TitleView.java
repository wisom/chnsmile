package com.icefire.chnsmile.ui;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blankj.utilcode.util.ActivityUtils;
import com.blankj.utilcode.util.ConvertUtils;
import com.icefire.chnsmile.R;

public class TitleView extends RelativeLayout {

    private TextView backButton;
    private TextView titleView;
    private TextView rightTextView;
    private View dividerView;
    private ImageView rightImageView;
    private OnBackPressedCallBack onBackPressedCallBack;
    private RightTextClickCallBack rightTextClick;
    private OnClickListener onBackClickListener = new OnClickListener() {
        @Override
        public void onClick(View v) {
            if (onBackPressedCallBack != null) {
                onBackPressedCallBack.onBackPressedTitle();
            } else {
                Activity activity = ActivityUtils.getTopActivity();
                activity.finish();
            }
        }
    };


    private OnClickListener onRightTextClickListener = new OnClickListener() {
        @Override
        public void onClick(View v) {
            if (rightTextClick != null) {
                rightTextClick.onRightClick();
            }
        }
    };

    public TitleView(Context context) {
        this(context, null);
    }

    public TitleView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public TitleView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TitleView);
        LayoutInflater.from(context).inflate(R.layout.view_title_bar, this, true);
        initView();

        boolean enableBack = a.getBoolean(R.styleable.TitleView_enableBack, true);
        disableBack(enableBack);
        String backButtonName = a.getString(R.styleable.TitleView_backButtonName);
        setBackButtonName(backButtonName);
        int backButtonColor = a.getInteger(R.styleable.TitleView_backButtonColor, -1);
        setBackButtonColor(backButtonColor);
        float backButtonSize = a.getDimensionPixelSize(R.styleable.TitleView_backButtonSize, -1);
        setBackButtonSize(backButtonSize);

        String titleName = a.getString(R.styleable.TitleView_titleName);
        setTitle(titleName);
        int titleColor = a.getInteger(R.styleable.TitleView_titleColor, -1);
        setTitleColor(titleColor);
        float titleSize = a.getDimensionPixelSize(R.styleable.TitleView_titleSize, -1);
        setTitleSize(titleSize);

        String rightText = a.getString(R.styleable.TitleView_rightText);
        setRightText(rightText);
        int rightTextColor = a.getInteger(R.styleable.TitleView_rightTextColor, -1);
        setRightTextColor(rightTextColor);
        float rightTextSize = a.getDimensionPixelSize(R.styleable.TitleView_rightTextSize, -1);
        setRightTextSize(rightTextSize);
        int rightImg = a.getResourceId(R.styleable.TitleView_rightImg, -1);
        setRightImage(rightImg);

        int dividerColor = a.getInteger(R.styleable.TitleView_dividerColor, -1);
        setDividerColor(dividerColor);

        a.recycle();

    }

    private void setDividerColor(int dividerColor) {
        if (-1 != dividerColor) {
            dividerView.setBackgroundColor(dividerColor);
        }
    }

    private void setBackButtonSize(float backButtonSize) {
        if (-1 != backButtonSize) {
            setRawTextSize(backButton, backButtonSize);
        }
    }

    private void setBackButtonColor(int backButtonColor) {
        if (-1 != backButtonColor) {
            backButton.setTextColor(backButtonColor);
        }
    }

    private void setBackButtonName(String backButtonName) {
        backButton.setText(backButtonName);
    }

    private void initView() {
        titleView = findViewById(R.id.view_title_text);
        rightTextView = findViewById(R.id.view_right_text);
        rightTextView.setOnClickListener(onRightTextClickListener);
        rightImageView = findViewById(R.id.view_right_img);
        rightImageView.setOnClickListener(onRightTextClickListener);
        dividerView = findViewById(R.id.view_divider);
        backButton = findViewById(R.id.view_title_back_text);
        backButton.setOnClickListener(onBackClickListener);
    }

    public void setTitle(String titleName) {
        titleView.setText(titleName);
    }

    private void setTitleSize(float titleSize) {
        if (-1 != titleSize) {
            setRawTextSize(titleView, titleSize);
        }
    }

    private void setTitleColor(int titleColor) {
        if (-1 != titleColor) {
            titleView.setTextColor(titleColor);
        }
    }

    public void setRightText(String titleName) {
        rightTextView.setVisibility(VISIBLE);
        rightTextView.setText(titleName);
    }

    private void setRightTextColor(int rightTextColor) {
        if (-1 != rightTextColor) {
            rightTextView.setTextColor(rightTextColor);
        }
    }

    private void setRightTextSize(float rightTextSize) {
        if (-1 != rightTextSize) {
            setRawTextSize(rightTextView, rightTextSize);
        }
    }

    public void setRightImage(int drawableId) {
        if (-1 != drawableId) {
            rightImageView.setVisibility(VISIBLE);
            rightImageView.setImageResource(drawableId);
        }
    }

    public void disableBack(Boolean enableBack) {
        backButton.setVisibility(enableBack ? VISIBLE : GONE);
    }

    public void setOnBackPressedCallBack(OnBackPressedCallBack onBackPressedCallBack) {
        this.onBackPressedCallBack = onBackPressedCallBack;
    }

    public void setOnRightTextClick(RightTextClickCallBack rightTextClick) {
        this.rightTextClick = rightTextClick;
    }

    public void setRawTextSize(TextView textView, float size) {
        textView.setTextSize(TypedValue.COMPLEX_UNIT_DIP, ConvertUtils.px2dp(size));
    }

    public interface OnBackPressedCallBack {
        void onBackPressedTitle();
    }

    public interface RightTextClickCallBack {
        void onRightClick();
    }


}
