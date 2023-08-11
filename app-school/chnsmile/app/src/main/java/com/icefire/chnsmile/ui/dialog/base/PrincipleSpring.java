package com.icefire.chnsmile.ui.dialog.base;

import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.rebound.Spring;
import com.facebook.rebound.SpringConfig;
import com.facebook.rebound.SpringListener;
import com.facebook.rebound.SpringSystem;

/**
 *
 * 弹性动画
 */
public class PrincipleSpring implements SpringListener {
    @SuppressWarnings("WeakerAccess")
    public interface PrincipleSpringListener {
        /**
         * @param value Spring 动画开始运行时的起始值
         */
        void onPrincipleSpringStart(float value);

        /**
         * @param value Spring 动画停止运行时的终点值
         */
        void onPrincipleSpringStop(float value);

        /**
         * @param value Spring 动画运行时的计算值
         */
        void onPrincipleSpringUpdate(float value);
    }

    private final Spring mSpring;
    private PrincipleSpringListener mListener;
    private boolean mIsActivate;

    public PrincipleSpring(@FloatRange(from = 0.0F) float tension, @FloatRange(from = 0.0F) float friction) {
        mSpring = SpringSystem.create().createSpring()
                .setSpringConfig(new SpringConfig(tension, friction))
                .addListener(this);
    }

    /**
     * @param listener 设置 Spring 动画的监听器
     * @return 当前 PrincipleSpring 实例，可以用于链式调用
     */
    public PrincipleSpring setListener(@Nullable PrincipleSpringListener listener) {
        mListener = listener;
        return this;
    }

    /**
     * 正向运行 Spring 动画；
     * 一般调用这个方法运行 Spring 动画即可
     */
    public void start() {
        mSpring.setEndValue(1.0F);
    }

    /**
     * 按照曲线倒过来运行 Spring 动画；
     * 如果你 {@link PrincipleSpring#start()} 之后想要倒过来运行的话
     */
    public void reset() {
        mSpring.setEndValue(0.0F);
    }

    /**
     * 取消（并重置）Spring 动画
     */
    public void cancel() {
        mSpring.setCurrentValue(0.0F);
    }

    /**
     * 获取 Spring 动画的 tension 值
     */
    @FloatRange(from = 0.0F)
    public float getTension() {
        return (float) mSpring.getSpringConfig().tension;
    }

    /**
     * @return 获取 Spring 动画 friction 值
     */
    @FloatRange(from = 0.0F)
    public float getFriction() {
        return (float) mSpring.getSpringConfig().friction;
    }

    @Override
    public void onSpringEndStateChange(@NonNull Spring spring) {
        // DO NOTHING
    }

    @Override
    public void onSpringActivate(@NonNull Spring spring) {
        if (!mIsActivate) {
            mIsActivate = true;
            if (mListener != null) {
                mListener.onPrincipleSpringStart((float) spring.getCurrentValue());
            }
        }
    }

    @Override
    public void onSpringAtRest(@NonNull Spring spring) {
        if (mIsActivate) {
            mIsActivate = false;
            if (mListener != null) {
                mListener.onPrincipleSpringStop((float) spring.getCurrentValue());
            }
        }
    }

    @Override
    public void onSpringUpdate(@NonNull Spring spring) {
        if (mListener != null) {
            mListener.onPrincipleSpringUpdate((float) spring.getCurrentValue());
        }
    }
}