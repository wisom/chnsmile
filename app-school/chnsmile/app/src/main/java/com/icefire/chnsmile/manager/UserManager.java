package com.icefire.chnsmile.manager;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.model.User;

public class UserManager {

    private static UserManager instance;
    private UserManager(){}

    public static UserManager getInstance() {
        if (instance == null) {
            instance = new UserManager();
        }
        return instance;
    }

    public User getUserInfo() {
        return AccountManager.getUser();
    }

    public boolean isTeacher() {
        User user = getUserInfo();
        return user != null && user.defaultIdentity == 2;
    }

    public boolean isFamily() {
        User user = getUserInfo();
        return user != null && user.defaultIdentity == 1;
    }

}
