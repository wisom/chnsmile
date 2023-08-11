package com.icefire.chnsmile.core.network;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

public class JsonConvert implements Convert {
    //默认的Json转 Java Bean的转换器
    @Override
    public Map<String, Object> convert(String response, Type type) {
        JSONObject jsonObject = JSON.parseObject(response);
        Object data = null;
        if (jsonObject.get("data") instanceof JSONArray) {
            data = jsonObject.getJSONArray("data");
        } else if (jsonObject.get("data") instanceof String) {
            data = jsonObject.getString("data");
        } else if (jsonObject.get("data") instanceof Boolean) {
            data = jsonObject.getBoolean("data");
        } else {
            data = jsonObject.getJSONObject("data");
        }
        int code = jsonObject.getIntValue("code");
        String message = jsonObject.getString("message");
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("message", message);
        if (data != null) {
            if (data instanceof String) {
                map.put("data", data);
            } else {
                map.put("data", JSON.parseObject(data.toString(), type));
            }
        } else {
            map.put("data", null);
        }
        return map;
    }
}
