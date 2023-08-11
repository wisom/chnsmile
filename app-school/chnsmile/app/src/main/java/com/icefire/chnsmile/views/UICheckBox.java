package com.icefire.chnsmile.views;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.BounceInterpolator;
import android.widget.Checkable;

import androidx.annotation.Nullable;

import com.blankj.utilcode.util.AdaptScreenUtils;
import com.icefire.chnsmile.R;


public class UICheckBox extends View implements Checkable {
    private static final String KEY_INSTANCE_STATE = "InstanceState";
    private static final int DEF_DRAW_SIZE = 18;

    private boolean mEnable;
    private boolean mChecked;
    private OnCheckedChangeListener mListener;
    private boolean mAnim;
    private int mMeasureWidth;
    private int mMeasureHeight;
    private Drawable mNormalBgDrawable;
    private Drawable mCheckedBgDrawable;
    private Drawable mUnableBgDrawable;


    public UICheckBox(Context context) {
        this(context, null);
    }

    public UICheckBox(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public UICheckBox(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(attrs);
    }

    private void initView(AttributeSet attrs) {
        TypedArray ta = getContext().obtainStyledAttributes(attrs, R.styleable.UXUICheckBox);
        mChecked = ta.getBoolean(R.styleable.UXUICheckBox_uxui_check_box_state_checked, false);
        mAnim = ta.getBoolean(R.styleable.UXUICheckBox_uxui_check_box_anim_enable, true);
        mEnable = ta.getBoolean(R.styleable.UXUICheckBox_uxui_check_box_state_enable, true);

        mNormalBgDrawable = ta.getDrawable(R.styleable.UXUICheckBox_uxui_check_box_normal_drawable);
        mCheckedBgDrawable = ta.getDrawable(R.styleable.UXUICheckBox_uxui_check_box_checked_drawable);
        mUnableBgDrawable = ta.getDrawable(R.styleable.UXUICheckBox_uxui_check_box_unable_drawable);

        setEnabled(mEnable);
        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                toggle(mAnim);
            }
        });
        ta.recycle();
    }


    private int measureSize(int measureSpec) {
        int defSize = AdaptScreenUtils.pt2Px(DEF_DRAW_SIZE);
        int specSize = MeasureSpec.getSize(measureSpec);
        int specMode = MeasureSpec.getMode(measureSpec);

        int result = 0;
        switch (specMode) {
            case MeasureSpec.UNSPECIFIED:
            case MeasureSpec.AT_MOST:
                result = Math.min(defSize, specSize);
                break;
            case MeasureSpec.EXACTLY:
                result = specSize;
                break;
        }
        return result;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        mMeasureWidth = measureSize(widthMeasureSpec);
        mMeasureHeight = measureSize(heightMeasureSpec);
        setMeasuredDimension(mMeasureWidth, mMeasureHeight);
    }

    @Override
    protected Parcelable onSaveInstanceState() {
        Bundle bundle = new Bundle();
        bundle.putParcelable(KEY_INSTANCE_STATE, super.onSaveInstanceState());
        bundle.putBoolean(KEY_INSTANCE_STATE, isChecked());
        return bundle;
    }

    @Override
    protected void onRestoreInstanceState(Parcelable state) {
        if (state instanceof Bundle) {
            Bundle bundle = (Bundle) state;
            boolean isChecked = bundle.getBoolean(KEY_INSTANCE_STATE);
            setChecked(isChecked);
            super.onRestoreInstanceState(bundle.getParcelable(KEY_INSTANCE_STATE));
            return;
        }
        super.onRestoreInstanceState(state);
    }


    @Override
    public void setChecked(boolean checked) {
        setChecked(checked, false);
    }


    public void setChecked(boolean checked, boolean anim) {
        mChecked = checked;
        if (checked) {
            if (anim) {
                setClickable(false);
            } else {
                setBackground(mCheckedBgDrawable != null ? mCheckedBgDrawable : getResources().getDrawable(R.drawable.ic_checkbox_selected));
                if (mListener != null) {
                    mListener.onCheckedChanged(this, mChecked);
                }
            }
        } else {
            setBackground(mNormalBgDrawable != null ? mNormalBgDrawable : getResources().getDrawable(R.drawable.ic_checkbox_unselected));
            if (mListener != null) {
                mListener.onCheckedChanged(this, mChecked);
            }
        }
    }


    @Override
    public boolean isChecked() {
        return mChecked;
    }

    @Override
    public void toggle() {
        toggle(true);
    }

    public void toggle(boolean anim) {
        setChecked(!mChecked, anim);
    }

    @Override
    public void setEnabled(boolean enabled) {
        super.setEnabled(enabled);
        mEnable = enabled;
        invalidBgDrawable();
    }

    private void invalidBgDrawable() {
        if (mEnable) {
            if (mChecked) {
                setBackground(mCheckedBgDrawable != null ? mCheckedBgDrawable : getResources().getDrawable(R.drawable.ic_checkbox_selected));
            } else {
                setBackground(mNormalBgDrawable != null ? mNormalBgDrawable : getResources().getDrawable(R.drawable.ic_checkbox_unselected));
            }
        } else {
            setBackground(mUnableBgDrawable != null ? mUnableBgDrawable : getResources().getDrawable(R.drawable.ic_checkbox_unselected));
        }
    }

    /**
     * 所有背景，如果传null，则展示默认背景
     */
    public void setBackgoundDrawable(Drawable normalBgDrawable, Drawable checkedBgDrawable, Drawable unableBgDrawable) {
        mNormalBgDrawable = normalBgDrawable;
        mCheckedBgDrawable = checkedBgDrawable;
        mUnableBgDrawable = unableBgDrawable;
        invalidBgDrawable();
    }


    private void objectAnim() {
        ObjectAnimator animatorX = ObjectAnimator.ofFloat(this, "scaleX", 0.8f, 1.2f, 1f);
        ObjectAnimator animatorY = ObjectAnimator.ofFloat(this, "scaleY", 0.8f, 1.2f, 1f);
        AnimatorSet set = new AnimatorSet();
        //动画持续时间
        set.setDuration(250);
        //动画弹动的速度，越大越慢

        set.setInterpolator(new BounceInterpolator());
        //X轴和Y轴同时开始
        set.playTogether(animatorX, animatorY);
        //动画开始
        set.start();
    }


    public void setOnCheckedChangeListener(OnCheckedChangeListener l) {
        this.mListener = l;
    }

    public interface OnCheckedChangeListener {
        void onCheckedChanged(UICheckBox checkBox, boolean isChecked);
    }


    public OnCheckedChangeListener getListener() {
        return mListener;
    }

    public UICheckBox setListener(OnCheckedChangeListener listener) {
        mListener = listener;
        return this;
    }

    public UICheckBox setAnim(boolean anim) {
        mAnim = anim;
        return this;
    }
}
