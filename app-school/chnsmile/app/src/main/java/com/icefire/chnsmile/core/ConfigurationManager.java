/**
 * Created by Chao (@chao.red)
 * Copyright (c) 2013, 2014, Travor. All rights reserved.
 * @author Chao chao.red@gmail.com 
 * @date 2014年3月12日 上午11:19:48  
 */
package com.icefire.chnsmile.core;

import android.app.Application;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.preference.PreferenceManager;

import com.icefire.chnsmile.uils.ByteUtils;
import com.icefire.chnsmile.uils.StringUtils;

import java.io.File;
import java.util.Map;
import java.util.Map.Entry;

public class ConfigurationManager {

	private final SharedPreferences preferences;
	private final Editor editor;

	private final ConfigurationDefaults defaults;

	private static ConfigurationManager instance;

	public synchronized static void create(Application context) {
		if (instance != null) {
			return;
		}
		instance = new ConfigurationManager(context);
	}

	public static ConfigurationManager instance() {
		if (instance == null) {
			throw new RuntimeException("ConfigurationManager not created");
		}
		return instance;
	}

	private ConfigurationManager(Application context) {
		preferences = PreferenceManager.getDefaultSharedPreferences(context);
		editor = preferences.edit();

		defaults = new ConfigurationDefaults();

		initPreferences();
	}

	public void remove(String key) {
		editor.remove(key);
		editor.commit();
	}

	public String getString(String key) {
		return preferences.getString(key, "");
	}

	public void setString(String key, String value) {
		editor.putString(key, value);
		editor.commit();
	}

	public int getInt(String key) {
		return preferences.getInt(key, 0);
	}

	public void setInt(String key, int value) {
		editor.putInt(key, value);
		editor.commit();
	}

	public long getLong(String key) {
		return preferences.getLong(key, 0);
	}

	public void setLong(String key, long value) {
		editor.putLong(key, value);
		editor.commit();
	}

	public boolean getBoolean(String key) {
		return preferences.getBoolean(key, false);
	}

	public void setBoolean(String key, boolean value) {
		editor.putBoolean(key, value);
		editor.commit();
	}

	public File getFile(String key) {
		return new File(preferences.getString(key, ""));
	}

	public void setFile(String key, File value) {
		editor.putString(key, value.getAbsolutePath());
		editor.commit();
	}

	public byte[] getByteArray(String key) {
		String str = getString(key);

		if (StringUtils.isNullOrEmpty(str)) {
			return null;
		}

		return ByteUtils.decodeHex(str);
	}

	public void setByteArray(String key, byte[] value) {
		setString(key, ByteUtils.encodeHex(value));
	}

	public void resetToDefaults() {
		resetToDefaults(defaults.getDefaultValues());
	}

	public void resetToDefault(String key) {
		if (defaults != null) {
			Map<String, Object> defaultValues = defaults.getDefaultValues();
			if (defaultValues != null && defaultValues.containsKey(key)) {
				Object defaultValue = defaultValues.get(key);
				initPreference(key, defaultValue, true);
			}
		}
	}

	public void registerOnPreferenceChange(OnSharedPreferenceChangeListener listener) {
		preferences.registerOnSharedPreferenceChangeListener(listener);
	}

	public void unregisterOnPreferenceChange(OnSharedPreferenceChangeListener listener) {
		preferences.unregisterOnSharedPreferenceChangeListener(listener);
	}

	private void initPreferences() {
		for (Entry<String, Object> entry : defaults.getDefaultValues().entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();
			initPreference(key, value, false);
		}

		// there are some configuration values that need to be reset every time
		// to a desired value
		resetToDefaults(defaults.getResetValues());
	}

	private void initPreference(String key, Object value, boolean force) {
		if (value instanceof String) {
			initStringPreference(key, (String) value, force);
		} else if (value instanceof Integer) {
			initIntPreference(key, (Integer) value, force);
		} else if (value instanceof Long) {
			initLongPreference(key, (Long) value, force);
		} else if (value instanceof Boolean) {
			initBooleanPreference(key, (Boolean) value, force);
		} else if (value instanceof byte[]) {
			initByteArrayPreference(key, (byte[]) value, force);
		} else if (value instanceof File) {
			initFilePreference(key, (File) value, force);
		}
	}

	private void initStringPreference(String prefKeyName, String defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setString(prefKeyName, defaultValue);
		}
	}

	private void initByteArrayPreference(String prefKeyName, byte[] defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setByteArray(prefKeyName, defaultValue);
		}
	}

	private void initBooleanPreference(String prefKeyName, boolean defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setBoolean(prefKeyName, defaultValue);
		}
	}

	private void initIntPreference(String prefKeyName, int defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setInt(prefKeyName, defaultValue);
		}
	}

	private void initLongPreference(String prefKeyName, long defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setLong(prefKeyName, defaultValue);
		}
	}

	private void initFilePreference(String prefKeyName, File defaultValue, boolean force) {
		if (!preferences.contains(prefKeyName) || force) {
			setFile(prefKeyName, defaultValue);
		}
	}

	private void resetToDefaults(Map<String, Object> map) {
		for (Entry<String, Object> entry : map.entrySet()) {
			if (entry.getValue() instanceof String) {
				setString(entry.getKey(), (String) entry.getValue());
			} else if (entry.getValue() instanceof Integer) {
				setInt(entry.getKey(), (Integer) entry.getValue());
			} else if (entry.getValue() instanceof Long) {
				setLong(entry.getKey(), (Long) entry.getValue());
			} else if (entry.getValue() instanceof Boolean) {
				setBoolean(entry.getKey(), (Boolean) entry.getValue());
			} else if (entry.getValue() instanceof byte[]) {
				setByteArray(entry.getKey(), (byte[]) entry.getValue());
			} else if (entry.getValue() instanceof File) {
				setFile(entry.getKey(), (File) entry.getValue());
			}
		}
	}
}