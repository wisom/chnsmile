package com.icefire.chnsmile.core.network;

import java.lang.reflect.Type;
import java.util.Map;

public interface Convert {
    Map<String, Object> convert(String response, Type type);
}
