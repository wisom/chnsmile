package com.icefire.chnsmile.core.network;

import com.blankj.utilcode.util.SPUtils;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import okhttp3.Headers;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/*
 * Created by chao.fan on 2020/8/11.
 */
public class ParamsInterceptor implements Interceptor {
    private Map<String, String> headerParamsMap = new HashMap<>(); // 公共 Headers 添加
    private List<String> headerLinesList = new ArrayList<>(); // 消息头 集合形式，一次添加一行;

    private ParamsInterceptor() {
    }

    @NotNull
    @Override
    public Response intercept(@NotNull Chain chain) throws IOException {
        Request request = chain.request();
        String path = request.url().url().getPath();
        Request.Builder requestBuilder = request.newBuilder();
        // header
        Headers.Builder headerBuilder = request.headers().newBuilder();
        if (headerParamsMap.size() > 0) {
            Iterator iterator = headerParamsMap.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry entry = (Map.Entry) iterator.next();
                String key = (String) entry.getKey();
                String value = (String) entry.getValue();
                if (path.contains("app/device/token")) {
                    continue;
                }
                if (key.equals("Authorization")) {
                    value = "Bearer " + SPUtils.getInstance().getString("deviceToken");
                }
                if (path.contains("notarization/third/login")) {
                    if (key.equals("Authorization")) {
                        value = "";
                    }
                }
                headerBuilder.add(key, value);
            }
            requestBuilder.headers(headerBuilder.build());
        }

        // 以 String 形式添加消息头
        if (headerLinesList.size() > 0) {
            for (String line: headerLinesList) {
                headerBuilder.add(line);
            }
            requestBuilder.headers(headerBuilder.build());
        }

        request = requestBuilder.build();
        return chain.proceed(request);
    }

    public static class Builder {
        ParamsInterceptor mInterceptor;

        public Builder() {
            mInterceptor = new ParamsInterceptor();
        }

        // 添加公共参数到消息头
        public Builder addHeaderParam(String key, String value) {
            mInterceptor.headerParamsMap.put(key, value);
            return this;
        }

        // 添加公共参数到消息头
        public Builder addHeaderParamsMap(Map<String, String> headerParamsMap) {
            mInterceptor.headerParamsMap.putAll(headerParamsMap);
            return this;
        }

        // 添加公共参数到消息头
        public Builder addHeaderLine(String headerLine) {
            int index = headerLine.indexOf(":");
            if (index == -1) {
                throw new IllegalArgumentException("Unexpected header: " + headerLine);
            }
            mInterceptor.headerLinesList.add(headerLine);
            return this;
        }

        // 添加公共参数到消息头
        public Builder addHeaderLinesList(List<String> headerLinesList) {
            for (String headerLine: headerLinesList) {
                int index = headerLine.indexOf(":");
                if (index == -1) {
                    throw new IllegalArgumentException("Unexpected header: " + headerLine);
                }
                mInterceptor.headerLinesList.add(headerLine);
            }
            return this;
        }

        public ParamsInterceptor build() {
            return mInterceptor;
        }
    }
}
