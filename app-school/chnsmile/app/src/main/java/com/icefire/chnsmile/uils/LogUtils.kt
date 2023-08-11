package com.icefire.chnsmile.uils

import android.util.Log


class LogUtils {

    companion object {
        var isShowLog = true

        @JvmStatic
        @JvmOverloads
        fun d(
            tag: String,
            msg: String,
            isShowStack: Boolean = false,
            showStackCount: Int = 3,
            isShowThread: Boolean = false
        ) {
            doPrintln(tag, msg, isShowStack, showStackCount, isShowThread) { t, m ->
                Log.d(t, m)
            }
        }

        @JvmStatic
        @JvmOverloads
        fun e(
            tag: String,
            msg: String,
            isShowStack: Boolean = false,
            showStackCount: Int = 3,
            isShowThread: Boolean = false
        ) {
            doPrintln(tag, msg, isShowStack, showStackCount, isShowThread) { t, m ->
                Log.e(t, m)
            }
        }

        private fun isCompleteOutput(msg: String): Boolean = msg.length <= 3 * 1024

        private fun doPrintln(
            tag: String,
            msg: String,
            isShowStack: Boolean,
            showStackCount: Int,
            isShowThread: Boolean,
            log: (String, String) -> Unit
        ) {
            if (isShowLog) {
                if (isCompleteOutput(msg)) {
                    if (isShowThread) {
                        log(tag, "Thread-${Thread.currentThread().name}，${msg}")
                    } else {
                        log(tag, msg)
                    }
                } else {
                    val list = segment(msg)
                    for (i in list!!.indices) {
                        if (isShowThread && i == 0) {
                            log(tag, "Thread-${Thread.currentThread().name}，${list[i]}")
                        } else {
                            log(tag, list[i])
                        }
                    }
                }
                if (isShowStack) {
                    val stackTraceArray = Thread.currentThread().stackTrace.drop(5).take(showStackCount)
                    stackTraceArray.forEach {
                        log(tag, "${it.className}：${it.methodName}")
                    }
                }
            }
        }

        private fun segment(message: String): List<String>? {
            var msg = message
            val segmentSize = 3 * 1024
            val list: MutableList<String> = ArrayList()
            while (msg.length > segmentSize) {
                val logContent = msg.substring(0, segmentSize)
                msg = msg.replace(logContent, "")
                list.add(logContent)
            }
            list.add(msg)
            return list
        }
    }
}