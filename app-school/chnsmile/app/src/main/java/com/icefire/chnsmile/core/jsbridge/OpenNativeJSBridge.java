package com.icefire.chnsmile.core.jsbridge;

import com.alibaba.fastjson.JSON;
import com.blankj.utilcode.util.LogUtils;
import com.github.lzyzsd.jsbridge.BridgeHandler;
import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;

public class OpenNativeJSBridge implements JSBridge {

    @Override
    public void registHandler(BridgeWebView bridgeWebView) {
        bridgeWebView.registerHandler(Constants.JSBRIDGE_OPEN_NATIVE, new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                try {
                    LogUtils.i("data: " + data);
                    String url = JSON.parseObject(data).getString("url");
                    Router.open("smile://" + url);
                    function.onCallBack("success");
                } catch (Exception e) {
                    LogUtils.e(e.getMessage());
                    function.onCallBack("fail: " + e.toString());
                }
            }
        });
    }
}
