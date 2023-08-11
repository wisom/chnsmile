package com.icefire.chnsmile.core.network;

import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;

import okhttp3.MediaType;
import okhttp3.RequestBody;

public class PostRequest<T> extends Request<T, PostRequest> {
    public PostRequest(String url) {
        super(url);
    }

    @Override
    protected okhttp3.Request generateRequest(okhttp3.Request.Builder builder) {
        //post请求表单提交
//        FormBody.Builder bodyBuilder = new FormBody.Builder();
//        for (Map.Entry<String, Object> entry : params.entrySet()) {
//            bodyBuilder.add(entry.getKey(), String.valueOf(entry.getValue()));
//        }
        if (!mUrl.contains(Constants.SERVER_URL_USERS_LOGIN) &&
                !mUrl.contains(Constants.WX_LOGIN) &&
                !mUrl.contains(Constants.WX_VERIFY_TOKEN) &&
                !mUrl.contains(Constants.WX_GET_USERINFO) &&
                !mUrl.contains(Constants.WX_GET_ACCESS_TOKEN) &&
                !mUrl.contains(Constants.WX_REFRESH_ACCESS_TOKEN)) {
            String deviceToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_SESSION);
            builder.addHeader("Authorization", "Bearer " + deviceToken);
        }
        // application json提交
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        RequestBody body = RequestBody.create(JSON, com.alibaba.fastjson.JSON.toJSONString(params));

        okhttp3.Request request = builder.url(mUrl).post(body).build();
        return request;
    }
}
