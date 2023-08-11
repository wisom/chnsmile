package com.icefire.chnsmile.views;

import android.content.Context;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;

import androidx.appcompat.widget.AppCompatTextView;

import com.icefire.chnsmile.R;

/**
 * 带数字的气泡，如消息提示.  贝店修改样式
 *
 * @author xushaojie
 */
public class BadgeTextView extends AppCompatTextView {

    private static final String MAX_COUNT_MSG = "999+";

    private static final int TYPE_NUM = 1;
    private static final int TYPE_DOT = 2;
    private static final int TYPE_SMALL_NUM = 3;

    private int mDotSize;// 圆点
    private int mHeight;// 高度(以及1-9时的宽度)
    private int mWidth20;// 加长宽度
    private int mWidth27;// 超长宽度
    private int mWidth34;// 超超长宽度

    private int mType = 0;

    public BadgeTextView(Context context) {
        this(context, null);
    }

    public BadgeTextView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public BadgeTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        setTextSize(TypedValue.COMPLEX_UNIT_DIP, 10);
        setTextColor(getResources().getColor(R.color.colorAccent));
        setGravity(Gravity.CENTER);
        setIncludeFontPadding(false);// 优化文字垂直居中
        setSingleLine();

        DisplayMetrics dm = getResources().getDisplayMetrics();
        mDotSize = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 6, dm);
        mHeight = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 16, dm);
        mWidth20 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 20, dm);
        mWidth27 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 27, dm);
        mWidth34 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 34, dm);
    }

    /**
     * 设置为带数字样式，白底红字
     *
     * @param count 大于0显示，否则隐藏.
     */
    public void setBadge(int count) {
        if (count <= 0) {
            setVisibility(GONE);
            return;
        }
        setVisibility(VISIBLE);
        // 文字为主题红色
        setTextColor(getResources().getColor(R.color.colorAccent));
        // 切换到数字样式
        if (mType != TYPE_NUM) {
            setHeight(mHeight);
            setBackgroundResource(R.drawable.bd_badge_textview_bg);
            mType = TYPE_NUM;
        }
        if (count > 999) {
            setWidth(mWidth34);
            setText(MAX_COUNT_MSG);
        } else if (count > 99) {
            setWidth(mWidth27);
            setText(count + "");
        } else if (count > 9) {
            setWidth(mWidth20);
            setText(count + "");
        } else {
            setWidth(mHeight);// 圆形
            setText(count + "");
        }
    }

    /**
     * 设置为带数字样式
     *
     * @param count 大于0显示，否则隐藏.
     */
    public void setSmallBadge(int count, int textColorResId, int backgroundResId) {
        if (count <= 0) {
            setVisibility(GONE);
            return;
        }
        setVisibility(VISIBLE);
        setTextColor(getResources().getColor(textColorResId));
        // 切换到数字样式
        if (mType != TYPE_SMALL_NUM) {
            setHeight(mHeight);
            setBackgroundResource(backgroundResId);
            mType = TYPE_SMALL_NUM;
        }
        if (count > 99) {
            setWidth(mWidth27);
            setText("99+");
        } else if (count > 9) {
            setWidth(mWidth20);
            setText(count + "");
        } else {
            setWidth(mHeight);// 圆形
            setText(count + "");
        }
    }

    public void setSmallBadge(int count) {
        setSmallBadge(count, R.color.white, R.drawable.bd_badge_textview_bg_red);
    }

    /**
     * 显示为圆点样式
     */
    public void showAsDot() {
        showAsDot(mDotSize);
    }

    /**
     * 显示为圆点样式，并且根据消息数是否大于0决定显示还是隐藏.
     *
     * @param count 大于0显示，否则隐藏.
     */
    public void showAsDotByCount(int count) {
        if (count > 0) {
            showAsDot();
        } else {
            setVisibility(GONE);
        }
    }

    /**
     * 显示为圆点样式
     *
     * @param pixels 圆点直径
     */
    public void showAsDot(int pixels) {
        setVisibility(VISIBLE);
        setText("");
        setWidth(pixels);
        setHeight(pixels);
        // 切换到圆点样式
        if (mType != TYPE_DOT) {
            setBackgroundResource(R.drawable.bd_badge_dot_bg);
            mType = TYPE_DOT;
        }
    }

}
