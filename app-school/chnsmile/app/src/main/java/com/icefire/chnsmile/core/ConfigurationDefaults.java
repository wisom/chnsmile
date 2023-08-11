/**
 * Created by Chao (@chao.red)
 * Copyright (c) 2013, 2014, Travor. All rights reserved.
 *
 * @author Chao chao.red@gmail.com
 * @date 2014年3月12日 上午11:19:48
 */

package com.icefire.chnsmile.core;

import android.os.Environment;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

final class ConfigurationDefaults {

    private final Map<String, Object> defaultValues;
    private final Map<String, Object> resetValues;

    public ConfigurationDefaults() {
        defaultValues = new HashMap<String, Object>();
        resetValues = new HashMap<String, Object>();
        load();
    }

    public Map<String, Object> getDefaultValues() {
        return Collections.unmodifiableMap(defaultValues);
    }

    public Map<String, Object> getResetValues() {
        return Collections.unmodifiableMap(resetValues);
    }

    private void load() {
        defaultValues.put(Constants.PREF_KEY_STORAGE_PATH, Environment.getExternalStorageDirectory().getAbsolutePath());
        defaultValues.put(Constants.PREF_KEY_FIRST_ENTER, true);

        resetValue(Constants.PREF_KEY_SESSION);
    }

    private void resetValue(String key) {
        resetValues.put(key, defaultValues.get(key));
    }
}
