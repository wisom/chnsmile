package com.icefire.chnsmile.core.network;

import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;

public class GetRequest<T> extends Request<T, GetRequest> {
    public GetRequest(String url) {
        super(url);
    }

    @Override
    protected okhttp3.Request generateRequest(okhttp3.Request.Builder builder) {
        if (!mUrl.contains(Constants.SERVER_URL_USERS_LOGIN) &&
                !mUrl.contains(Constants.SERVER_URL_GET_PLATFORM) &&
                !mUrl.contains(Constants.WX_LOGIN) &&
                !mUrl.contains(Constants.WX_VERIFY_TOKEN) &&
                !mUrl.contains(Constants.WX_GET_USERINFO) &&
                !mUrl.contains(Constants.WX_GET_ACCESS_TOKEN) &&
                !mUrl.contains(Constants.WX_REFRESH_ACCESS_TOKEN)
        ) {
            String deviceToken = ConfigurationManager.instance().getString(Constants.PREF_KEY_SESSION);
            builder.addHeader("Authorization", "Bearer " + deviceToken);
        }
        //get 请求把参数拼接在 url后面
        String url = UrlCreator.createUrlFromParams(mUrl, params);
        okhttp3.Request request = builder.get().url(url).build();
        return request;
    }
}
