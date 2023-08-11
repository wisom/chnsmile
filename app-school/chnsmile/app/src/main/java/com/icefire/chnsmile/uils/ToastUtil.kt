package com.icefire.chnsmile.uils

import android.view.Gravity
import android.widget.Toast
import com.icefire.chnsmile.MainApplication

/**
 * @desc   : 吐司工具类
 * @date   : 2020/1/2
 * @author : lijianbin
 */
class ToastUtil {

    companion object {
        @JvmStatic
        fun showLongToast(text: String) {
            val view = Toast.makeText(MainApplication.getInstance(), "", Toast.LENGTH_LONG).view
            val toast = Toast(MainApplication.getInstance())
            toast.setGravity(Gravity.TOP, 0, DensityUtil.dp2px(60))
            toast.view = view
            toast.setText(text)
            toast.duration = Toast.LENGTH_LONG
            toast.show()
        }

        @JvmStatic
        fun showLongToast(textRes: Int) {
            val view = Toast.makeText(MainApplication.getInstance(), "", Toast.LENGTH_LONG).view
            val toast = Toast(MainApplication.getInstance())
            toast.setGravity(Gravity.TOP, 0, DensityUtil.dp2px(60))
            toast.view = view
            toast.setText(textRes)
            toast.duration = Toast.LENGTH_LONG
            toast.show()
        }

        @JvmStatic
        fun showToast(text: String) {
            val view = Toast.makeText(MainApplication.getInstance(), "", Toast.LENGTH_SHORT).view
            val toast = Toast(MainApplication.getInstance())
            toast.setGravity(Gravity.TOP, 0, DensityUtil.dp2px(60))
            toast.view = view
            toast.setText(text)
            toast.duration = Toast.LENGTH_SHORT
            toast.show()
        }

        @JvmStatic 
        fun showToast(textRes: Int) {
            val view = Toast.makeText(MainApplication.getInstance(), "", Toast.LENGTH_SHORT).view
            val toast = Toast(MainApplication.getInstance())
            toast.setGravity(Gravity.TOP, 0, DensityUtil.dp2px(60))
            toast.view = view
            toast.setText(textRes)
            toast.duration = Toast.LENGTH_SHORT
            toast.show()
        }
    }
}