package com.icefire.chnsmile.core.jsbridge;

import com.blankj.utilcode.util.LogUtils;
import com.github.lzyzsd.jsbridge.BridgeHandler;
import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.icefire.chnsmile.core.Constants;

public class TestJSBridge implements JSBridge {

    @Override
    public void registHandler(BridgeWebView bridgeWebView) {
        bridgeWebView.registerHandler(Constants.JSBRIDGE_TEST, new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LogUtils.i("data: " + data);
                function.onCallBack("submitFromWeb exe, response data 中文 from Java");
            }
        });
    }
}
