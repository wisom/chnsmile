package com.icefire.chnsmile.uils

import android.content.Context
import android.view.WindowManager
import com.icefire.chnsmile.MainApplication

/**
 * title: 尺寸相关工具类
 * author: huangyu
 * created on: 2019/12/27
 */
class DensityUtil {

    companion object {

        @JvmStatic
        fun getDensity(): Float {
            return MainApplication.getInstance().resources.displayMetrics.density
        }

        /**
         * dp转px
         * @param dp
         * @return
         */
        @JvmStatic
        fun dp2px(dp: Int): Int {
            val density = MainApplication.getInstance().resources.displayMetrics.density
            val px = (dp * density + 0.5f)
            return px.toInt()
        }

        /**
         * px转dp
         * @param px
         * @return
         */
        @JvmStatic
        fun px2dp(px: Int): Float {
            val density = MainApplication.getInstance().resources.displayMetrics.density
            return px / density
        }

        /**
         * 获取屏幕高度
         */
        @JvmStatic
        fun getScreenHeight(): Int {
            val windowManager: WindowManager =
                MainApplication.getInstance().getSystemService(Context.WINDOW_SERVICE) as WindowManager
            return windowManager.defaultDisplay.height
        }

        /**
         * 获取屏幕宽度
         */
        @JvmStatic
        fun getScreenWidth(): Int {
            val windowManager: WindowManager =
                MainApplication.getInstance().getSystemService(Context.WINDOW_SERVICE) as WindowManager
            return windowManager.defaultDisplay.width
        }

    }
}