package com.icefire.chnsmile.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.ToastUtils;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.model.User;
import com.icefire.chnsmile.uils.TUIUtils;
import com.tencent.imsdk.v2.V2TIMCallback;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.qcloud.tuicore.TUIConstants;
import com.tencent.qcloud.tuicore.TUICore;

@Route(path = Constants.SP_CHAT)
public class ChatActivity extends BaseActivity {
    @Autowired
    String id;

    @Autowired
    String name;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        User user = AccountManager.getUser();
//        TUIUtils.login(user.id, user.imUserSign, new V2TIMCallback() {
//            @Override
//            public void onError(final int code, final String desc) {
//            }
//
//            @Override
//            public void onSuccess() {
//            }
//        });
        if (ConfigurationManager.instance().getBoolean(Constants.PREF_KEY_IM_ERROR_STATUS)) {
            ToastUtils.showShort(R.string.im_error_status);
            finish();
            return;
        }
        try {
            Bundle param = new Bundle();
            param.putInt(TUIConstants.TUIChat.CHAT_TYPE, V2TIMConversation.V2TIM_C2C);
            param.putString(TUIConstants.TUIChat.CHAT_ID, id);
            param.putString(TUIConstants.TUIChat.CHAT_NAME, name);
            TUICore.startActivity(TUIConstants.TUIChat.C2C_CHAT_ACTIVITY_NAME, param);
            finish();
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
}
