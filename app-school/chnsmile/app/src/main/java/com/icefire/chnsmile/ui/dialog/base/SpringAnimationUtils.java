package com.icefire.chnsmile.ui.dialog.base;

import android.view.View;

import androidx.annotation.FloatRange;

import com.facebook.rebound.SpringUtil;


public class SpringAnimationUtils {

    /**
     * 启动底部弹出动画
     *
     * @param contentView 动画布局
     */
    public static void startBottomAnim(final View contentView) {
        startBottomAnim(contentView, 300, 27);
    }

    /**
     * 启动底部弹出动画
     *
     * @param contentView 动画布局
     * @param tension 拉力
     * @param friction 阻力
     */
    public static void startBottomAnim(final View contentView, @FloatRange(from = 0.0F) float tension, @FloatRange(from = 0.0F) float friction) {
        new PrincipleSpring(tension, friction).setListener(new PrincipleSpring.PrincipleSpringListener() {
            @Override
            public void onPrincipleSpringStart(float value) {

            }

            @Override
            public void onPrincipleSpringStop(float value) {

            }

            @Override
            public void onPrincipleSpringUpdate(float value) {
                float mappedValue = (float) SpringUtil.mapValueFromRangeToRange(value, 0, 1, contentView.getHeight(), 0);
                contentView.setTranslationY(mappedValue);
            }
        }).start();
    }
}
